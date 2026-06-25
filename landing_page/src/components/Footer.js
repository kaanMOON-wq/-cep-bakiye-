import Link from 'next/link';

export default function Footer() {
  return (
    <footer className="footer">
      <div className="footer-inner">
        <div className="footer-copy">&copy; 2026 Cep Bakiye — tüm hakları saklıdır.</div>
        <div className="footer-links">
          <Link href="/gizlilik">Gizlilik Politikası</Link>
          <Link href="/kosullar">Kullanım Koşulları</Link>
        </div>
      </div>
    </footer>
  );
}
