'use client';
import { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';

const faqs = [
  {
    question: 'Cep Bakiye ücretsiz mi?',
    answer: 'Evet, tamamen ücretsizdir. Hiçbir gizli ücret, abonelik veya reklam yoktur. Tüm özellikler sınırsız kullanıma açıktır.',
  },
  {
    question: 'Verilerim güvende mi?',
    answer: 'Kesinlikle. Tüm verileriniz cihazınızda şifrelenmiş olarak saklanır. Hiçbir veri sunucuya gönderilmez, çerez kullanılmaz, üçüncü taraf erişimi yoktur.',
  },
  {
    question: 'İnternet olmadan çalışır mı?',
    answer: 'Evet, Cep Bakiye tamamen çevrimdışı çalışır. Metroda, uçakta veya internetin olmadığı her yerde hesap ekleyebilir, geçmişinizi görüntüleyebilirsiniz.',
  },
  {
    question: 'iOS sürümü var mı?',
    answer: 'Şimdilik yalnızca Android sürümü mevcut. iOS sürümü için çalışmalar devam ediyor.',
  },
  {
    question: 'Birden fazla cihazda kullanabilir miyim?',
    answer: 'Cep Bakiye yerel depolama kullandığı için veriler cihaza özeldir. Cihazlar arası senkronizasyon özelliği şu anda geliştirme aşamasındadır.',
  },
  {
    question: 'Nasıl katkıda bulunabilirim?',
    answer: 'GitHub deposunu ziyaret ederek star verebilir, issue açabilir veya pull request gönderebilirsiniz. Açık kaynak katkılarına her zaman açığız!',
  },
];

export default function FAQAccordion() {
  const [openIndex, setOpenIndex] = useState(null);

  const toggleFAQ = (index) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <div className="faq-list">
      {faqs.map((faq, index) => {
        const isOpen = openIndex === index;
        return (
          <div 
            key={index} 
            className="faq-item" 
            style={{ 
              background: 'rgba(255,255,255,0.02)', 
              border: '1px solid var(--border)', 
              borderRadius: '16px', 
              marginBottom: '12px',
              overflow: 'hidden'
            }}
          >
            <button
              onClick={() => toggleFAQ(index)}
              style={{
                width: '100%',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                padding: '20px 24px',
                background: 'transparent',
                border: 'none',
                color: 'var(--fg)',
                fontSize: '16px',
                fontWeight: '500',
                cursor: 'pointer',
                textAlign: 'left'
              }}
            >
              <span>{faq.question}</span>
              <motion.svg 
                animate={{ rotate: isOpen ? 180 : 0 }}
                transition={{ duration: 0.3, ease: 'easeInOut' }}
                viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" 
                style={{ width: '20px', height: '20px', color: 'var(--muted)', flexShrink: 0, marginLeft: '12px' }}
              >
                <polyline points="6 9 12 15 18 9" />
              </motion.svg>
            </button>
            
            <AnimatePresence>
              {isOpen && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ duration: 0.3, ease: 'easeInOut' }}
                >
                  <div style={{ padding: '0 24px 24px', color: 'var(--muted)', fontSize: '15px', lineHeight: '1.6' }}>
                    {faq.answer}
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        );
      })}
    </div>
  );
}
