import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'db_helper.dart';
import 'debt_model.dart';
import 'main.dart';
import 'widgets/glass_container.dart';

class YeniKayitSayfasi extends StatefulWidget {
  final Debt? debt;
  const YeniKayitSayfasi({super.key, this.debt});

  @override
  State<YeniKayitSayfasi> createState() => _YeniKayitSayfasiState();
}

class _YeniKayitSayfasiState extends State<YeniKayitSayfasi> {
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _miktarController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  int _secilenTaksit = 1;
  DateTime? _secilenTarih;
  bool _isDebt = true;

  @override
  void initState() {
    super.initState();
    if (widget.debt != null) {
      _isimController.text = widget.debt!.name;
      _miktarController.text = widget.debt!.amount.toString();
      _aciklamaController.text = widget.debt!.description ?? '';
      _isDebt = widget.debt!.isDebt;
      if (widget.debt!.dueDate != null) {
        _secilenTarih = DateTime.tryParse(widget.debt!.dueDate!);
      }
    }
  }

  @override
  void dispose() {
    _isimController.dispose();
    _miktarController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  Widget _buildGlassTextField(
    String label,
    IconData icon,
    TextEditingController controller,
    bool isDark, {
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.8),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          prefixIcon: Icon(
            icon,
            color: isDark
                ? Colors.tealAccent.withValues(alpha: 0.7)
                : Colors.teal.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown(
    String label,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.8),
        ),
      ),
      child: DropdownButtonFormField<int>(
        value: _secilenTaksit,
        dropdownColor: isDark ? const Color(0xFF203A43) : Colors.white,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          prefixIcon: Icon(
            icon,
            color: isDark
                ? Colors.tealAccent.withValues(alpha: 0.7)
                : Colors.teal.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        items: List.generate(12, (index) => index + 1).map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value == 1 ? "Tek Çekim" : "$value Taksit",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: (int? newValue) {
          if (newValue != null) {
            setState(() {
              _secilenTaksit = newValue;
            });
          }
        },
      ),
    );
  }

  Future<void> _kaydet() async {
    if (_isimController.text.isEmpty || _miktarController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Lütfen isim ve miktar girin!"),
          backgroundColor: Colors.redAccent.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      if (widget.debt != null) {
        await DBHelper.instance.updateDebt(Debt(
          id: widget.debt!.id,
          name: _isimController.text,
          amount: double.tryParse(_miktarController.text) ?? 0.0,
          isDebt: _isDebt,
          date: widget.debt!.date,
          dueDate: _secilenTarih?.toIso8601String(),
          description: _aciklamaController.text,
          isPaid: widget.debt!.isPaid,
        ));
      } else {
        int taksitSayisi = _secilenTaksit;
        double totalAmount = double.tryParse(_miktarController.text) ?? 0.0;

        if (taksitSayisi <= 1) {
          await DBHelper.instance.insertDebt(Debt(
            name: _isimController.text,
            amount: totalAmount,
            isDebt: _isDebt,
            date: DateTime.now().toIso8601String(),
            dueDate: _secilenTarih?.toIso8601String(),
            description: _aciklamaController.text,
          ));
        } else {
          double taksitTutari = totalAmount / taksitSayisi;
          double yuvarlanmis = double.parse(taksitTutari.toStringAsFixed(2));
          double sonTaksit = totalAmount - (yuvarlanmis * (taksitSayisi - 1));
          sonTaksit = double.parse(sonTaksit.toStringAsFixed(2));

          for (int i = 0; i < taksitSayisi; i++) {
            DateTime taksitTarihi = _secilenTarih ?? DateTime.now();
            taksitTarihi = DateTime(
              taksitTarihi.year,
              taksitTarihi.month + i,
              taksitTarihi.day,
            );
            
            String desc = _aciklamaController.text;
            String taksitDesc = "${i + 1}/$taksitSayisi Taksit";
            if (desc.isNotEmpty) {
               taksitDesc = "$taksitDesc - $desc";
            }
            
            double currentAmount = (i == taksitSayisi - 1) ? sonTaksit : yuvarlanmis;

            await DBHelper.instance.insertDebt(Debt(
              name: _isimController.text,
              amount: currentAmount,
              isDebt: _isDebt,
              date: DateTime.now().toIso8601String(),
              dueDate: taksitTarihi.toIso8601String(),
              description: taksitDesc,
            ));
          }
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Kayıt başarısız: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: isDark ? Colors.white : Colors.black87,
          title: Text(
            widget.debt != null ? "İşlemi Düzenle" : "Yeni İşlem",
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: GlassContainer(
            isDark: isDark,
            borderRadius: 20,
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isDebt = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: _isDebt
                                  ? (isDark
                                        ? Colors.redAccent.withValues(alpha: 0.2)
                                        : Colors.red.withValues(alpha: 0.1))
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: _isDebt
                                  ? Border.all(
                                      color: isDark
                                          ? Colors.redAccent.withValues(alpha: 0.5)
                                          : Colors.red.shade300,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "Vereceğim (Borç)",
                                style: TextStyle(
                                  color: _isDebt
                                      ? (isDark
                                            ? Colors.redAccent
                                            : Colors.red.shade700)
                                      : (isDark
                                            ? Colors.white54
                                            : Colors.black54),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isDebt = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !_isDebt
                                  ? (isDark
                                        ? Colors.tealAccent.withValues(alpha: 0.2)
                                        : Colors.teal.withValues(alpha: 0.1))
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: !_isDebt
                                  ? Border.all(
                                      color: isDark
                                          ? Colors.tealAccent.withValues(alpha: 0.5)
                                          : Colors.teal.shade300,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "Alacağım (Tahsilat)",
                                style: TextStyle(
                                  color: !_isDebt
                                      ? (isDark
                                            ? Colors.tealAccent
                                            : Colors.teal.shade700)
                                      : (isDark
                                            ? Colors.white54
                                            : Colors.black54),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                _buildGlassTextField(
                  "İşlem / Kişi Adı",
                  Icons.person_outline_rounded,
                  _isimController,
                  isDark,
                ).animate().fade(delay: 100.ms).slideY(begin: 0.1, end: 0),
                _buildGlassTextField(
                  "Tutar (₺)",
                  Icons.attach_money_rounded,
                  _miktarController,
                  isDark,
                  type: TextInputType.number,
                ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                if (widget.debt == null)
                  _buildGlassDropdown(
                    "Taksit Seçimi",
                    Icons.format_list_numbered_rounded,
                    isDark,
                  ).animate().fade(delay: 250.ms).slideY(begin: 0.1, end: 0),
                _buildGlassTextField(
                  "Kısa Açıklama (İsteğe Bağlı)",
                  Icons.notes_rounded,
                  _aciklamaController,
                  isDark,
                ).animate().fade(delay: 300.ms).slideY(begin: 0.1, end: 0),

                GestureDetector(
                  onTap: () async {
                    final tarih = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: isDark
                                ? ColorScheme.dark(
                                    primary: Colors.tealAccent,
                                    onPrimary: Colors.black,
                                    surface: const Color(0xFF1E1E1E),
                                    onSurface: Colors.white,
                                  )
                                : ColorScheme.light(
                                    primary: Colors.teal.shade600,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (tarih != null) setState(() => _secilenTarih = tarih);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          color: isDark
                              ? Colors.tealAccent.withValues(alpha: 0.7)
                              : Colors.teal.shade500,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _secilenTarih == null
                              ? "Vade Tarihi Seç"
                              : "Vade: ${_secilenTarih.toString().substring(0, 10)}",
                          style: TextStyle(
                            color: _secilenTarih == null
                                ? (isDark ? Colors.white54 : Colors.black54)
                                : (isDark ? Colors.white : Colors.black87),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),

                ElevatedButton(
                  onPressed: _kaydet,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: isDark
                        ? Colors.tealAccent.shade400
                        : Colors.teal.shade600,
                    foregroundColor: isDark ? Colors.black87 : Colors.white,
                    elevation: 10,
                    shadowColor: isDark
                        ? Colors.tealAccent.withValues(alpha: 0.5)
                        : Colors.teal.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.debt != null ? "GÜNCELLE" : "KASAYA EKLE",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ).animate().fade(delay: 500.ms).scaleXY(begin: 0.9, end: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
