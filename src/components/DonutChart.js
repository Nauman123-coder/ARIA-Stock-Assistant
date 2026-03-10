import React from 'react';

export default function DonutChart({ segments = [], size = 100 }) {
  const total = segments.reduce((s, x) => s + x.value, 0) || 1;
  const R     = size * 0.38;
  const C     = 2 * Math.PI * R;
  const cx    = size / 2;
  const cy    = size / 2;
  let offset  = 0;

  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
      <circle cx={cx} cy={cy} r={R} fill="none" stroke="#181d2e" strokeWidth={size * 0.13} />
      {segments.map((seg, i) => {
        const pct  = seg.value / total;
        const dash = pct * C;
        const rot  = offset * 360 - 90;
        const el   = (
          <circle
            key={i}
            cx={cx} cy={cy} r={R}
            fill="none"
            stroke={seg.color}
            strokeWidth={size * 0.13}
            strokeDasharray={`${dash} ${C - dash}`}
            strokeDashoffset={-(offset * C) + C / 4}
            style={{ transition: 'stroke-dasharray 0.8s ease', transformOrigin: 'center' }}
            transform={`rotate(${rot} ${cx} ${cy})`}
          />
        );
        offset += pct;
        return el;
      })}
      <text
        x={cx} y={cy + 4}
        textAnchor="middle"
        fill="#a8b5cc"
        fontSize={size * 0.1}
        fontFamily="'JetBrains Mono', monospace"
        fontWeight="400"
      >
        PORT
      </text>
    </svg>
  );
}
