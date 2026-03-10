import React from 'react';

export default function Sparkline({ data = [], up = true, width = 80, height = 32 }) {
  if (!data.length) return null;
  const min   = Math.min(...data);
  const max   = Math.max(...data);
  const range = max - min || 1;
  const w     = typeof width  === 'number' ? width  : 80;
  const h     = typeof height === 'number' ? height : 32;

  const pts = data.map((v, i) => {
    const x = (i / (data.length - 1)) * w;
    const y = h - ((v - min) / range) * (h - 2) - 1;
    return `${x.toFixed(1)},${y.toFixed(1)}`;
  }).join(' ');

  const color = up ? '#58e8a2' : '#f05070';
  const id    = `sg-${up ? 'up' : 'dn'}-${w}`;

  return (
    <svg
      width={w} height={h}
      style={{ overflow: 'visible', display: 'block' }}
      viewBox={`0 0 ${w} ${h}`}
    >
      <defs>
        <linearGradient id={id} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%"   stopColor={color} stopOpacity="0.3" />
          <stop offset="100%" stopColor={color} stopOpacity="0"   />
        </linearGradient>
      </defs>
      <polygon
        points={`0,${h} ${pts} ${w},${h}`}
        fill={`url(#${id})`}
      />
      <polyline
        points={pts}
        fill="none"
        stroke={color}
        strokeWidth="1.5"
        strokeLinejoin="round"
        strokeLinecap="round"
      />
    </svg>
  );
}
