class Debt {
  final int? id;
  final String name;
  final double amount;
  final String date;
  final String? dueDate;
  final bool isDebt;
  final String? description;
  final bool isPaid;

  Debt({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.dueDate,
    required this.isDebt,
    this.description,
    this.isPaid = false,
  });

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      dueDate: map['dueDate'] as String?,
      isDebt: (map['isDebt'] as int) == 1,
      description: map['description'] as String?,
      isPaid: (map['isPaid'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'dueDate': dueDate,
      'isDebt': isDebt ? 1 : 0,
      'description': description,
      'isPaid': isPaid ? 1 : 0,
    };
  }
}
