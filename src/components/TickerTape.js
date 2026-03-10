import React from 'react';
import { MARKET_INDICES, MOCK_PRICES } from '../utils/data';

const items = [
  ...MARKET_INDICES.map(i => ({ label: i.name, val: i.value, chg: i.change, up: i.up })),
  ...Object.entries(MOCK_PRICES).slice(0, 8).map(([sym, d]) => ({
    label: sym,
    val: `$${d.price.toFixed(2)}`,
    chg: `${d.change >= 0 ? '+' : ''}${d.change.toFixed(2)}%`,
    up: d.change >= 0,
  })),
];

const doubled = [...items, ...items];

export default function TickerTape() {
  return (
    <div style={{
      background: 'rgba(11,14,24,0.95)',
      borderBottom: '1px solid rgba(168,181,204,0.10)',
      overflow: 'hidden',
      padding: '8px 0',
      position: 'relative',
    }}>
      <div style={{
        display: 'flex',
        gap: 0,
        animation: 'ticker 40s linear infinite',
        width: 'max-content',
      }}>
        {doubled.map((item, i) => (
          <div key={i} style={{
            display: 'flex',
            alignItems: 'center',
            gap: 6,
            padding: '0 28px',
            borderRight: '1px solid rgba(168,181,204,0.08)',
            whiteSpace: 'nowrap',
          }}>
            <span style={{ color: '#7a879e', fontSize: 11, fontFamily: 'var(--font-mono)', letterSpacing: '0.05em' }}>
              {item.label}
            </span>
            <span style={{ color: '#e2eaf5', fontSize: 11, fontFamily: 'var(--font-mono)', fontWeight: 500 }}>
              {item.val}
            </span>
            <span style={{
              color: item.up ? '#58e8a2' : '#f05070',
              fontSize: 10,
              fontFamily: 'var(--font-mono)',
            }}>
              {item.chg}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
