import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'db_helper.dart';
import 'yeni_kayit.dart';
import 'debt_model.dart';
import 'main.dart';
import 'pdf_servisi.dart';
import 'widgets/glass_container.dart';
import 'dashboard_sayfasi.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfa = 0;

  Widget _buildVadeDurumu(String dueDateStr, bool isDark) {
    final vadeTarihi = DateTime.parse(dueDateStr);
    final bugun = DateTime.now();
    final sadeceBugun = DateTime(bugun.year, bugun.month, bugun.day);
    final gunFarki = DateTime(
      vadeTarihi.year,
      vadeTarihi.month,
      vadeTarihi.day,
    ).difference(sadeceBugun).inDays;

    if (gunFarki < 0) {
      return _vadeKutusu(
        "${gunFarki.abs()} gün geçti",
        Colors.redAccent,
        Icons.error_outline_rounded,
        isDark,
      );
    } else if (gunFarki == 0) {
      return _vadeKutusu(
        "Bugün son gün",
        Colors.orangeAccent,
        Icons.notification_important_rounded,
        isDark,
      );
    } else {
      return _vadeKutusu(
        "$gunFarki gün kaldı",
        isDark ? Colors.tealAccent : Colors.teal.shade700,
        Icons.hourglass_top_rounded,
        isDark,
      );
    }
  }

  Widget _vadeKutusu(String metin, Color renk, IconData ikon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 14, color: renk),
          const SizedBox(width: 5),
          Text(
            metin,
            style: TextStyle(
              color: renk,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _islem(int id, String isim, bool isDebt, bool isCompleting,
      {int? deleteDbId}) {
    final isDark = themeNotifier.value == ThemeMode.dark;
    final isPermanentDelete = deleteDbId != null;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: GlassContainer(
          isDark: isDark,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPermanentDelete
                    ? "Kalıcı Olarak Sil?"
                    : (isCompleting
                          ? "İşlem Tamamlansın mı?"
                          : "Kayıt Geri Alınsın mı?"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isPermanentDelete
                    ? "'$isim' başlıklı kaydı tamamen silmek istediğinize emin misiniz? Bu işlem geri alınamaz."
                    : (isCompleting
                          ? (isDebt
                                ? "'$isim' borcunu ödediniz ve kasadan düşülecek. Onaylıyor musunuz?"
                                : "'$isim' alacağını tahsil ettiniz ve kasaya eklenecek. Onaylıyor musunuz?")
                          : "'$isim' işlemi iptal edilip tekrar aktif kayıtlara alınacak. Onaylıyor musunuz?"),
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "İptal",
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPermanentDelete
                          ? Colors.red.shade400
                          : (isCompleting
                                ? Colors.teal.shade500
                                : Colors.orange.shade500),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        if (isPermanentDelete) {
                          await DBHelper.instance.deleteDebt(deleteDbId);
                        } else {
                          await DBHelper.instance.durumDegistir(
                            id,
                            isCompleting ? 1 : 0,
                          );
                        }
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        setState(() {});
                      } catch (e) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("İşlem başarısız: $e"),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Text(
                      isPermanentDelete
                          ? "Sil"
                          : (isCompleting ? "Tamamla" : "Geri Al"),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _temaDegistirButonu(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          size: 22,
          color: isDark ? Colors.white : Colors.black87,
        ),
        onPressed: () async {
          themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(
            'isDarkMode',
            themeNotifier.value == ThemeMode.dark,
          );
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        final isDark = currentMode == ThemeMode.dark;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF0F2027),
                      const Color(0xFF203A43),
                      const Color(0xFF2C5364),
                    ]
                  : [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,

            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: GlassContainer(
                isDark: isDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                borderRadius: 30,
                child: BottomNavigationBar(
                  currentIndex: _aktifSayfa,
                  onTap: (index) => setState(() => _aktifSayfa = index),
                  backgroundColor: Colors.transparent,
                  selectedItemColor: isDark
                      ? Colors.tealAccent
                      : Colors.teal.shade800,
                  unselectedItemColor: isDark ? Colors.white54 : Colors.black45,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard_rounded),
                      label: "Özet",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt_rounded),
                      label: "İşlemler",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_balance_wallet_rounded),
                      label: "Kasa & Geçmiş",
                    ),
                  ],
                ),
              ),
            ),

            // KAYIT EKLE BUTONU (Sadece İşlemler sekmesinde)
            floatingActionButton: _aktifSayfa == 1
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child:
                        GestureDetector(
                          onTap: () async {
                            final sonuc = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const YeniKayitSayfasi(),
                              ),
                            );
                            if (sonuc == true) setState(() {});
                          },
                          child: GlassContainer(
                            isDark: isDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            borderRadius: 30,
                            margin: EdgeInsets.zero,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  size: 24,
                                  color: isDark
                                      ? Colors.tealAccent
                                      : Colors.teal.shade800,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Kayıt Ekle",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().scale(
                          delay: 300.ms,
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        ),
                  )
                : null,

            body: _aktifSayfa == 0
                ? DashboardSayfasi()
                : (_aktifSayfa == 1 ? _buildAktifSayfa(isDark) : _buildKasaSayfasi(isDark)),
          ),
        );
      },
    );
  }

  // --- 1. SEKME: AKTİF İŞLEMLER ---
  Widget _buildAktifSayfa(bool isDark) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [Colors.tealAccent, Colors.cyanAccent]
                      : [Colors.teal.shade800, Colors.teal.shade500],
                ).createShader(bounds),
                child: const Text(
                  "CEP BAKİYE",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "Akıllı Finans Sistemi",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [_temaDegistirButonu(isDark)],
          bottom: TabBar(
            indicatorColor: isDark ? Colors.tealAccent : Colors.teal.shade700,
            indicatorWeight: 3,
            labelColor: isDark ? Colors.tealAccent : Colors.teal.shade800,
            unselectedLabelColor: isDark ? Colors.white54 : Colors.black54,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_downward_rounded, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "Borçlarım",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "Alacaklarım",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: DBHelper.instance.getActiveDebts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final aktifler = snapshot.data ?? [];
            return TabBarView(
              children: [
                _buildDetayliListe(
                  aktifler
                      .where((item) => item['isDebt'].toString() == '1')
                      .toList(),
                  true,
                  isDark,
                  true,
                ),
                _buildDetayliListe(
                  aktifler
                      .where((item) => item['isDebt'].toString() == '0')
                      .toList(),
                  false,
                  isDark,
                  true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- 2. SEKME: KASA VE GEÇMİŞ ---
  Widget _buildKasaSayfasi(bool isDark) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.tealAccent, Colors.cyanAccent]
                    : [Colors.teal.shade800, Colors.teal.shade500],
              ).createShader(bounds),
              child: const Text(
                "Kasa & Geçmiş",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "Akıllı Finans Sistemi",
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.picture_as_pdf_rounded,
              color: isDark ? Colors.tealAccent : Colors.teal.shade700,
            ),
            tooltip: "Finansal Rapor",
            onPressed: () async {
              final tumKayitlar = await DBHelper.instance.getDebts();
              await PdfServisi.raporUret(
                tumKayitlar.where((i) => (i['isPaid'] ?? 0) == 0).toList(),
                tumKayitlar.where((i) => (i['isPaid'] ?? 0) == 1).toList(),
              );
            },
          ),
          _temaDegistirButonu(isDark),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHelper.instance.getCompletedDebts(),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
          final gecmisIslemler = snapshot.data ?? [];

          double toplamBorc = 0.0, toplamAlacak = 0.0;
          for (var item in gecmisIslemler) {
            double miktar = item['amount'] is double
                ? item['amount']
                : double.tryParse(item['amount'].toString()) ?? 0.0;
            if (item['isDebt'].toString() == '1') {
              toplamBorc += miktar;
            } else {
              toplamAlacak += miktar;
            }
          }
          double kasaBakiyesi = toplamAlacak - toplamBorc;
          bool kasaEkside = kasaBakiyesi < 0;

          return Column(
            children: [
              GlassContainer(
                isDark: isDark,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 4,
                              centerSpaceRadius: 40,
                              startDegreeOffset: -90,
                              sections: (toplamBorc == 0 && toplamAlacak == 0)
                                  ? [
                                      PieChartSectionData(
                                        value: 1,
                                        color: Colors.grey.withValues(alpha: 0.3),
                                        radius: 15,
                                        showTitle: false,
                                      ),
                                    ]
                                  : [
                                      PieChartSectionData(
                                        value: toplamAlacak,
                                        color: isDark
                                            ? Colors.tealAccent
                                            : Colors.teal.shade500,
                                        radius: 18,
                                        showTitle: false,
                                      ),
                                      PieChartSectionData(
                                        value: toplamBorc,
                                        color: isDark
                                            ? Colors.redAccent
                                            : Colors.red.shade400,
                                        radius: 18,
                                        showTitle: false,
                                      ),
                                    ],
                            ),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),
                          Icon(
                            kasaEkside
                                ? Icons.trending_down_rounded
                                : Icons.account_balance_wallet_rounded,
                            color: kasaEkside
                                ? (isDark
                                      ? Colors.redAccent
                                      : Colors.red.shade400)
                                : (isDark
                                      ? Colors.tealAccent
                                      : Colors.teal.shade500),
                            size: 28,
                          ).animate().fade(delay: 300.ms),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NET DURUM",
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${kasaBakiyesi.toStringAsFixed(2)} ₺",
                            style: TextStyle(
                              color: kasaEkside
                                  ? (isDark
                                        ? Colors.redAccent
                                        : Colors.red.shade600)
                                  : (isDark ? Colors.white : Colors.black87),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.tealAccent
                                      : Colors.teal.shade500,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Gelen: $toplamAlacak ₺",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.redAccent
                                      : Colors.red.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Giden: $toplamBorc ₺",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: -0.1, end: 0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tamamlanan İşlemler",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildDetayliListe(gecmisIslemler, null, isDark, false),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetayliListe(
    List<Map<String, dynamic>> listem,
    bool? isDebtTab,
    bool isDark,
    bool isActive,
  ) {
    if (listem.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.receipt_long_rounded : Icons.history_rounded,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 18),
            Text(
              isActive ? "Bu liste şu an boş." : "Henüz tamamlanmış işlem yok.",
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ).animate().fade().scaleXY(begin: 0.9, end: 1.0),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 120),
      itemCount: listem.length,
      itemBuilder: (context, index) {
        final item = listem[index];
        final bool isItemDebt = isDebtTab ?? (item['isDebt'].toString() == '1');
        String vadeTarihi = item['dueDate'] != null
            ? item['dueDate'].toString().substring(0, 10)
            : "-";
        String aciklama = item['description'] ?? "";
        return GlassContainer(
              isDark: isDark,
              padding: const EdgeInsets.all(16),
              key: ValueKey(item['id']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isItemDebt
                              ? Colors.red.withValues(alpha: isActive ? 0.2 : 0.1)
                              : Colors.green.withValues(alpha: isActive ? 0.2 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isItemDebt
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: isItemDebt
                              ? (isActive
                                    ? (isDark
                                          ? Colors.redAccent
                                          : Colors.red.shade600)
                                    : Colors.red.shade300)
                              : (isActive
                                    ? (isDark
                                          ? Colors.greenAccent
                                          : Colors.green.shade600)
                                    : Colors.green.shade300),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isActive
                                    ? (isDark
                                          ? Colors.white
                                          : const Color(0xFF212529))
                                    : (isDark
                                          ? Colors.white54
                                          : Colors.black45),
                                decoration: isActive
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (aciklama.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                aciklama,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isActive
                                ? "${item['amount']} ₺"
                                : (isItemDebt
                                      ? "- ${item['amount']} ₺"
                                      : "+ ${item['amount']} ₺"),
                            style: TextStyle(
                              color: isItemDebt
                                  ? (isActive
                                        ? (isDark
                                              ? Colors.redAccent
                                              : Colors.red.shade600)
                                        : Colors.red.shade300)
                                  : (isActive
                                        ? (isDark
                                              ? Colors.greenAccent
                                              : Colors.green.shade600)
                                        : Colors.green.shade300),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (isActive)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.check_circle_rounded,
                                    color: isDark
                                        ? Colors.tealAccent
                                        : Colors.teal.shade500,
                                    size: 24,
                                  ),
                                  onPressed: () => _islem(
                                  item['id'],
                                  item['name'],
                                  isItemDebt,
                                  true,
                                ),
                                ),
                              if (!isActive)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.undo_rounded,
                                    color: Colors.orange.shade400,
                                    size: 22,
                                  ),
                                  onPressed: () => _islem(
                                    item['id'],
                                    item['name'],
                                    isItemDebt,
                                    false,
                                  ),
                                ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: isDark
                                      ? Colors.blueAccent
                                      : Colors.blue.shade600,
                                  size: 22,
                                ),
                                onPressed: () async {
                                  final sonuc = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => YeniKayitSayfasi(
                                        debt: Debt.fromMap(item),
                                      ),
                                    ),
                                  );
                                  if (sonuc == true) {
                                    setState(() {});
                                  }
                                },
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: isDark
                                      ? Colors.white30
                                      : Colors.black26,
                                  size: 22,
                                ),
                                onPressed: () => _islem(
                                  -1,
                                  item['name'],
                                  isItemDebt,
                                  false,
                                  deleteDbId: item['id'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isActive) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Vade: $vadeTarihi",
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (item['dueDate'] != null)
                          _buildVadeDurumu(item['dueDate'].toString(), isDark),
                      ],
                    ),
                  ],
                ],
              ),
            )
            .animate(delay: (index * 40).ms)
            .fade(duration: 350.ms)
            .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}
