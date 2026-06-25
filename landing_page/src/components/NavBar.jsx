'use client';

import { useEffect, useState } from 'react';
import { usePathname } from 'next/navigation';
import CardNav from './CardNav';

const items = [
  {
    label: 'Keşfet',
    bgColor: '#0d0d0d',
    textColor: '#fff',
    links: [
      { label: 'Hakkımızda', href: '/#about', ariaLabel: 'Hakkımızda' },
      { label: 'Felsefe', href: '/#felsefe', ariaLabel: 'Felsefemiz' },
      { label: 'Blog', href: '/#blog', ariaLabel: 'Blog' },
    ],
  },
  {
    label: 'Özellikler',
    bgColor: '#111',
    textColor: '#fff',
    links: [
      { label: 'Özellikler', href: '/#ozellikler', ariaLabel: 'Özellikler' },
      { label: 'GitHub', href: '/#github', ariaLabel: 'GitHub' },
      { label: 'SSS', href: '/#sss', ariaLabel: 'Sıkça Sorulan Sorular' },
    ],
  },
  {
    label: 'İndir',
    bgColor: '#0d0d0d',
    textColor: '#fff',
    links: [
      { label: 'APK İndir', href: '/#indir', ariaLabel: 'APK İndir' },
      { label: 'Kurulum', href: '/#kurulum', ariaLabel: 'Kurulum' },
      { label: 'İletişim', href: '/#iletisim', ariaLabel: 'İletişim' },
    ],
  },
];

export default function NavBar() {
  const [visible, setVisible] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const hero = document.querySelector('.hero');
    if (!hero) {
      setVisible(true);
      return;
    }

    const observer = new IntersectionObserver(
      ([entry]) => setVisible(entry.isIntersecting),
      { threshold: 0 }
    );

    observer.observe(hero);
    return () => observer.disconnect();
  }, [pathname]);

  if (pathname === '/gizlilik' || pathname === '/kosullar') return null;

  return (
    <CardNav
      items={items}
      className={visible ? 'visible' : 'hidden'}
      baseColor="#000"
      menuColor="#fff"
      buttonBgColor="#fff"
      buttonTextColor="#000"
      ease="power3.out"
    />
  );
}
