import Link from 'next/link';

export const metadata = {
  title: 'Cep Bakiye — Gizlilik Politikası',
};

export default function PrivacyPage() {
  return (
    <div className="page-container">
      <Link href="/" className="back-link">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
          <path d="M19 12H5m7-7-7 7 7 7" />
        </svg>
        Ana Sayfa&apos;ya Dön
      </Link>

      <h1>Gizlilik Politikası</h1>
      <div className="last-updated">Son güncelleme: 23 Haziran 2026</div>

      <p>Cep Bakiye, kullanıcılarının gizliliğini en üst düzeyde önemser. Bu gizlilik politikası, uygulamamızı kullanırken hangi verilerin toplandığını, nasıl kullanıldığını ve korunduğunu açıklar.</p>

      <h2>Hangi Verileri Topluyoruz?</h2>
      <p>Cep Bakiye hiçbir kişisel veriyi sunuculara göndermez. Tüm verileriniz yalnızca cihazınızda saklanır:</p>
      <ul>
        <li>Borç ve alacak kayıtlarınız</li>
        <li>Kişi etiketleri ve notlar</li>
        <li>Uygulama tercihleriniz (tema, para birimi vb.)</li>
      </ul>

      <h2>Verileriniz Nerede Saklanıyor?</h2>
      <p>Tüm verileriniz cihazınızın yerel deposunda (localStorage) saklanır. Hiçbir veri üçüncü taraf sunuculara iletilmez, bulutta depolanmaz veya reklam ağlarıyla paylaşılmaz.</p>

      <h2>Çerezler ve Takip</h2>
      <p>Cep Bakiye çerez kullanmaz. Kullanıcı davranışlarını izleyen herhangi bir analitik hizmeti (Google Analytics, Facebook Pixel vb.) entegre edilmemiştir.</p>

      <h2>İletişim</h2>
      <p>İletişim formu üzerinden gönderilen e-postalar yalnızca size yanıt vermek amacıyla kullanılır ve hiçbir pazarlama listesine eklenmez.</p>
      <p>Sorularınız varsa: <a href="mailto:kaanay918@gmail.com">kaanay918@gmail.com</a></p>

      <p style={{ marginTop: 48, paddingTop: 32, borderTop: '1px solid var(--border)', fontSize: 13, color: 'var(--muted)' }}>
        Kullanım koşullarımızı görüntülemek için <Link href="/kosullar">tıklayın</Link>.
      </p>
    </div>
  );
}
