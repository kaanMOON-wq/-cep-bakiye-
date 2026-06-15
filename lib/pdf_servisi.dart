import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfServisi {
  static Future<void> raporUret(
    List<Map<String, dynamic>> aktifIslemler,
    List<Map<String, dynamic>> gecmisIslemler,
  ) async {
    final pdf = pw.Document();

    // 1. DÜZELTME: İtalik fontu da sisteme indirip tanıtıyoruz
    final ttfRegular = await PdfGoogleFonts.robotoRegular();
    final ttfBold = await PdfGoogleFonts.robotoBold();
    final ttfItalic = await PdfGoogleFonts.robotoItalic();

    double toplamBorc = 0.0;
    double toplamAlacak = 0.0;

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
    double netBakiye = toplamAlacak - toplamBorc;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        // 2. DÜZELTME: Eğik yazıları da (italic) temamıza bağladık
        theme: pw.ThemeData.withFont(
          base: ttfRegular,
          bold: ttfBold,
          italic: ttfItalic,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "CEP BAKİYE",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#0d9488'),
                        ),
                      ),
                      pw.Text(
                        "Finansal Durum ve Ekstre Raporu",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColor.fromHex('#64748b'),
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "Tarih: ${DateTime.now().toString().substring(0, 10)}",
                        style: pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColor.fromHex('#e2e8f0'), thickness: 2),
              pw.SizedBox(height: 20),

              // 3. DÜZELTME: Sembol hatasını (も) önlemek için TL kısaltmasına geçtik
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _ozetKarti(
                    "Toplam Alacak",
                    "+$toplamAlacak TL",
                    PdfColor.fromHex('#10b981'),
                    ttfBold,
                  ),
                  _ozetKarti(
                    "Toplam Borç",
                    "-$toplamBorc TL",
                    PdfColor.fromHex('#ef4444'),
                    ttfBold,
                  ),
                  _ozetKarti(
                    "Net Kasa",
                    "$netBakiye TL",
                    PdfColor.fromHex('#0d9488'),
                    ttfBold,
                    isDark: true,
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              pw.Text(
                "Aktif İşlemler",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _tabloOlustur(aktifIslemler),

              pw.SizedBox(height: 30),

              pw.Spacer(),
              pw.Divider(color: PdfColor.fromHex('#e2e8f0')),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  "* Bu rapor 'Cep Bakiye' mobil uygulaması tarafından otomatik üretilmiştir.",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromHex('#94a3b8'),
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'cep_bakiye_rapor_${DateTime.now().toString().substring(0, 10)}.pdf',
    );
  }

  static pw.Widget _ozetKarti(
    String baslik,
    String deger,
    PdfColor renk,
    pw.Font font, {
    bool isDark = false,
  }) {
    return pw.Container(
      width: 140,
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: isDark
            ? PdfColor.fromHex('#f0fdfa')
            : PdfColor.fromHex('#f8fafc'),
        border: pw.Border.all(
          color: isDark
              ? PdfColor.fromHex('#ccfbf1')
              : PdfColor.fromHex('#e2e8f0'),
        ),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            baslik,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromHex('#64748b'),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            deger,
            style: pw.TextStyle(
              font: font,
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tabloOlustur(List<Map<String, dynamic>> veriler) {
    if (veriler.isEmpty) {
      return pw.Text("Kayıt bulunamadı.", style: pw.TextStyle(fontSize: 12));
    }

    return pw.TableHelper.fromTextArray(
      context: null,
      headers: ['İşlem Adı', 'Tür', 'Vade', 'Miktar'],
      data: veriler.map((item) {
        bool isDebt = item['isDebt'].toString() == '1';
        return [
          item['name'],
          isDebt ? 'Borç' : 'Alacak',
          item['dueDate']?.toString().substring(0, 10) ?? '-',
          "${item['amount']} TL",
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColor.fromHex('#ffffff'),
      ),
      headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#64748b')),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColor.fromHex('#e2e8f0'), width: .5),
        ),
      ),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }
}
