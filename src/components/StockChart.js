import React, { useState, useEffect, useCallback, useMemo } from 'react';
import {
  ComposedChart, Area, Line, Bar,
  XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, ReferenceLine, Legend,
} from 'recharts';

// ── Period config ──────────────────────────────────────────────────────────
const PERIODS = [
  { label: '1W', value: '1W' },
  { label: '1M', value: '1M' },
  { label: '3M', value: '3M' },
  { label: '6M', value: '6M' },
  { label: '1Y', value: '1Y' },
  { label: '2Y', value: '2Y' },
];

// ── Generate forecast points using linear regression + noise ───────────────
function generateForecast(history, days = 30) {
  if (!history.length) return [];
  const n      = history.length;
  const prices = history.map(d => d.close);

  // Simple linear regression on the last 60 points
  const window = prices.slice(-60);
  const len    = window.length;
  const xs     = window.map((_, i) => i);
  const xMean  = xs.reduce((a, b) => a + b, 0) / len;
  const yMean  = window.reduce((a, b) => a + b, 0) / len;
  const slope  = xs.reduce((s, x, i) => s + (x - xMean) * (window[i] - yMean), 0)
                / xs.reduce((s, x) => s + (x - xMean) ** 2, 0);

  // Volatility from recent price
  const recentReturns = prices.slice(-20).map((p, i, a) =>
    i > 0 ? (p - a[i - 1]) / a[i - 1] : 0
  ).filter(Boolean);
  const vol = Math.sqrt(
    recentReturns.reduce((s, r) => s + r * r, 0) / recentReturns.length
  );

  const lastPrice = prices[prices.length - 1];
  const lastDate  = new Date(history[history.length - 1].ts);

  const forecast = [];
  let seed = lastPrice;

  for (let i = 1; i <= days; i++) {
    const trend     = slope * i;
    const noise     = (Math.sin(i * 2.3) * 0.5 + Math.cos(i * 1.7) * 0.3) * vol * lastPrice * 2;
    const projected = lastPrice + trend + noise;

    const date = new Date(lastDate);
    date.setDate(date.getDate() + i);

    const confidence = Math.max(0.3, 1 - i / days);
    forecast.push({
      date:    date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
      ts:      date.getTime(),
      forecast: +projected.toFixed(2),
      upper:   +(projected * (1 + vol * 2 * (1 - confidence * 0.5))).toFixed(2),
      lower:   +(projected * (1 - vol * 2 * (1 - confidence * 0.5))).toFixed(2),
    });
  }
  return forecast;
}

// ── Custom tooltip ─────────────────────────────────────────────────────────
function ChartTooltip({ active, payload, label }) {
  if (!active || !payload?.length) return null;

  const isForecast = payload.some(p => p.dataKey === 'forecast');
  const data       = payload[0]?.payload || {};

  return (
    <div style={{
      background: 'linear-gradient(145deg, #131825, #0c0f1a)',
      border:     '1px solid rgba(126,184,247,0.2)',
      borderRadius: 10,
      padding:    '10px 14px',
      fontSize:   12,
      fontFamily: 'JetBrains Mono, monospace',
      boxShadow:  '0 8px 32px rgba(0,0,0,0.6)',
      minWidth:   160,
      pointerEvents: 'none',
    }}>
      <div style={{ color: '#7a879e', marginBottom: 6, fontSize: 11 }}>{label}</div>

      {isForecast ? (
        <>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16, marginBottom: 3 }}>
            <span style={{ color: '#f0c060' }}>Forecast</span>
            <span style={{ color: '#e2eaf5', fontWeight: 700 }}>${data.forecast?.toFixed(2)}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16, marginBottom: 3 }}>
            <span style={{ color: '#58e8a2' }}>Upper</span>
            <span style={{ color: '#58e8a2' }}>${data.upper?.toFixed(2)}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16 }}>
            <span style={{ color: '#f05070' }}>Lower</span>
            <span style={{ color: '#f05070' }}>${data.lower?.toFixed(2)}</span>
          </div>
          <div style={{ marginTop: 6, paddingTop: 6, borderTop: '1px solid rgba(168,181,204,0.1)', fontSize: 10, color: '#4a5268' }}>
            AI projection · not financial advice
          </div>
        </>
      ) : (
        <>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16, marginBottom: 4 }}>
            <span style={{ color: '#7a879e' }}>Close</span>
            <span style={{ color: '#e2eaf5', fontWeight: 700, fontSize: 14 }}>${data.close?.toFixed(2)}</span>
          </div>
          {data.open != null && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16 }}>
                <span style={{ color: '#7a879e' }}>Open</span>
                <span style={{ color: '#c8d4e8' }}>${data.open?.toFixed(2)}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16 }}>
                <span style={{ color: '#58e8a2' }}>High</span>
                <span style={{ color: '#58e8a2' }}>${data.high?.toFixed(2)}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 16 }}>
                <span style={{ color: '#f05070' }}>Low</span>
                <span style={{ color: '#f05070' }}>${data.low?.toFixed(2)}</span>
              </div>
            </div>
          )}
          {data.volume != null && (
            <div style={{ marginTop: 5, paddingTop: 5, borderTop: '1px solid rgba(168,181,204,0.08)', color: '#4a5268', fontSize: 10 }}>
              Vol: {data.volume >= 1e6 ? `${(data.volume / 1e6).toFixed(1)}M` : data.volume?.toLocaleString()}
            </div>
          )}
        </>
      )}
    </div>
  );
}

// ── Stats bar ──────────────────────────────────────────────────────────────
function StatsBar({ data, quote }) {
  if (!data.length) return null;
  const closes   = data.map(d => d.close);
  const high52   = Math.max(...closes);
  const low52    = Math.min(...closes);
  const first    = closes[0];
  const last     = closes[closes.length - 1];
  const periodPct = ((last - first) / first * 100).toFixed(2);
  const isUp      = last >= first;

  return (
    <div style={{
      display: 'flex',
      gap: 0,
      flexWrap: 'wrap',
      borderBottom: '1px solid rgba(168,181,204,0.07)',
      marginBottom: 12,
    }}>
      {[
        { label: 'Period %',   val: `${isUp ? '+' : ''}${periodPct}%`, color: isUp ? '#58e8a2' : '#f05070' },
        { label: 'Period High', val: `$${high52.toFixed(2)}`, color: '#58e8a2' },
        { label: 'Period Low',  val: `$${low52.toFixed(2)}`,  color: '#f05070' },
        { label: 'Avg Price',   val: `$${(closes.reduce((a, b) => a + b, 0) / closes.length).toFixed(2)}`, color: '#c8d4e8' },
        ...(quote ? [
          { label: 'Day High', val: `$${quote.high?.toFixed(2)}`,  color: '#58e8a2' },
          { label: 'Day Low',  val: `$${quote.low?.toFixed(2)}`,   color: '#f05070' },
        ] : []),
      ].map((s, i) => (
        <div key={i} style={{
          padding: '6px 14px',
          borderRight: '1px solid rgba(168,181,204,0.07)',
          flex: '1 1 auto',
          textAlign: 'center',
          minWidth: 80,
        }}>
          <div style={{ fontSize: 9, color: '#4a5268', textTransform: 'uppercase', letterSpacing: '0.1em', fontFamily: 'JetBrains Mono, monospace', marginBottom: 2 }}>
            {s.label}
          </div>
          <div style={{ fontSize: 12, fontWeight: 700, color: s.color, fontFamily: 'JetBrains Mono, monospace' }}>
            {s.val}
          </div>
        </div>
      ))}
    </div>
  );
}

// ── Main component ─────────────────────────────────────────────────────────
export default function StockChart({ symbol, loadHistory, quote, height = 300 }) {
  const [period,      setPeriod]      = useState('3M');
  const [histData,    setHistData]    = useState([]);
  const [loading,     setLoading]     = useState(true);
  const [error,       setError]       = useState(null);
  const [showForecast, setShowForecast] = useState(false);
  const [showVolume,   setShowVolume]   = useState(false);

  // Fetch historical data when symbol or period changes
  useEffect(() => {
    if (!symbol || !loadHistory) return;
    let cancelled = false;
    setLoading(true);
    setError(null);
    setHistData([]);

    loadHistory(symbol, period)
      .then(data => {
        if (cancelled) return;
        if (!data || data.length === 0) {
          setError('No data returned. Check your Finnhub API key.');
        } else {
          setHistData(data);
        }
        setLoading(false);
      })
      .catch(e => {
        if (!cancelled) {
          setError(e.message || 'Failed to load chart data');
          setLoading(false);
        }
      });

    return () => { cancelled = true; };
  }, [symbol, period, loadHistory]);

  // Build forecast data
  const forecastData = useMemo(() => {
    if (!showForecast || !histData.length) return [];
    return generateForecast(histData, 30);
  }, [showForecast, histData]);

  // Combine historical + forecast for the chart
  const chartData = useMemo(() => {
    const hist = histData.map(d => ({ ...d, forecast: null, upper: null, lower: null }));
    // Add one bridge point at the junction
    if (forecastData.length > 0 && hist.length > 0) {
      const last = hist[hist.length - 1];
      hist[hist.length - 1] = {
        ...last,
        forecast: last.close,
        upper:    last.close,
        lower:    last.close,
      };
    }
    return [...hist, ...forecastData.map(d => ({
      ...d, close: null, open: null, high: null, low: null, volume: null,
    }))];
  }, [histData, forecastData]);

  const firstClose = histData[0]?.close;
  const lastClose  = histData[histData.length - 1]?.close;
  const isUp       = (lastClose ?? 0) >= (firstClose ?? 0);
  const lineColor  = isUp ? '#58e8a2' : '#f05070';

  const tickInterval = useMemo(() => {
    const n = chartData.length;
    if (n > 200) return Math.floor(n / 8);
    if (n > 60)  return Math.floor(n / 6);
    if (n > 20)  return Math.floor(n / 5);
    return 1;
  }, [chartData]);

  const [yMin, yMax] = useMemo(() => {
    const allPrices = [
      ...histData.map(d => d.close),
      ...(showForecast ? forecastData.flatMap(d => [d.lower, d.upper]) : []),
    ].filter(Boolean);
    if (!allPrices.length) return [0, 100];
    const min = Math.min(...allPrices);
    const max = Math.max(...allPrices);
    const pad = (max - min) * 0.06;
    return [min - pad, max + pad];
  }, [histData, forecastData, showForecast]);

  const forecastStart = histData.length > 0
    ? histData[histData.length - 1].date
    : null;

  return (
    <div style={{ width: '100%' }}>
      {/* ── Controls bar ── */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 10, flexWrap: 'wrap', gap: 8 }}>
        {/* Period buttons */}
        <div style={{ display: 'flex', gap: 3 }}>
          {PERIODS.map(p => (
            <button
              key={p.value}
              onClick={() => setPeriod(p.value)}
              style={{
                background:   period === p.value ? lineColor : 'transparent',
                color:        period === p.value ? '#060810' : '#7a879e',
                border:       `1px solid ${period === p.value ? lineColor : 'rgba(168,181,204,0.12)'}`,
                borderRadius: 5,
                padding:      '3px 9px',
                fontSize:     11,
                fontFamily:   'JetBrains Mono, monospace',
                cursor:       'pointer',
                fontWeight:   period === p.value ? 700 : 400,
                transition:   'all 0.15s',
              }}
            >
              {p.label}
            </button>
          ))}
        </div>

        {/* Toggle buttons */}
        <div style={{ display: 'flex', gap: 6 }}>
          <button
            onClick={() => setShowVolume(v => !v)}
            style={{
              fontSize: 11,
              fontFamily: 'JetBrains Mono, monospace',
              padding: '3px 10px',
              borderRadius: 5,
              border: `1px solid ${showVolume ? 'rgba(126,184,247,0.4)' : 'rgba(168,181,204,0.12)'}`,
              background: showVolume ? 'rgba(126,184,247,0.1)' : 'transparent',
              color: showVolume ? '#7eb8f7' : '#7a879e',
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >
            Vol
          </button>
          <button
            onClick={() => setShowForecast(f => !f)}
            style={{
              fontSize: 11,
              fontFamily: 'JetBrains Mono, monospace',
              padding: '3px 10px',
              borderRadius: 5,
              border: `1px solid ${showForecast ? 'rgba(240,192,96,0.4)' : 'rgba(168,181,204,0.12)'}`,
              background: showForecast ? 'rgba(240,192,96,0.08)' : 'transparent',
              color: showForecast ? '#f0c060' : '#7a879e',
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >
            ✦ Forecast
          </button>
        </div>
      </div>

      {/* ── Stats bar ── */}
      {histData.length > 0 && <StatsBar data={histData} quote={quote} />}

      {/* ── Chart ── */}
      {loading ? (
        <div style={{
          height, display: 'flex', alignItems: 'center', justifyContent: 'center',
          flexDirection: 'column', gap: 12,
          color: '#4a5268', fontSize: 13, fontFamily: 'JetBrains Mono, monospace',
        }}>
          <div style={{
            width: 32, height: 32, border: '2px solid rgba(126,184,247,0.3)',
            borderTop: '2px solid #7eb8f7', borderRadius: '50%',
            animation: 'spin 0.8s linear infinite',
          }} />
          Loading {symbol} chart…
        </div>
      ) : error ? (
        <div style={{
          height, display: 'flex', alignItems: 'center', justifyContent: 'center',
          flexDirection: 'column', gap: 10, color: '#f05070',
          fontSize: 12, fontFamily: 'JetBrains Mono, monospace', textAlign: 'center',
          padding: '0 20px',
        }}>
          <div style={{ fontSize: 22 }}>⚠</div>
          <div style={{ color: '#e2eaf5', fontWeight: 600 }}>Chart unavailable</div>
          <div style={{ color: '#7a879e', fontSize: 11, maxWidth: 280, lineHeight: 1.6 }}>{error}</div>
          <button onClick={() => { setError(null); setLoading(true); loadHistory(symbol, period).then(d => { setHistData(d || []); setLoading(false); }).catch(e => { setError(e.message); setLoading(false); }); }}
            style={{ marginTop: 4, padding: '5px 14px', background: 'rgba(126,184,247,0.1)', border: '1px solid rgba(126,184,247,0.3)', borderRadius: 6, color: '#7eb8f7', fontSize: 11, fontFamily: 'JetBrains Mono, monospace', cursor: 'pointer' }}>
            ↺ Retry
          </button>
        </div>
      ) : chartData.length === 0 ? (
        <div style={{
          height, display: 'flex', alignItems: 'center', justifyContent: 'center',
          color: '#4a5268', fontSize: 13, fontFamily: 'JetBrains Mono, monospace',
        }}>
          No data for this period
        </div>
      ) : (
        <ResponsiveContainer width="100%" height={height}>
          <ComposedChart
            data={chartData}
            margin={{ top: 4, right: 8, left: 0, bottom: showVolume ? 40 : 0 }}
          >
            <defs>
              {/* Historical area gradient */}
              <linearGradient id={`histGrad-${symbol}`} x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%"   stopColor={lineColor} stopOpacity={0.2} />
                <stop offset="100%" stopColor={lineColor} stopOpacity={0}   />
              </linearGradient>
              {/* Forecast upper/lower fill */}
              <linearGradient id={`fcGrad-${symbol}`} x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%"   stopColor="#f0c060" stopOpacity={0.15} />
                <stop offset="100%" stopColor="#f0c060" stopOpacity={0.03} />
              </linearGradient>
            </defs>

            <CartesianGrid
              strokeDasharray="2 4"
              stroke="rgba(168,181,204,0.05)"
              vertical={false}
            />

            <XAxis
              dataKey="date"
              tick={{ fill: '#4a5268', fontSize: 10, fontFamily: 'JetBrains Mono, monospace' }}
              axisLine={false}
              tickLine={false}
              interval={tickInterval}
              padding={{ left: 8, right: 8 }}
            />

            <YAxis
              yAxisId="price"
              domain={[yMin, yMax]}
              tick={{ fill: '#4a5268', fontSize: 10, fontFamily: 'JetBrains Mono, monospace' }}
              axisLine={false}
              tickLine={false}
              tickFormatter={v => `$${v >= 1000 ? (v / 1000).toFixed(1) + 'k' : v.toFixed(0)}`}
              width={52}
              orientation="left"
            />

            {showVolume && (
              <YAxis
                yAxisId="vol"
                orientation="right"
                tick={{ fill: '#4a5268', fontSize: 9, fontFamily: 'JetBrains Mono, monospace' }}
                axisLine={false}
                tickLine={false}
                tickFormatter={v => v >= 1e6 ? `${(v / 1e6).toFixed(0)}M` : `${(v / 1e3).toFixed(0)}K`}
                width={44}
              />
            )}

            <Tooltip
              content={<ChartTooltip />}
              cursor={{ stroke: 'rgba(168,181,204,0.15)', strokeWidth: 1 }}
            />

            {/* Opening price reference line */}
            {firstClose && (
              <ReferenceLine
                yAxisId="price"
                y={firstClose}
                stroke="rgba(168,181,204,0.12)"
                strokeDasharray="4 4"
              />
            )}

            {/* Forecast start marker */}
            {showForecast && forecastStart && (
              <ReferenceLine
                yAxisId="price"
                x={forecastStart}
                stroke="rgba(240,192,96,0.3)"
                strokeDasharray="4 3"
                label={{ value: 'Forecast →', position: 'insideTopRight', fill: '#f0c060', fontSize: 10, fontFamily: 'JetBrains Mono, monospace' }}
              />
            )}

            {/* Volume bars */}
            {showVolume && (
              <Bar
                yAxisId="vol"
                dataKey="volume"
                fill="rgba(126,184,247,0.12)"
                radius={[1, 1, 0, 0]}
                isAnimationActive={false}
              />
            )}

            {/* Forecast confidence band (upper) */}
            {showForecast && (
              <Area
                yAxisId="price"
                type="monotone"
                dataKey="upper"
                stroke="none"
                fill={`url(#fcGrad-${symbol})`}
                isAnimationActive={false}
                connectNulls={false}
                dot={false}
                activeDot={false}
              />
            )}

            {/* Forecast confidence band (lower) */}
            {showForecast && (
              <Area
                yAxisId="price"
                type="monotone"
                dataKey="lower"
                stroke="none"
                fill="transparent"
                isAnimationActive={false}
                connectNulls={false}
                dot={false}
                activeDot={false}
              />
            )}

            {/* Forecast line */}
            {showForecast && (
              <Line
                yAxisId="price"
                type="monotone"
                dataKey="forecast"
                stroke="#f0c060"
                strokeWidth={1.5}
                strokeDasharray="5 3"
                dot={false}
                activeDot={{ r: 4, fill: '#f0c060', stroke: '#060810', strokeWidth: 2 }}
                connectNulls={false}
                isAnimationActive={false}
              />
            )}

            {/* Historical price area */}
            <Area
              yAxisId="price"
              type="monotone"
              dataKey="close"
              stroke={lineColor}
              strokeWidth={2}
              fill={`url(#histGrad-${symbol})`}
              dot={false}
              activeDot={{ r: 5, fill: lineColor, stroke: '#060810', strokeWidth: 2 }}
              connectNulls={false}
              isAnimationActive={false}
            />
          </ComposedChart>
        </ResponsiveContainer>
      )}

      {/* Forecast disclaimer */}
      {showForecast && histData.length > 0 && (
        <div style={{
          marginTop: 8,
          fontSize: 10,
          color: '#4a5268',
          fontFamily: 'JetBrains Mono, monospace',
          textAlign: 'center',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          <span style={{ color: '#f0c060' }}>✦</span>
          AI forecast based on trend + volatility model · Not financial advice
          <span style={{ color: '#f0c060' }}>✦</span>
        </div>
      )}

      <style>{`
        @keyframes spin { to { transform: rotate(360deg); } }
      `}</style>
    </div>
  );
}
