import './globals.css';
import NavBar from '@/components/NavBar';
import Footer from '@/components/Footer';
import { Analytics } from '@vercel/analytics/react';

export const metadata = {
  title: 'Cep Bakiye — Finansal Hafızanız',
  description:
    'Borçlarınızı, alacaklarınızı ve günlük harcamalarınızı takip etmenin en zarif yolu.',
};

export default function RootLayout({ children }) {
  return (
    <html lang="tr">
      <head>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="true" />
        <link
          href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>
        <NavBar />
        {children}
        <Footer />
        <Analytics />
      </body>
    </html>
  );
}
