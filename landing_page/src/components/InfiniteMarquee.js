import './InfiniteMarquee.css';

const defaultItems = [
  "✨ SIFIR ÇEREZ",
  "✦",
  "%100 MAHRİYEMET",
  "✦",
  "TAMAMEN ÇEVRİMDIŞI",
  "✦",
  "REKLAMSIZ ✨",
  "✦",
  "VERİ TOPLAMA YOK",
  "✦"
];

const InfiniteMarquee = ({ items = defaultItems }) => {
  return (
    <div className="marquee-wrapper">
      <div className="marquee-track">
        {/* Render 4 copies to ensure seamless loop on ultrawide screens */}
        {[...Array(4)].map((_, i) => (
          <div key={i} className="marquee-content" aria-hidden={i > 0 ? true : undefined}>
            {items.map((item, index) => (
              <span key={index} className={`marquee-item ${item === '✦' ? 'marquee-dot' : ''}`}>
                {item}
              </span>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
};

export default InfiniteMarquee;
