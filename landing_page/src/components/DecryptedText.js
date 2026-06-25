'use client';

import { useState, useEffect, useRef } from 'react';
import { useInView } from 'motion/react';

const CHARS = 'KJSYXZAQWMO0198273645!@#$%&*';

export default function DecryptedText({ 
  text, 
  speed = 40, 
  maxIterations = 20,
  sequential = true,
  className = ''
}) {
  // Hydration mismatch prevention: use index for deterministic initial render
  const [displayText, setDisplayText] = useState(() => 
    text.split('').map((c, i) => c === ' ' ? ' ' : CHARS[i % CHARS.length]).join('')
  );
  
  const ref = useRef(null);
  const isInView = useInView(ref, { once: true, margin: "-10% 0px" });

  useEffect(() => {
    if (!isInView) return;
    
    let iteration = 0;
    const intervalId = setInterval(() => {
      setDisplayText(() => {
        return text
          .split('')
          .map((char, index) => {
            if (char === ' ') return ' ';
            
            // Sequential reveal from left to right
            let threshold = maxIterations;
            if (sequential) {
               // First character reveals at 20% of maxIterations, last at 100%
               threshold = (index / text.length) * (maxIterations * 0.8) + (maxIterations * 0.2);
            }

            if (iteration >= threshold) {
              return char;
            }
            return CHARS[Math.floor(Math.random() * CHARS.length)];
          })
          .join('');
      });

      if (iteration >= maxIterations) {
        clearInterval(intervalId);
      }
      iteration += 1;
    }, speed);

    return () => clearInterval(intervalId);
  }, [isInView, text, speed, maxIterations, sequential]);

  return (
    <span ref={ref} className={className} style={{ whiteSpace: 'pre-wrap' }}>
      {displayText}
    </span>
  );
}
