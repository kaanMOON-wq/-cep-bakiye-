'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';

const navLinks = [
  { href: '/#about', label: 'Hakkımızda' },
  { href: '/#ozellikler', label: 'Özellikler' },
  { href: '/#indir', label: 'İndir' },
  { href: '/#kurulum', label: 'Kurulum' },
  { href: '/#felsefe', label: 'Felsefe' },
  { href: '/#blog', label: 'Blog' },
  { href: '/#github', label: 'GitHub' },
  { href: '/#iletisim', label: 'İletişim' },
  { href: '/#sss', label: 'SSS' },
];

export default function Header() {
  const [menuOpen, setMenuOpen] = useState(false);
  const pathname = usePathname();

  const toggleMenu = () => setMenuOpen((prev) => !prev);
  const closeMenu = () => setMenuOpen(false);

  if (pathname === '/gizlilik' || pathname === '/kosullar') return null;

  return (
    <>
      <nav className="hero-nav">
        <div className="liquid-glass">
          <div className="hero-nav-left">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" /><path d="M2 12h20" /><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
            </svg>
            <Link href="/" className="hero-nav-logo">
              Cep<span>Bakiye</span>
            </Link>
            <div className="hero-nav-links" id="navLinks">
              {navLinks.map((link) => (
                <a key={link.href} href={link.href}>{link.label}</a>
              ))}
            </div>
            <button className="hamburger" onClick={toggleMenu} aria-label="Menüyü aç/kapat">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <line x1="3" y1="6" x2="21" y2="6" /><line x1="3" y1="12" x2="21" y2="12" /><line x1="3" y1="18" x2="21" y2="18" />
              </svg>
            </button>
          </div>
        </div>
      </nav>

      <div className={`mobile-menu ${menuOpen ? 'open' : ''}`}>
        <button className="mobile-menu-close" onClick={closeMenu} aria-label="Menüyü kapat">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        </button>
        {navLinks.map((link) => (
          <a key={link.href} href={link.href} className="mobile-menu-link" onClick={closeMenu}>{link.label}</a>
        ))}
      </div>
    </>
  );
}
