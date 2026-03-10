import React, { useState } from 'react';
import { AreaChart, Area, Tooltip, ResponsiveContainer } from 'recharts';

function MiniTooltip({ active, payload }) {
  if (!active || !payload?.length) return null;
  return (
    <div style={{
      background: '#111520',
      border: '1px solid rgba(168,181,204,0.15)',
      borderRadius: 6,
      padding: '5px 9px',
      fontSize: 11,
      fontFamily: "'JetBrains Mono', monospace",
      color: '#e2eaf5',
      pointerEvents: 'none',
    }}>
      ${payload[0].value?.toFixed(2)}
    </div>
  );
}

export default function MiniChart({ data = [], up = true, height = 48 }) {
  const [hovered, setHovered] = useState(false);
  if (!data || data.length < 2) return null;
  const color = up ? '#58e8a2' : '#f05070';
  return (
    <div
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{ width: '100%', height }}
    >
      <ResponsiveContainer width="100%" height={height}>
        <AreaChart data={data} margin={{ top: 2, right: 0, left: 0, bottom: 0 }}>
          <defs>
            <linearGradient id={`mini-${up ? 'up' : 'dn'}`} x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%"   stopColor={color} stopOpacity={hovered ? 0.3 : 0.18} />
              <stop offset="100%" stopColor={color} stopOpacity={0} />
            </linearGradient>
          </defs>
          {hovered && (
            <Tooltip
              content={<MiniTooltip />}
              cursor={{ stroke: 'rgba(168,181,204,0.15)', strokeWidth: 1 }}
            />
          )}
          <Area
            type="monotone"
            dataKey="close"
            stroke={color}
            strokeWidth={1.5}
            fill={`url(#mini-${up ? 'up' : 'dn'})`}
            dot={false}
            activeDot={hovered ? { r: 3, fill: color, stroke: '#060810', strokeWidth: 1.5 } : false}
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
