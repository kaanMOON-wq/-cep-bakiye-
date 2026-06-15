import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'db_helper.dart';
import 'main.dart';
import 'widgets/glass_container.dart';

class DashboardSayfasi extends StatefulWidget {
  const DashboardSayfasi({super.key});

  @override
  State<DashboardSayfasi> createState() => _DashboardSayfasiState();
}

class _DashboardSayfasiState extends State<DashboardSayfasi> {
  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;

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
              "Finansal Özet",
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
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 22,
              color: isDark ? Colors.tealAccent : Colors.teal.shade700,
            ),
            onPressed: () async {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                'isDarkMode',
                themeNotifier.value == ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder(
          future: Future.wait([
            DBHelper.instance.getActiveDebts(),
            DBHelper.instance.getUpcomingDues(),
            DBHelper.instance.getPersonSummaries(),
          ]),
          builder: (context, AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final aktifKayitlar = snapshot.data?[0] ?? [];
            final yaklasanVadeler = snapshot.data?[1] ?? [];
            final kisiOzetleri = snapshot.data?[2] ?? [];

            double toplamBorc = 0, toplamAlacak = 0;
            for (var item in aktifKayitlar) {
              final miktar = (item['amount'] as num).toDouble();
              if (item['isDebt'].toString() == '1') {
                toplamBorc += miktar;
              } else {
                toplamAlacak += miktar;
              }
            }
            final netBakiye = toplamAlacak - toplamBorc;

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                _buildOzetKartlari(isDark, toplamBorc, toplamAlacak, netBakiye)
                    .animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                _buildYaklasanVadeler(isDark, yaklasanVadeler)
                    .animate().fade(delay: 150.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                _buildKisiOzeti(isDark, kisiOzetleri)
                    .animate().fade(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOzetKartlari(bool isDark, double toplamBorc, double toplamAlacak, double netBakiye) {
    return GlassContainer(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ÖZET DURUM",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ozetKarti("Alacak", "+$toplamAlacak ₺", isDark, Colors.greenAccent, Icons.arrow_upward_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _ozetKarti("Borç", "-$toplamBorc ₺", isDark, Colors.redAccent, Icons.arrow_downward_rounded)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: (netBakiye >= 0 ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Net Bakiye",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  "${netBakiye.toStringAsFixed(2)} ₺",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: netBakiye >= 0
                        ? (isDark ? Colors.greenAccent : Colors.green.shade700)
                        : (isDark ? Colors.redAccent : Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ozetKarti(String label, String value, bool isDark, Color renk, IconData ikon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(ikon, color: renk, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYaklasanVadeler(bool isDark, List<Map<String, dynamic>> vadeler) {
    return GlassContainer(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_rounded, size: 18, color: isDark ? Colors.tealAccent : Colors.teal.shade700),
              const SizedBox(width: 8),
              Text(
                "Yaklaşan Vadeler",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              if (vadeler.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${vadeler.length} adet",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  ),
                ),
            ],
          ),
          if (vadeler.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.greenAccent),
                  const SizedBox(width: 8),
                  Text(
                    "Önümüzdeki 7 günde vadesi gelen işlem yok",
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : Colors.black54),
                  ),
                ],
              ),
            )
          else
            ...vadeler.map((vade) {
              final vadeTarihi = DateTime.parse(vade['dueDate'].toString().substring(0, 10));
              final bugun = DateTime.now();
              final kalanGun = DateTime(vadeTarihi.year, vadeTarihi.month, vadeTarihi.day)
                  .difference(DateTime(bugun.year, bugun.month, bugun.day))
                  .inDays;
              final isDebt = vade['isDebt'].toString() == '1';
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: (isDebt ? Colors.redAccent : Colors.greenAccent).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDebt ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      size: 16,
                      color: isDebt ? Colors.redAccent : Colors.greenAccent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        vade['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${vade['amount']} ₺",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: isDebt ? Colors.redAccent : Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kalanGun <= 1 ? Colors.redAccent.withValues(alpha: 0.2) : Colors.orangeAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        kalanGun == 0 ? "Bugün!" : "$kalanGun gün",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kalanGun <= 1 ? Colors.redAccent : Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildKisiOzeti(bool isDark, List<Map<String, dynamic>> kisiler) {
    return GlassContainer(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_rounded, size: 18, color: isDark ? Colors.tealAccent : Colors.teal.shade700),
              const SizedBox(width: 8),
              Text(
                "Kişi Bazında Durum",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              if (kisiler.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${kisiler.length} kişi",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.tealAccent : Colors.teal.shade800),
                  ),
                ),
            ],
          ),
          if (kisiler.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Icon(Icons.people_outline_rounded, size: 18, color: isDark ? Colors.white60 : Colors.black38),
                  const SizedBox(width: 8),
                  Text(
                    "Henüz kayıtlı işlem yok",
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : Colors.black54),
                  ),
                ],
              ),
            )
          else
            ...kisiler.map((kisi) {
              final toplamBorcKisi = (kisi['totalDebt'] as num?)?.toDouble() ?? 0;
              final toplamAlacakKisi = (kisi['totalReceivable'] as num?)?.toDouble() ?? 0;
              final net = toplamAlacakKisi - toplamBorcKisi;
              final kayitSayisi = kisi['recordCount'] as int? ?? 0;

              return Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: net == 0
                          ? Colors.grey.withValues(alpha: 0.2)
                          : (net > 0 ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.2),
                      child: Icon(
                        net == 0 ? Icons.person_rounded : (net > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded),
                        size: 18,
                        color: net == 0 ? Colors.grey : (net > 0 ? Colors.greenAccent : Colors.redAccent),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kisi['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            "$kayitSayisi işlem",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (toplamBorcKisi > 0)
                          Text(
                            "-$toplamBorcKisi ₺",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.redAccent),
                          ),
                        if (toplamAlacakKisi > 0)
                          Text(
                            "+$toplamAlacakKisi ₺",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.greenAccent),
                          ),
                        Text(
                          "Net: ${net.toStringAsFixed(0)} ₺",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: net == 0
                                ? Colors.grey
                                : (net > 0 ? Colors.greenAccent : Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}