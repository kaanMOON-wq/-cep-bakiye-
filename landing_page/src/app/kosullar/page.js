import Link from 'next/link';

export const metadata = {
  title: 'Cep Bakiye — Kullanım Koşulları',
};

export default function TermsPage() {
  return (
    <div className="page-container">
      <Link href="/" className="back-link">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
          <path d="M19 12H5m7-7-7 7 7 7" />
        </svg>
        Ana Sayfa&apos;ya Dön
      </Link>

      <h1>Kullanım Koşulları</h1>
      <div className="last-updated">Son güncelleme: 23 Haziran 2026</div>

      <p>Cep Bakiye&apos;yi kullanarak aşağıdaki koşulları kabul etmiş olursunuz.</p>

      <h2>Hizmet Tanımı</h2>
      <p>Cep Bakiye, kişisel borç ve alacak takibi yapmanızı sağlayan bir finansal hafıza aracıdır. Uygulama bir bankacılık hizmeti değildir ve finansal tavsiye vermez.</p>

      <h2>Sorumluluk Reddi</h2>
      <p>Cep Bakiye, kaydedilen verilerin doğruluğu konusunda garanti vermez. Kullanıcı, kendi girdiği verilerin doğruluğundan sorumludur. Uygulama, veri kaybı durumunda sorumluluk kabul etmez. Düzenli yedekleme yapmanız önerilir.</p>

      <h2>Fikri Mülkiyet</h2>
      <p>Cep Bakiye uygulamasının tüm hakları saklıdır. Uygulamanın tersine mühendislik yapılması, kopyalanması veya izinsiz dağıtılması yasaktır.</p>

      <h2>Değişiklikler</h2>
      <p>Bu koşullar önceden bildirimde bulunmaksızın güncellenebilir. Güncellemeler bu sayfada yayınlandığı anda yürürlüğe girer.</p>

      <h2>İletişim</h2>
      <p>Sorularınız için: <a href="mailto:kaanay918@gmail.com">kaanay918@gmail.com</a></p>

      <p style={{ marginTop: 48, paddingTop: 32, borderTop: '1px solid var(--border)', fontSize: 13, color: 'var(--muted)' }}>
        Gizlilik politikamızı görüntülemek için <Link href="/gizlilik">tıklayın</Link>.
      </p>
    </div>
  );
}
