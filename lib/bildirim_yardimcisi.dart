import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BildirimYardimcisi {
  // Telefonun bildirim sistemine erişmek için kullanılan ana motor nesnesi
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // 1. SİSTEMİ BAŞLATMA (Uygulama ilk açıldığında main.dart içinde çağrılır)
  static Future<void> init() async {
    // Dünyadaki tüm saat dilimlerini (Timezone) yükler, böylece alarm tam saatinde çalar
    tz.initializeTimeZones();

    // Bildirim geldiğinde üst panelde görünecek olan uygulama ikonunu (sizin eklediğiniz icon.png) ayarlar
    const AndroidInitializationSettings androidAyarlar =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings ayarlar = InitializationSettings(
      android: androidAyarlar,
    );

    // Ayarları sisteme yükler
    await _plugin.initialize(ayarlar);

    // Android 13 ve üzeri yeni telefonlar için kullanıcıdan "Bu uygulama bildirim göndersin mi?" iznini ister
    _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // 2. GELECEĞE ALARM KURMA (yeni_kayit.dart içinde borç eklenirken çağrılır)
  static Future<void> zamanliBildirimKur(
    int id,
    String baslik,
    String icerik,
    DateTime zaman,
  ) async {
    // Eğer hesaplanan alarm saati geçmiş bir zamandaysa (örn: dün) alarm kurmayı iptal eder
    if (zaman.isBefore(DateTime.now())) return;

    // Telefonun hafızasına ileri tarihli alarmı yazar
    await _plugin.zonedSchedule(
      id, // Her bildirimin birbiriyle karışmaması için benzersiz kimlik numarası
      baslik, // Bildirim başlığı (Örn: "Borç Uyarısı: Son 3 Gün!")
      icerik, // Bildirim açıklaması (Örn: "X kişisine olan ödemenize 3 gün kaldı.")
      tz.TZDateTime.from(
        zaman,
        tz.local,
      ), // Alarmın çalacağı tam tarih ve yerel saat dilimi
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'muhasebe_vade_kanali', // Telefonun ayarlarında görünecek bildirim kanalı kimliği
          'Vade Hatırlatıcıları', // Kullanıcının telefon ayarlarında göreceği kanal adı
          channelDescription:
              'Borç ve alacakların son ödeme günü geldiğinde uyarı verir',
          importance: Importance
              .max, // Bildirimi en yüksek önceliğe alır (Ses çıkarır ve ekrana fırlar)
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // Telefon uykuda (ekran kapalı) olsa bile alarmı tam vaktinde çaldırır
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
