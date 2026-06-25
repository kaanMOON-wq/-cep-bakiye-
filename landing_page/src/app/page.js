'use client';

import { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import RotatingText from '../../components/reactbits/RotatingText';
import FAQAccordion from '@/components/FAQAccordion';
import StarBorder from '@/components/StarBorder';
import ShinyText from '@/components/ShinyText';
import InfiniteMarquee from '@/components/InfiniteMarquee';
import DecryptedText from '@/components/DecryptedText';


export default function Home() {
  const container = useRef(null);

  useEffect(() => {
    gsap.registerPlugin(ScrollTrigger);

    let ctx = gsap.context(() => {
      // 1. Reveal Animations (Replacing CSS IntersectionObserver)
      const sections = gsap.utils.toArray('section');
      sections.forEach((section) => {
        const reveals = section.querySelectorAll('.reveal');
        // Prevent CSS transition conflicts
        gsap.set(reveals, { transition: 'none', opacity: 0, y: 50 });
        
        ScrollTrigger.create({
          trigger: section,
          start: 'top 85%',
          onEnter: () => {
            gsap.to(reveals, {
              y: 0,
              opacity: 1,
              duration: 1,
              stagger: 0.1,
              ease: 'power3.out',
              overwrite: 'auto'
            });
          }
        });
      });

    }, container);

    return () => ctx.revert();
  }, []);

  return (
    <main ref={container}>
      {/* HERO */}
      <section className="hero">
          <div className="hero-antigravity">
            <div className="hero-antigravity-text">
              <div className="reveal in" style={{ marginBottom: 0 }}>
                <ShinyText text="Cep Bakiye" speed={3} className="section-label" style={{ marginBottom: 0, padding: 0 }} />
              </div>
              <h1 className="hero-headline reveal in">
                <DecryptedText text="Finansal" speed={40} maxIterations={20} /><br />
                <em>
                  <RotatingText
                    texts={['Hafızanız', 'Beyniniz', 'Aklınız']}
                    mainClassName="rotating-hero-text"
                    rotationInterval={2500}
                    staggerDuration={0.025}
                    staggerFrom="last"
                    transition={{ type: 'spring', damping: 25, stiffness: 300 }}
                  />
                </em>
              </h1>
              <p className="hero-subtitle reveal in">
                Borçlarınızı, alacaklarınızı ve günlük harcamalarınızı takip etmenin en zarif yolu. Excel ve WhatsApp mesajlarına veda edin.
              </p>

              <div className="hero-cta-row">
                <div className="reveal in reveal-delay-1">
                  <StarBorder as="a" href="#indir" color="white" speed="5s" thickness={2}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" /><polyline points="7 10 12 15 17 10" /><line x1="12" y1="15" x2="12" y2="3" />
                    </svg>
                    APK&apos;yı İndir
                  </StarBorder>
                </div>
                <div className="reveal in reveal-delay-2">
                  <StarBorder as="a" href="#ozellikler" color="white" speed="4s" thickness={2}>
                    Özellikleri Keşfet
                  </StarBorder>
                </div>
              </div>
            </div>
          </div>

        <div className="scroll-indicator">
          <span>Scroll</span>
          <div className="scroll-indicator-line" />
        </div>
      </section>

      {/* INFINITE MARQUEE */}
      <InfiniteMarquee />

      {/* ABOUT */}
      <section id="about" className="about">
        <div className="container">
          <div className="about-grid">
            <div className="about-text">
              <span className="section-label reveal">Biz Kimiz</span>
              <h2 className="section-title reveal reveal-delay-1">
                Borçları çözen<br /><em>minimalist</em> yaklaşım
              </h2>
              <p className="section-body reveal reveal-delay-2">
                Excel tabloları ve WhatsApp mesajları arasında kaybolan alacaklarınıza elveda.
                Cep Bakiye, borç ve alacak takibini saniyeler içinde halleder,
                her şeyi cebinizde, güvenle ve şık bir arayüzle sunar.
              </p>
            </div>
            <div className="about-stats">
              <div className="about-stat reveal reveal-delay-2">
                <div className="about-stat-number accent-purple">₺0</div>
                <div className="about-stat-label">Kurulum ücreti — tamamen ücretsiz</div>
              </div>
              <div className="about-stat reveal reveal-delay-3">
                <div className="about-stat-number accent-green">%100</div>
                <div className="about-stat-label">Yerel veri — çerez yok, takip yok</div>
              </div>
              <div className="about-stat reveal reveal-delay-3">
                <div className="about-stat-number accent-pink">3sn</div>
                <div className="about-stat-label">Bir borç kaydı için ortalama süre</div>
              </div>
              <div className="about-stat reveal reveal-delay-4">
                <div className="about-stat-number accent-purple">7/24</div>
                <div className="about-stat-label">Çevrimdışı çalışır, her zaman yanınızda</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* PHILOSOPHY */}
      <section id="felsefe" className="philosophy">
        <div className="container">
          <div style={{ textAlign: 'center' }}>
            <span className="section-label reveal">Felsefe</span>
            <h2 className="section-title reveal reveal-delay-1">
              Felsef<span style={{ color: 'rgba(255,255,255,0.35)' }}>e</span>miz
            </h2>
          </div>

          <div className="philosophy-grid">
            <div className="philosophy-card reveal reveal-delay-2">
              <div className="block-label">Mahremiyet önce gelir</div>
              <p>Verileriniz yalnızca sizin cihazınızda kalır. Sıfır çerez, sıfır takip, sıfır üçüncü taraf. Banka hesabınıza bağlanmayız çünkü zorunda değiliz — sadece borç ve alacaklarınızı biliriz.</p>
            </div>

            <div className="philosophy-card reveal reveal-delay-3">
              <div className="block-label">Çevrimdışı özgürlük</div>
              <p>İnternet yoksa sorun değil. Cep Bakiye tamamen çevrimdışı çalışır, verileriniz cihazınızda şifrelenir. İstediğiniz zaman, istediğiniz yerde kullanın.</p>
            </div>

            <div className="philosophy-card reveal reveal-delay-4">
              <div className="block-label">Tasarım bir ayrıcalıktır</div>
              <p>Sadece işlevsel değil, kullanması keyifli. Her animasyon, her geçiş, her dokunuş — hepsi sizin deneyiminiz için özenle düşünüldü.</p>
            </div>

            <div className="philosophy-tags reveal reveal-delay-4">
              <span className="philosophy-tag">Çevrimdışı</span>
              <span className="philosophy-tag">Şifreli</span>
              <span className="philosophy-tag">Çerezsiz</span>
              <span className="philosophy-tag">Reklamsız</span>
              <span className="philosophy-tag">CRDT Senkron</span>
            </div>
          </div>
        </div>
      </section>

      {/* FEATURES */}
      <section id="ozellikler" className="features">
        <div className="container">
          <div style={{ marginBottom: 40, textAlign: 'center' }}>
            <span className="section-label reveal">Cep Bakiye</span>
            <h2 className="section-title reveal reveal-delay-1">Neden <em>Biz</em>?</h2>
            <p className="features-subtitle reveal reveal-delay-2" style={{ margin: '16px auto 0', textAlign: 'center' }}>Finansal takibi yeniden tanımlayan özelliklerle tanışın. Her detay sizin için düşünüldü.</p>
          </div>

          <div className="features-grid">
            <div className="feature-card reveal reveal-delay-2">
              <div className="feature-icon" style={{ color: 'var(--accent)' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M13 2 3 14h9l-1 8 10-12h-9l1-8z" />
                </svg>
              </div>
              <h3 className="feature-title">Şimşek Hızında Kayıt</h3>
              <p className="feature-desc">Menüler arasında kaybolmayın. Arkadaşınıza borç verdiğiniz veya hesap ödediğiniz an, saniyeler içinde tutarı girip işlemi kaydedin. Karmaşık formlara veda edin.</p>
            </div>

            <div className="feature-card reveal reveal-delay-3">
              <div className="feature-icon" style={{ color: 'var(--accent-green)' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                </svg>
              </div>
              <h3 className="feature-title">%100 Yerel ve Gizlilik Odaklı</h3>
              <p className="feature-desc">Verileriniz asla bir sunucuya gönderilmez. Sıfır çerez, sıfır takip. Tüm finansal kayıtlarınız sadece kendi cihazınızda şifrelenmiş olarak kalır. Banka bağlantısı yok, risk yok.</p>
            </div>

            <div className="feature-card reveal reveal-delay-4">
              <div className="feature-icon" style={{ color: 'var(--accent-pink)' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
                </svg>
              </div>
              <h3 className="feature-title">Kusursuz Koyu Tema</h3>
              <p className="feature-desc">Göz yoran karmaşık Excel E-Tablolarını unutun. Sıvı cam (liquid glass) efektleri ve derin siyah renk paletiyle finans takibi hiç bu kadar elit ve şık olmamıştı.</p>
            </div>

            <div className="feature-card reveal reveal-delay-2">
              <div className="feature-icon" style={{ color: 'var(--accent)' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4" /><path d="M3 5v14a2 2 0 0 0 2 2h16v-5" /><path d="M18 12a2 2 0 0 0 0 4h4v-4Z" />
                </svg>
              </div>
              <h3 className="feature-title">Akıllı Bakiye Özeti</h3>
              <p className="feature-desc">&quot;Acaba toplam ne kadar alacağım var?&quot; derdine son. Tüm borç ve alacaklarınızı otomatik hesaplayıp size tek bir net, parlayan bakiye özeti sunar.</p>
            </div>

            <div className="feature-card reveal reveal-delay-3">
              <div className="feature-icon" style={{ color: 'var(--accent-green)' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" /><polyline points="14 2 14 8 20 8" /><line x1="16" y1="13" x2="8" y2="13" /><line x1="16" y1="17" x2="8" y2="17" /><polyline points="10 9 9 9 8 9" />
                </svg>
              </div>
              <h3 className="feature-title">PDF Olarak Dışa Aktarma</h3>
              <p className="feature-desc">Tüm borç ve alacak kayıtlarınızı tek tıkla PDF olarak dışa aktarın. Arkadaşlarınızla paylaşın, arşivleyin veya yazdırın. Excel uğraşmaya son.</p>
            </div>

            <div className="feature-card reveal reveal-delay-4">
              <div className="feature-icon" style={{ color: 'var(--accent-pink)' }}>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M5 12.55a11 11 0 0 1 14.08 0" /><path d="M1.42 9a16 16 0 0 1 21.16 0" /><path d="M8.53 16.11a6 6 0 0 1 6.95 0" /><circle cx="12" cy="20" r="1" />
                </svg>
              </div>
              <h3 className="feature-title">İnternetsiz Çalışma</h3>
              <p className="feature-desc">Metroda, uçakta veya internetin çekmediği yerlerde bile hesap eklemeye devam edin. Cep Bakiye çalışmak için internet bağlantısına ihtiyaç duymaz.</p>
            </div>
          </div>
        </div>
      </section>

      {/* BLOG */}
      <section id="blog" className="blog">

        <div className="container">
          <div className="blog-header">
            <div>
              <span className="section-label reveal">Blog</span>
              <h2 className="section-title reveal reveal-delay-1">Finansal <em>İpuçları</em></h2>
            </div>
          </div>

          <div className="blog-grid">
            <article className="blog-card reveal reveal-delay-2">
              <div className="blog-card-thumb">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: 'var(--muted)', opacity: 0.4 }}>
                  <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
                </svg>
                <div className="img-overlay" />
              </div>
              <div className="blog-card-body">
                <div className="blog-card-meta">
                  <span className="tag">Bütçe</span>
                  <span>12 Haz 2026</span>
                </div>
                <h3 className="blog-card-title">Arkadaşlarınızla borç takibinin altın kuralları</h3>
                <p className="blog-card-excerpt">Parayı konuşmak zor olmak zorunda değil. Arkadaş grubunuzda borçları şeffaf ve rahat bir şekilde yönetmenin 5 yolunu keşfedin.</p>
              </div>
            </article>

            <article className="blog-card reveal reveal-delay-3">
              <div className="blog-card-thumb">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: 'var(--muted)', opacity: 0.4 }}>
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2" /><path d="M7 11V7a5 5 0 0 1 10 0v4" />
                </svg>
                <div className="img-overlay" />
              </div>
              <div className="blog-card-body">
                <div className="blog-card-meta">
                  <span className="tag">Güvenlik</span>
                  <span>5 Haz 2026</span>
                </div>
                <h3 className="blog-card-title">Verileriniz neden cihazınızda kalmalı?</h3>
                <p className="blog-card-excerpt">Bulutta saklanan her veri bir risktir. Yerel depolamanın avantajları ve dijital mahremiyetinizin neden önemli olduğu hakkında.</p>
              </div>
            </article>

            <article className="blog-card reveal reveal-delay-4">
              <div className="blog-card-thumb">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ color: 'var(--muted)', opacity: 0.4 }}>
                  <line x1="12" y1="1" x2="12" y2="23" /><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
                </svg>
                <div className="img-overlay" />
              </div>
              <div className="blog-card-body">
                <div className="blog-card-meta">
                  <span className="tag">İpucu</span>
                  <span>28 May 2026</span>
                </div>
                <h3 className="blog-card-title">Bütçe yapmadan borçsuz kalmanın yolları</h3>
                <p className="blog-card-excerpt">Karmaşık Excel tabloları olmadan harcamalarınızı kontrol altında tutmanın minimalist bir yöntemi. Sadece 3 alışkanlık yeterli.</p>
              </div>
            </article>
          </div>
        </div>
      </section>

      {/* DOWNLOAD */}
      <section id="indir" style={{ padding: '100px 24px 60px', textAlign: 'center', position: 'relative', zIndex: 1 }}>

        <div className="container">
          <span className="section-label reveal">İndir</span>
          <h2 className="section-title reveal reveal-delay-1" style={{ marginBottom: 16 }}>Uygulamayı <em>Şimdi İndir</em></h2>
          <p className="reveal reveal-delay-2" style={{ fontSize: 16, lineHeight: 1.6, color: 'var(--muted)', maxWidth: '65ch', margin: '0 auto 40px' }}>
            APK dosyasını indirerek Cep Bakiye&apos;yi hemen kullanmaya başlayın. Android cihazınızda yan taraftan yükleyin.
          </p>
          <div className="reveal reveal-delay-3">
            <StarBorder as="a" href="/cepbakiye.apk" download color="white" speed="5s" thickness={2}>
              <svg className="download-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" /><polyline points="7 10 12 15 17 10" /><line x1="12" y1="15" x2="12" y2="3" />
              </svg>
              APK&apos;yı İndir
            </StarBorder>
          </div>
          <p className="reveal reveal-delay-4" style={{ fontSize: 11, color: 'var(--muted)', marginTop: 24, opacity: 0.6 }}>
            Sürüm 1.0 · 58 MB · Android 7.0+
          </p>
        </div>
      </section>

      {/* HOW TO INSTALL */}
      <section id="kurulum" className="install">

        <div className="container">
          <span className="section-label reveal">Kurulum</span>
          <h2 className="section-title reveal reveal-delay-1" style={{ marginBottom: 40, textAlign: 'center' }}>Nasıl <em>Yüklenir</em></h2>

          <div className="install-steps">
            <div className="install-step reveal reveal-delay-2">
              <div className="install-step-num">1</div>
              <div className="install-step-content">
                <div className="install-step-title">APK&apos;yı indirin</div>
                <div className="install-step-desc">Yukarıdaki &quot;APK&apos;yı İndir&quot; butonuna tıklayarak <strong>cepbakiye.apk</strong> dosyasını cihazınıza kaydedin.</div>
              </div>
            </div>

            <div className="install-step reveal reveal-delay-3">
              <div className="install-step-num">2</div>
              <div className="install-step-content">
                <div className="install-step-title">Bilinmeyen kaynaklara izin verin</div>
                <div className="install-step-desc">Ayarlar → Güvenlik → &quot;Bilinmeyen Kaynaklar&quot; seçeneğini etkinleştirin. (Sürüme göre yol değişebilir.)</div>
              </div>
            </div>

            <div className="install-step reveal reveal-delay-4">
              <div className="install-step-num">3</div>
              <div className="install-step-content">
                <div className="install-step-title">APK&apos;yı açın ve kurun</div>
                <div className="install-step-desc">İndirilenler klasöründen <strong>cepbakiye.apk</strong>&apos;ya dokunun, ardından &quot;Kur&quot; butonuna basın. Kurulum birkaç saniye sürer.</div>
              </div>
            </div>

            <div className="install-step reveal reveal-delay-5">
              <div className="install-step-num">4</div>
              <div className="install-step-content">
                <div className="install-step-title">Açın ve kullanmaya başlayın</div>
                <div className="install-step-desc">Kurulum tamamlandığında &quot;Aç&quot; butonuna tıklayarak Cep Bakiye&apos;yi hemen kullanmaya başlayabilirsiniz.</div>
              </div>
            </div>
          </div>


        </div>
      </section>

      {/* GITHUB STAR */}
      <section id="github" className="github">

        <div className="container">
          <span className="section-label reveal">GitHub</span>
          <h2 className="section-title reveal reveal-delay-1" style={{ marginBottom: 40 }}>Projeyi <em>Yıldızla</em></h2>
          <a href="https://github.com/kaanMOON-wq/-cep-bakiye-" target="_blank" rel="noopener noreferrer" className="github-card reveal reveal-delay-2" style={{ textDecoration: 'none' }}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" style={{ color: 'var(--accent)' }}>
                <path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4" />
                <path d="M9 18c-4.51 2-5-2-7-2" />
              </svg>
              <div className="github-card-text">
                <div className="github-card-label">Açık kaynak — katkıda bulunun</div>
                <div className="github-card-repo">github.com/kaanMOON-wq/-cep-bakiye-</div>
              </div>
          </a>
          <div className="reveal reveal-delay-3" style={{ marginTop: 28 }}>
            <StarBorder as="a" href="https://github.com/kaanMOON-wq/-cep-bakiye-" target="_blank" rel="noopener noreferrer" color="white" speed="3s" thickness={2}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
              </svg>
              Yıldızla
            </StarBorder>
          </div>
        </div>
      </section>

      {/* FAQ / SSS */}
      <section id="sss" className="faq">

        <div className="container">
          <span className="section-label reveal">SSS</span>
          <h2 className="section-title reveal reveal-delay-1" style={{ textAlign: 'center' }}>Sıkça Sorulan <em>Sorular</em></h2>

          <FAQAccordion />
          {/* <div className="faq-list">
            <details className="faq-item reveal reveal-delay-2">
              <summary>
                <span>Cep Bakiye ücretsiz mi?</span>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </summary>
              <div className="faq-a-inner">Evet, tamamen ücretsizdir. Hiçbir gizli ücret, abonelik veya reklam yoktur. Tüm özellikler sınırsız kullanıma açıktır.</div>
            </details>

            <details className="faq-item reveal reveal-delay-3">
              <summary>
                <span>Verilerim güvende mi?</span>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </summary>
              <div className="faq-a-inner">Kesinlikle. Tüm verileriniz cihazınızda şifrelenmiş olarak saklanır. Hiçbir veri sunucuya gönderilmez, çerez kullanılmaz, üçüncü taraf erişimi yoktur.</div>
            </details>

            <details className="faq-item reveal reveal-delay-4">
              <summary>
                <span>İnternet olmadan çalışır mı?</span>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </summary>
              <div className="faq-a-inner">Evet, Cep Bakiye tamamen çevrimdışı çalışır. Metroda, uçakta veya internetin olmadığı her yerde hesap ekleyebilir, geçmişinizi görüntüleyebilirsiniz.</div>
            </details>

            <details className="faq-item reveal reveal-delay-5">
              <summary>
                <span>iOS sürümü var mı?</span>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </summary>
              <div className="faq-a-inner">Şimdilik yalnızca Android sürümü mevcut. iOS sürümü için çalışmalar devam ediyor.</div>
            </details>

            <details className="faq-item reveal reveal-delay-5">
              <summary>
                <span>Birden fazla cihazda kullanabilir miyim?</span>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </summary>
              <div className="faq-a-inner">Cep Bakiye yerel depolama kullandığı için veriler cihaza özeldir. Cihazlar arası senkronizasyon özelliği şu anda geliştirme aşamasındadır.</div>
            </details>

            <details className="faq-item reveal reveal-delay-5">
              <summary>
                <span>Nasıl katkıda bulunabilirim?</span>
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </summary>
              <div className="faq-a-inner">GitHub deposunu ziyaret ederek star verebilir, issue açabilir veya pull request gönderebilirsiniz. Açık kaynak katkılarına her zaman açığız!</div>
            </details>
          </div> */}
        </div>
      </section>

      {/* CONTACT */}
      <section id="iletisim" style={{ padding: '100px 24px 80px', position: 'relative', zIndex: 1 }}>

        <div className="container" style={{ maxWidth: 600, margin: '0 auto', textAlign: 'center' }}>
          <span className="section-label reveal">İletişim</span>
          <h2 className="section-title reveal reveal-delay-1" style={{ marginBottom: 16 }}>Bize <em>Ulaşın</em></h2>
          <p className="reveal reveal-delay-2" style={{ fontSize: 16, lineHeight: 1.7, color: 'var(--muted)', marginBottom: 36 }}>
            Sorularınız, önerileriniz veya geri bildirimleriniz için bize yazın.
          </p>

          <div className="reveal reveal-delay-3" style={{ maxWidth: 480, margin: '0 auto' }}>
            <StarBorder as="a" href="mailto:kaanay918@gmail.com" color="white" speed="4s" thickness={2} style={{ width: '100%', boxSizing: 'border-box' }}>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" /><polyline points="22,6 12,13 2,6" />
              </svg>
              Bize E-Posta Gönder
            </StarBorder>
          </div>
        </div>
      </section>
    </main>
  );
}
