import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'debt_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('debts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE debts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      dueDate TEXT,
      isDebt INTEGER NOT NULL,
      description TEXT,
      isPaid INTEGER DEFAULT 0 
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE debts ADD COLUMN isPaid INTEGER DEFAULT 0');
    }
  }

  Future<int> insertDebt(Debt debt) async {
    final db = await instance.database;
    return await db.insert('debts', debt.toMap());
  }

  Future<List<Map<String, dynamic>>> getDebts() async {
    final db = await instance.database;
    return await db.query('debts', orderBy: 'dueDate ASC');
  }

  Future<List<Map<String, dynamic>>> getActiveDebts() async {
    final db = await instance.database;
    return await db.query(
      'debts',
      where: 'isPaid = ?',
      whereArgs: [0],
      orderBy: 'dueDate ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getCompletedDebts() async {
    final db = await instance.database;
    return await db.query(
      'debts',
      where: 'isPaid = ?',
      whereArgs: [1],
      orderBy: 'dueDate ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getUpcomingDues() async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final weekLater = DateTime.now().add(const Duration(days: 7)).toIso8601String().substring(0, 10);
    return await db.query(
      'debts',
      where: 'isPaid = ? AND dueDate IS NOT NULL AND dueDate >= ? AND dueDate <= ?',
      whereArgs: [0, today, weekLater],
      orderBy: 'dueDate ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getPersonSummaries() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT 
        name,
        SUM(CASE WHEN isDebt = 1 THEN amount ELSE 0 END) as totalDebt,
        SUM(CASE WHEN isDebt = 0 THEN amount ELSE 0 END) as totalReceivable,
        COUNT(*) as recordCount
      FROM debts
      WHERE isPaid = 0
      GROUP BY name
      ORDER BY (SUM(CASE WHEN isDebt = 0 THEN amount ELSE 0 END) - SUM(CASE WHEN isDebt = 1 THEN amount ELSE 0 END)) DESC
    ''');
  }

  Future<int> deleteDebt(int id) async {
    final db = await instance.database;
    return await db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> durumDegistir(int id, int isPaidStatus) async {
    final db = await instance.database;
    return await db.update(
      'debts',
      {'isPaid': isPaidStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateDebt(Debt debt) async {
    final db = await instance.database;
    return await db.update(
      'debts',
      debt.toMap(),
      where: 'id = ?',
      whereArgs: [debt.id],
    );
  }
}
