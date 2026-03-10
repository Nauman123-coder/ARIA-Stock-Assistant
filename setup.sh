#!/bin/bash
# ARIA v8 — fixed apostrophe syntax error
set -e
echo '🚀 Setting up ARIA v8...'
mkdir -p public/images src/components src/hooks src/pages src/utils

cat > .env << 'ENVEOF'
REACT_APP_GROQ_API_KEY=your_groq_api_key_here
REACT_APP_FINNHUB_KEY=your_finnhub_api_key_here
ENVEOF

echo '📁 NOTE: Copy image1.png–image6.png into public/images/'

cat > package.json << 'ENDFILE_PACKAGE_JSON'
{
  "name": "aria-stock-assistant",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.22.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  },
  "browserslist": {
    "production": [">0.2%", "not dead", "not op_mini all"],
    "development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
  }
}
ENDFILE_PACKAGE_JSON

cat > public/index.html << 'ENDFILE_PUBLIC_INDEX_HTML'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#080a0f" />
    <meta name="description" content="ARIA – AI-Powered Stock Market Assistant. Real-time insights, portfolio analysis, and intelligent investment guidance." />
    <title>ARIA — AI Stock Market Assistant</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400&family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500&display=swap" rel="stylesheet" />
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
ENDFILE_PUBLIC_INDEX_HTML

cat > src/index.js << 'ENDFILE_SRC_INDEX_JS'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
ENDFILE_SRC_INDEX_JS

cat > src/App.js << 'ENDFILE_SRC_APP_JS'
import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import LandingPage from './pages/LandingPage';
import DashboardPage from './pages/DashboardPage';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/dashboard/*" element={<DashboardPage />} />
      </Routes>
    </BrowserRouter>
  );
}
ENDFILE_SRC_APP_JS

cat > src/index.css << 'ENDFILE_SRC_INDEX_CSS'
/* ── Global Reset & Variables ─────────────────────────────────────────────── */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

:root {
  /* Core palette – shiny silver black */
  --black:       #060810;
  --black-2:     #0b0e18;
  --black-3:     #111520;
  --black-4:     #181d2e;
  --black-5:     #1e2437;

  /* Silver spectrum */
  --silver-dim:  #4a5268;
  --silver-mid:  #7a879e;
  --silver:      #a8b5cc;
  --silver-hi:   #c8d4e8;
  --silver-max:  #e2eaf5;
  --white:       #f0f4fc;

  /* Accent – electric silver-blue */
  --accent:      #7eb8f7;
  --accent-dim:  rgba(126,184,247,0.15);
  --accent-glow: rgba(126,184,247,0.35);

  /* Accent 2 – warm gold for contrast */
  --gold:        #f0c060;
  --gold-dim:    rgba(240,192,96,0.12);

  /* Positive / Negative */
  --green:       #58e8a2;
  --green-dim:   rgba(88,232,162,0.12);
  --red:         #f05070;
  --red-dim:     rgba(240,80,112,0.12);

  /* Borders */
  --border:      rgba(168,181,204,0.10);
  --border-hi:   rgba(168,181,204,0.22);

  /* Gradients */
  --grad-hero:   linear-gradient(135deg, #060810 0%, #0f1422 50%, #060810 100%);
  --grad-silver: linear-gradient(135deg, #a8b5cc, #e2eaf5, #7a879e);
  --grad-card:   linear-gradient(145deg, rgba(24,29,46,0.9), rgba(11,14,24,0.95));

  /* Fonts */
  --font-display: 'Playfair Display', Georgia, serif;
  --font-body:    'Outfit', sans-serif;
  --font-mono:    'JetBrains Mono', 'Courier New', monospace;

  /* Shadows */
  --shadow-sm:   0 2px 12px rgba(0,0,0,0.4);
  --shadow-md:   0 8px 32px rgba(0,0,0,0.5);
  --shadow-lg:   0 20px 60px rgba(0,0,0,0.6);
  --shadow-glow: 0 0 40px rgba(126,184,247,0.12);
}

html { scroll-behavior: smooth; }

body {
  background: var(--black);
  color: var(--white);
  font-family: var(--font-body);
  font-size: 16px;
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
  overflow-x: hidden;
}

/* Scrollbar */
::-webkit-scrollbar { width: 5px; height: 5px; }
::-webkit-scrollbar-track { background: var(--black-2); }
::-webkit-scrollbar-thumb { background: var(--silver-dim); border-radius: 3px; }
::-webkit-scrollbar-thumb:hover { background: var(--silver-mid); }

/* Selection */
::selection { background: var(--accent-glow); color: var(--white); }

/* ── Utility ──────────────────────────────────────────────────────────────── */
.up   { color: var(--green); }
.down { color: var(--red);   }
.muted { color: var(--silver-mid); }
.accent { color: var(--accent); }
.mono { font-family: var(--font-mono); }

/* ── Noise overlay (applied to body) ─────────────────────────────────────── */
body::before {
  content: '';
  position: fixed;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");
  pointer-events: none;
  z-index: 9999;
  opacity: 0.35;
}

/* ── Animations ───────────────────────────────────────────────────────────── */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}
@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}
@keyframes shimmer {
  0%   { background-position: -200% center; }
  100% { background-position: 200% center; }
}
@keyframes pulse {
  0%,100% { opacity: 1; transform: scale(1); }
  50%      { opacity: 0.5; transform: scale(1.5); }
}
@keyframes float {
  0%,100% { transform: translateY(0px); }
  50%      { transform: translateY(-10px); }
}
@keyframes rotateSlow {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}
@keyframes ticker {
  from { transform: translateX(0); }
  to   { transform: translateX(-50%); }
}
@keyframes bounce {
  0%,60%,100% { transform: translateY(0); }
  30%          { transform: translateY(-8px); }
}

.animate-fade-up   { animation: fadeUp 0.6s ease forwards; }
.animate-fade-in   { animation: fadeIn 0.4s ease forwards; }

/* ── Shimmer text ─────────────────────────────────────────────────────────── */
.shimmer-text {
  background: linear-gradient(90deg, var(--silver-hi) 0%, var(--white) 40%, var(--silver-max) 60%, var(--silver-hi) 100%);
  background-size: 200% auto;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: shimmer 4s linear infinite;
}

/* ── Glass card ───────────────────────────────────────────────────────────── */
.glass {
  background: var(--grad-card);
  border: 1px solid var(--border);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}

/* ── Responsive helpers ───────────────────────────────────────────────────── */
@media (max-width: 768px) {
  body { font-size: 15px; }
}
ENDFILE_SRC_INDEX_CSS

cat > src/utils/data.js << 'ENDFILE_SRC_UTILS_DATA_JS'
export const MOCK_PORTFOLIO = [
  { symbol: 'NVDA', name: 'NVIDIA Corp',      shares: 12, avgCost: 412.50, sector: 'Technology' },
  { symbol: 'AAPL', name: 'Apple Inc',         shares: 25, avgCost: 178.30, sector: 'Technology' },
  { symbol: 'MSFT', name: 'Microsoft Corp',    shares:  8, avgCost: 335.00, sector: 'Technology' },
  { symbol: 'JPM',  name: 'JPMorgan Chase',    shares: 15, avgCost: 172.40, sector: 'Financials' },
  { symbol: 'AMZN', name: 'Amazon.com Inc',    shares:  6, avgCost: 138.90, sector: 'Consumer' },
  { symbol: 'TSLA', name: 'Tesla Inc',         shares: 20, avgCost: 230.00, sector: 'Consumer' },
];

export const MOCK_PRICES = {
  NVDA: { price: 875.40, change:  2.31, changeAmt:  19.78 },
  AAPL: { price: 189.50, change: -0.42, changeAmt:  -0.80 },
  MSFT: { price: 415.20, change:  1.12, changeAmt:   4.60 },
  JPM:  { price: 198.70, change:  0.87, changeAmt:   1.71 },
  AMZN: { price: 182.30, change: -1.23, changeAmt:  -2.27 },
  TSLA: { price: 178.90, change: -3.12, changeAmt:  -5.76 },
  GOOG: { price: 175.60, change:  0.54, changeAmt:   0.95 },
  META: { price: 505.30, change:  1.88, changeAmt:   9.35 },
  BRK:  { price: 410.20, change:  0.22, changeAmt:   0.89 },
  AMD:  { price: 162.40, change: -1.44, changeAmt:  -2.37 },
  NFLX: { price: 628.10, change:  0.94, changeAmt:   5.86 },
  INTC: { price:  35.70, change: -0.84, changeAmt:  -0.30 },
};

export const STOCK_NAMES = {
  NVDA: 'NVIDIA Corp',        AAPL: 'Apple Inc',
  MSFT: 'Microsoft Corp',     JPM:  'JPMorgan Chase',
  AMZN: 'Amazon.com Inc',     TSLA: 'Tesla Inc',
  GOOG: 'Alphabet Inc',       META: 'Meta Platforms',
  BRK:  'Berkshire Hathaway', AMD:  'Advanced Micro Dev.',
  NFLX: 'Netflix Inc',        INTC: 'Intel Corp',
};

export const MARKET_INDICES = [
  { name: 'S&P 500', value: '5,234.18', change: '+0.74%', up: true  },
  { name: 'NASDAQ',  value: '16,428.82',change: '+1.02%', up: true  },
  { name: 'DOW',     value: '39,127.14',change: '+0.31%', up: true  },
  { name: 'VIX',     value: '14.23',    change: '-2.18%', up: false },
  { name: 'FTSE',    value: '7,948.31', change: '+0.18%', up: true  },
  { name: 'Nikkei',  value: '38,240.12',change: '+0.52%', up: true  },
];

export const WATCHLIST = ['GOOG', 'META', 'NFLX', 'AMD'];

export const SECTOR_COLORS = ['#7eb8f7','#58e8a2','#f0c060','#f05070','#c084fc'];

export function generateSparkline(up, points = 24) {
  const data = [];
  let val = 50 + Math.random() * 20;
  for (let i = 0; i < points; i++) {
    val += (Math.random() - (up ? 0.42 : 0.58)) * 6;
    val = Math.max(10, Math.min(90, val));
    data.push(val);
  }
  return data;
}
ENDFILE_SRC_UTILS_DATA_JS

cat > src/hooks/useGroqChat.js << 'ENDFILE_SRC_HOOKS_USEGROQCHAT_JS'
import { useState, useCallback, useRef } from 'react';

const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const GROQ_MODEL   = 'llama-3.3-70b-versatile';

function buildSystemPrompt(quotes) {
  const holdings = [
    { symbol: 'NVDA', name: 'NVIDIA Corp',   shares: 12, avgCost: 412.50, sector: 'Technology' },
    { symbol: 'AAPL', name: 'Apple Inc',     shares: 25, avgCost: 178.30, sector: 'Technology' },
    { symbol: 'MSFT', name: 'Microsoft',     shares:  8, avgCost: 335.00, sector: 'Technology' },
    { symbol: 'JPM',  name: 'JPMorgan',      shares: 15, avgCost: 172.40, sector: 'Financials' },
    { symbol: 'AMZN', name: 'Amazon',        shares:  6, avgCost: 138.90, sector: 'Consumer'   },
    { symbol: 'TSLA', name: 'Tesla',         shares: 20, avgCost: 230.00, sector: 'Consumer'   },
  ];

  let totalValue = 0, totalCost = 0;
  const rows = holdings.map(h => {
    const price = quotes?.[h.symbol]?.price || h.avgCost;
    const val   = price * h.shares;
    const pl    = (price - h.avgCost) * h.shares;
    const plPct = ((price - h.avgCost) / h.avgCost) * 100;
    totalValue += val;
    totalCost  += h.shares * h.avgCost;
    return `| ${h.symbol} | ${h.name} | ${h.shares} | $${h.avgCost.toFixed(2)} | $${price.toFixed(2)} | ${plPct >= 0 ? '+' : ''}${plPct.toFixed(1)}% | ${pl >= 0 ? '+' : ''}$${Math.abs(pl).toFixed(0)} |`;
  });
  const totalPL    = totalValue - totalCost;
  const totalPLPct = ((totalPL / totalCost) * 100).toFixed(2);

  return `You are ARIA, an elite AI investment analyst.

## Live Portfolio
| Symbol | Name | Shares | Avg Cost | Price | Return | P&L |
|--------|------|--------|----------|-------|--------|-----|
${rows.join('\n')}
Total: $${totalValue.toFixed(0)} | P&L: ${totalPL >= 0 ? '+' : ''}$${Math.abs(totalPL).toFixed(0)} (${totalPLPct}%)

## Format Rules
- Use ## headers, tables, - bullets, **bold**, > blockquotes
- Be direct, data-driven, reference specific numbers
- Give clear buy/sell/hold verdicts when asked`;
}

const WELCOME = {
  role: 'assistant',
  content: `## Welcome to ARIA 👋

I'm your **Advanced Real-time Investment Assistant** — powered by Groq LLM.

- 📊 **Portfolio Analysis** — risk, allocation, P&L
- 🔍 **Stock Research** — valuations, catalysts
- ⚖️ **Comparisons** — side-by-side with tables
- 📈 **Strategy** — rebalancing, entry/exit levels

> Try: *"Full portfolio risk analysis"* or *"Compare NVDA vs AMD"*`,
};

export function useGroqChat(quotes) {
  const [messages,    setMessages]    = useState([WELCOME]);
  const [isStreaming, setIsStreaming] = useState(false);

  const abortRef   = useRef(null);
  const bufferRef  = useRef('');

  // KEY DESIGN: during streaming we NEVER call setMessages.
  // Instead we expose a ref that ChatPanel reads directly via DOM.
  // setMessages is only called TWICE per response:
  //   1. At start: add user msg + empty placeholder
  //   2. At end:   fill placeholder with final text
  // This means ZERO React re-renders during streaming → no crash.
  const streamingDomRef = useRef(null); // ChatPanel registers its streaming div here

  const sendMessage = useCallback(async (userText) => {
    if (!userText.trim() || isStreaming) return;

    const apiKey = process.env.REACT_APP_GROQ_API_KEY;
    if (!apiKey || apiKey === 'your_groq_api_key_here') {
      setMessages(prev => [...prev,
        { role: 'user', content: userText },
        { role: 'assistant', content: '## ⚠️ API Key Missing\n\nAdd to `.env`:\n```\nREACT_APP_GROQ_API_KEY=your_key\n```\nGet free key at [console.groq.com](https://console.groq.com)' },
      ]);
      return;
    }

    const history = [...messages, { role: 'user', content: userText }];
    bufferRef.current = '';

    // ONLY state update #1 — add user message + streaming placeholder
    setMessages([...history, { role: 'assistant', content: '', streaming: true }]);
    setIsStreaming(true);
    abortRef.current = new AbortController();

    try {
      const res = await fetch(GROQ_API_URL, {
        method:  'POST',
        headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${apiKey}` },
        signal:  abortRef.current.signal,
        body: JSON.stringify({
          model: GROQ_MODEL, stream: true, max_tokens: 1024, temperature: 0.7,
          messages: [
            { role: 'system', content: buildSystemPrompt(quotes) },
            ...history.map(m => ({ role: m.role, content: m.content })),
          ],
        }),
      });

      if (!res.ok) {
        const e = await res.json().catch(() => ({}));
        throw new Error(e.error?.message || `HTTP ${res.status}`);
      }

      const reader  = res.body.getReader();
      const decoder = new TextDecoder();

      loop: while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        for (const line of decoder.decode(value, { stream: true }).split('\n')) {
          if (!line.startsWith('data: ')) continue;
          const raw = line.slice(6).trim();
          if (raw === '[DONE]') break loop;
          try {
            const delta = JSON.parse(raw).choices?.[0]?.delta?.content;
            if (delta) {
              bufferRef.current += delta;
              // Write directly to DOM — ZERO React involvement
              if (streamingDomRef.current) {
                // insertAdjacentText only appends the NEW delta — never rewrites the full string
                streamingDomRef.current.insertAdjacentText('beforeend', delta);
                // Auto-scroll (throttled: only every ~5 tokens to avoid layout thrash)
                if (bufferRef.current.length % 40 < delta.length) {
                  const el = streamingDomRef.current.closest('.aria-msgs-scroll');
                  if (el) el.scrollTop = el.scrollHeight;
                }
              }
            }
          } catch (_) {}
        }
      }

      // ONLY state update #2 — finalize with full text (triggers one re-render)
      const finalText = bufferRef.current;
      setMessages(prev => {
        const copy = [...prev];
        copy[copy.length - 1] = { role: 'assistant', content: finalText, streaming: false };
        return copy;
      });

    } catch (err) {
      if (err.name === 'AbortError') {
        const partial = bufferRef.current;
        setMessages(prev => {
          const copy = [...prev];
          if (copy[copy.length - 1]?.streaming) {
            copy[copy.length - 1] = { role: 'assistant', content: partial || '*(stopped)*', streaming: false };
          }
          return copy;
        });
      } else {
        setMessages(prev => [
          ...prev.filter(m => !(m.streaming && !m.content)),
          { role: 'assistant', content: `## ❌ Error\n\n**${err.message}**\n\nCheck your API key and connection.` },
        ]);
      }
    } finally {
      setIsStreaming(false);
      bufferRef.current = '';
    }
  }, [messages, isStreaming, quotes]);

  const stopStreaming = useCallback(() => abortRef.current?.abort(), []);

  const clearChat = useCallback(() => {
    abortRef.current?.abort();
    bufferRef.current = '';
    setMessages([WELCOME]);
    setIsStreaming(false);
  }, []);

  return { messages, isStreaming, sendMessage, stopStreaming, clearChat, streamingDomRef };
}
ENDFILE_SRC_HOOKS_USEGROQCHAT_JS

cat > src/hooks/useStockData.js << 'ENDFILE_SRC_HOOKS_USESTOCKDATA_JS'
import { useState, useEffect, useCallback, useRef } from 'react';

// ── Finnhub — for live quotes (free tier works fine) ───────────────────────
const FINNHUB = 'https://finnhub.io/api/v1';
function getKey() { return process.env.REACT_APP_FINNHUB_KEY || ''; }

// ── Yahoo Finance — for historical candles (no key needed, CORS via proxy) ─
// We use allorigins.win as a reliable CORS proxy
const YF_PROXY = 'https://query1.finance.yahoo.com';

export const ALL_SYMBOLS = [
  'AAPL', 'NVDA', 'MSFT', 'GOOGL', 'AMZN',
  'META', 'TSLA', 'JPM',  'AMD',   'NFLX',
];

export const INDEX_SYMBOLS = [
  { symbol: 'SPY',  name: 'S&P 500' },
  { symbol: 'QQQ',  name: 'NASDAQ'  },
  { symbol: 'DIA',  name: 'DOW'     },
  { symbol: 'VIXY', name: 'VIX'     },
];

export const PORTFOLIO_HOLDINGS = [
  { symbol: 'NVDA', name: 'NVIDIA Corp',   shares: 12, avgCost: 412.50, sector: 'Technology' },
  { symbol: 'AAPL', name: 'Apple Inc',     shares: 25, avgCost: 178.30, sector: 'Technology' },
  { symbol: 'MSFT', name: 'Microsoft',     shares:  8, avgCost: 335.00, sector: 'Technology' },
  { symbol: 'JPM',  name: 'JPMorgan',      shares: 15, avgCost: 172.40, sector: 'Financials' },
  { symbol: 'AMZN', name: 'Amazon',        shares:  6, avgCost: 138.90, sector: 'Consumer'   },
  { symbol: 'TSLA', name: 'Tesla',         shares: 20, avgCost: 230.00, sector: 'Consumer'   },
];

export const SECTOR_COLORS = {
  Technology: '#7eb8f7',
  Financials: '#58e8a2',
  Consumer:   '#f0c060',
  Healthcare: '#c084fc',
  Energy:     '#f05070',
};

const STOCK_NAMES = {
  AAPL: 'Apple Inc',       NVDA: 'NVIDIA Corp',  MSFT: 'Microsoft',
  GOOGL: 'Alphabet',       AMZN: 'Amazon',       META: 'Meta Platforms',
  TSLA: 'Tesla',           JPM: 'JPMorgan',      AMD: 'AMD',
  NFLX: 'Netflix',         SPY: 'S&P 500 ETF',   QQQ: 'NASDAQ ETF',
  DIA: 'DOW ETF',          VIXY: 'VIX ETF',
};

// ── Finnhub: live quote ────────────────────────────────────────────────────
async function fetchQuote(symbol, key) {
  const res = await fetch(`${FINNHUB}/quote?symbol=${symbol}&token=${key}`);
  if (!res.ok) throw new Error(`Finnhub ${res.status}`);
  const d = await res.json();
  if (!d.c || d.c === 0) return null;
  return {
    symbol, name: STOCK_NAMES[symbol] || symbol,
    price: d.c, change: d.d, changePct: d.dp,
    high: d.h, low: d.l, open: d.o, prevClose: d.pc,
  };
}

// ── Yahoo Finance: historical candles (free, no key) ──────────────────────
// Maps our period labels to Yahoo Finance range + interval params
const YF_PERIOD_MAP = {
  '1W': { range: '5d',  interval: '60m' },
  '1M': { range: '1mo', interval: '1d'  },
  '3M': { range: '3mo', interval: '1d'  },
  '6M': { range: '6mo', interval: '1d'  },
  '1Y': { range: '1y',  interval: '1wk' },
  '2Y': { range: '2y',  interval: '1wk' },
};

async function fetchYahooCandles(symbol, period) {
  const cfg = YF_PERIOD_MAP[period] || YF_PERIOD_MAP['3M'];

  // Yahoo Finance v8 chart API — works directly from browser in many cases
  // If blocked, we try through a public CORS proxy
  const yfUrl = `${YF_PROXY}/v8/finance/chart/${symbol}?range=${cfg.range}&interval=${cfg.interval}&includePrePost=false`;

  let res;
  try {
    // Try direct first
    res = await fetch(yfUrl, {
      headers: { 'Accept': 'application/json' },
    });
  } catch (_) {
    // If CORS blocked, try proxy
    const proxied = `https://corsproxy.io/?${encodeURIComponent(yfUrl)}`;
    res = await fetch(proxied);
  }

  if (!res.ok) throw new Error(`Yahoo Finance returned ${res.status}`);

  const json = await res.json();
  const result = json?.chart?.result?.[0];
  if (!result) throw new Error('No chart data in response');

  const timestamps = result.timestamp;
  const quote      = result.indicators?.quote?.[0];
  if (!timestamps?.length || !quote) throw new Error('Empty chart data');

  const adjClose = result.indicators?.adjclose?.[0]?.adjclose;

  return timestamps.map((ts, i) => {
    const close = adjClose?.[i] ?? quote.close?.[i];
    if (close == null || close === 0) return null;
    return {
      ts:     ts * 1000,
      date:   new Date(ts * 1000).toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
      close:  +close.toFixed(2),
      open:   quote.open?.[i]   != null ? +quote.open[i].toFixed(2)   : null,
      high:   quote.high?.[i]   != null ? +quote.high[i].toFixed(2)   : null,
      low:    quote.low?.[i]    != null ? +quote.low[i].toFixed(2)    : null,
      volume: quote.volume?.[i] ?? null,
    };
  }).filter(Boolean);
}

// ── Main hook ──────────────────────────────────────────────────────────────
export function useStockData() {
  const [quotes,      setQuotes]      = useState({});
  const [loading,     setLoading]     = useState(true);
  const [error,       setError]       = useState(null);
  const [lastUpdated, setLastUpdated] = useState(null);

  // Cache in ref — never triggers re-renders, keeps loadHistory stable
  const cacheRef = useRef({});

  const loadQuotes = useCallback(async () => {
    const key = getKey();
    if (!key) { setError('no_key'); setLoading(false); return; }

    const results = {};
    for (const sym of ALL_SYMBOLS) {
      try {
        const q = await fetchQuote(sym, key);
        if (q) results[sym] = q;
        await new Promise(r => setTimeout(r, 130));
      } catch (e) {
        console.warn(`Quote ${sym}:`, e.message);
      }
    }

    if (Object.keys(results).length > 0) {
      setQuotes(results);
      setLastUpdated(new Date());
      setError(null);
    } else {
      setError('fetch_failed');
    }
    setLoading(false);
  }, []);

  // Stable loadHistory — empty deps, cache in ref
  const loadHistory = useCallback(async (symbol, period = '3M') => {
    const cacheKey = `${symbol}-${period}`;
    if (cacheRef.current[cacheKey]) return cacheRef.current[cacheKey];

    try {
      const data = await fetchYahooCandles(symbol, period);
      if (data.length > 0) {
        cacheRef.current[cacheKey] = data;
      }
      return data;
    } catch (e) {
      console.error(`History ${symbol}/${period}:`, e.message);
      throw e; // re-throw so StockChart can show the real error
    }
  }, []); // stable — no deps

  useEffect(() => {
    loadQuotes();
    const iv = setInterval(loadQuotes, 120_000);
    return () => clearInterval(iv);
  }, []); // eslint-disable-line

  return { quotes, loading, error, lastUpdated, loadHistory, refresh: loadQuotes };
}

// ── Index hook ─────────────────────────────────────────────────────────────
export function useIndexData() {
  const [indices, setIndices] = useState([]);

  useEffect(() => {
    const key = getKey();
    if (!key) return;

    const load = async () => {
      const out = [];
      for (const { symbol, name } of INDEX_SYMBOLS) {
        try {
          const q = await fetchQuote(symbol, key);
          if (q) out.push({
            symbol, name,
            value:     q.price.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }),
            change:    q.change,
            changePct: q.changePct,
            up:        q.change >= 0,
          });
          await new Promise(r => setTimeout(r, 130));
        } catch (e) {
          console.warn(`Index ${symbol}:`, e.message);
        }
      }
      setIndices(out);
    };
    load();
  }, []); // eslint-disable-line

  return { indices };
}
ENDFILE_SRC_HOOKS_USESTOCKDATA_JS

cat > src/components/DonutChart.js << 'ENDFILE_SRC_COMPONENTS_DONUTCHART_JS'
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
ENDFILE_SRC_COMPONENTS_DONUTCHART_JS

cat > src/components/StockChart.js << 'ENDFILE_SRC_COMPONENTS_STOCKCHART_JS'
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
ENDFILE_SRC_COMPONENTS_STOCKCHART_JS

cat > src/components/MiniChart.js << 'ENDFILE_SRC_COMPONENTS_MINICHART_JS'
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
ENDFILE_SRC_COMPONENTS_MINICHART_JS

cat > src/components/MarkdownMessage.js << 'ENDFILE_SRC_COMPONENTS_MARKDOWNMESSAGE_JS'
import React, { memo, useMemo } from 'react';

/* ─── Inline formatter: bold, code, links ──────────────────────────────── */
function InlineText({ text }) {
  // Split on **bold**, `code`, and [link](url)
  const parts = [];
  let remaining = text;
  let key = 0;

  while (remaining.length > 0) {
    // **bold**
    const boldMatch = remaining.match(/\*\*(.+?)\*\*/);
    // `inline code`
    const codeMatch = remaining.match(/`([^`]+)`/);
    // [text](url)
    const linkMatch = remaining.match(/\[([^\]]+)\]\(([^)]+)\)/);

    // Find which comes first
    const matches = [
      boldMatch && { type: 'bold', idx: boldMatch.index, match: boldMatch },
      codeMatch && { type: 'code', idx: codeMatch.index, match: codeMatch },
      linkMatch && { type: 'link', idx: linkMatch.index, match: linkMatch },
    ].filter(Boolean).sort((a, b) => a.idx - b.idx);

    if (!matches.length) {
      parts.push(<span key={key++}>{remaining}</span>);
      break;
    }

    const first = matches[0];
    if (first.idx > 0) {
      parts.push(<span key={key++}>{remaining.slice(0, first.idx)}</span>);
    }

    if (first.type === 'bold') {
      parts.push(
        <strong key={key++} style={{ color: '#e2eaf5', fontWeight: 700 }}>
          {first.match[1]}
        </strong>
      );
      remaining = remaining.slice(first.idx + first.match[0].length);
    } else if (first.type === 'code') {
      parts.push(
        <code key={key++} style={{
          background: 'rgba(11,14,24,0.8)',
          border: '1px solid rgba(168,181,204,0.15)',
          borderRadius: 4,
          padding: '1px 6px',
          fontFamily: 'JetBrains Mono, monospace',
          fontSize: '0.88em',
          color: '#7eb8f7',
        }}>
          {first.match[1]}
        </code>
      );
      remaining = remaining.slice(first.idx + first.match[0].length);
    } else if (first.type === 'link') {
      parts.push(
        <a key={key++} href={first.match[2]} target="_blank" rel="noreferrer"
          style={{ color: '#7eb8f7', textDecoration: 'underline', textUnderlineOffset: 3 }}>
          {first.match[1]}
        </a>
      );
      remaining = remaining.slice(first.idx + first.match[0].length);
    }
  }

  return <>{parts}</>;
}

/* ─── Table renderer ───────────────────────────────────────────────────── */
function MarkdownTable({ rows }) {
  if (rows.length < 2) return null;
  const headers = rows[0].split('|').map(c => c.trim()).filter(Boolean);
  // Row 1 is separator (---|---|---), skip it
  const dataRows = rows.slice(2).map(r =>
    r.split('|').map(c => c.trim()).filter(Boolean)
  ).filter(r => r.length > 0);

  return (
    <div style={{ overflowX: 'auto', margin: '10px 0' }}>
      <table style={{
        width: '100%',
        borderCollapse: 'collapse',
        fontSize: 12,
        fontFamily: 'JetBrains Mono, monospace',
        minWidth: 300,
      }}>
        <thead>
          <tr>
            {headers.map((h, i) => (
              <th key={i} style={{
                padding: '6px 10px',
                textAlign: 'left',
                color: '#7eb8f7',
                background: 'rgba(126,184,247,0.07)',
                borderBottom: '1px solid rgba(126,184,247,0.2)',
                fontWeight: 700,
                fontSize: 11,
                textTransform: 'uppercase',
                letterSpacing: '0.05em',
                whiteSpace: 'nowrap',
              }}>
                <InlineText text={h} />
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {dataRows.map((row, ri) => (
            <tr key={ri} style={{ borderBottom: '1px solid rgba(168,181,204,0.06)' }}>
              {row.map((cell, ci) => {
                const isUp   = cell.includes('▲') || cell.startsWith('+');
                const isDown = cell.includes('▼') || (cell.startsWith('-') && !cell.startsWith('--'));
                return (
                  <td key={ci} style={{
                    padding: '7px 10px',
                    color: isUp ? '#58e8a2' : isDown ? '#f05070' : '#c8d4e8',
                    background: ri % 2 === 0 ? 'transparent' : 'rgba(168,181,204,0.02)',
                    whiteSpace: ci === 0 ? 'nowrap' : 'normal',
                  }}>
                    <InlineText text={cell} />
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

/* ─── Code block renderer ──────────────────────────────────────────────── */
function CodeBlock({ code, lang }) {
  return (
    <pre style={{
      background: 'rgba(6,8,16,0.8)',
      border: '1px solid rgba(168,181,204,0.1)',
      borderRadius: 8,
      padding: '12px 14px',
      overflowX: 'auto',
      margin: '8px 0',
      fontSize: 12,
      fontFamily: 'JetBrains Mono, monospace',
      color: '#a8b5cc',
      lineHeight: 1.6,
    }}>
      {lang && (
        <div style={{ fontSize: 10, color: '#4a5268', marginBottom: 6, textTransform: 'uppercase', letterSpacing: '0.1em' }}>
          {lang}
        </div>
      )}
      <code style={{ color: '#c8d4e8' }}>{code}</code>
    </pre>
  );
}

/* ─── Main markdown renderer ───────────────────────────────────────────── */
const MarkdownMessage = memo(function MarkdownMessage({ content, streaming }) {
  if (!content) return null;

  // Memoize the block parsing so it only re-runs when content changes
  // This is critical for performance during streaming
  const blocks = useMemo(() => {
    const lines  = content.split('\n');
    const result = [];
    let i        = 0;

  while (i < lines.length) {
    const line = lines[i];

    // ── Code block ──
    if (line.startsWith('```')) {
      const lang = line.slice(3).trim();
      const codeLines = [];
      i++;
      while (i < lines.length && !lines[i].startsWith('```')) {
        codeLines.push(lines[i]);
        i++;
      }
      result.push({ type: 'code', lang, content: codeLines.join('\n') });
      i++;
      continue;
    }

    // ── Table ──
    if (line.startsWith('|') && i + 1 < lines.length && lines[i + 1]?.match(/^\|[-\s|:]+\|/)) {
      const tableRows = [];
      while (i < lines.length && lines[i].startsWith('|')) {
        tableRows.push(lines[i]);
        i++;
      }
      result.push({ type: 'table', rows: tableRows });
      continue;
    }

    // ── H2 ──
    if (line.startsWith('## ')) {
      result.push({ type: 'h2', text: line.slice(3) });
      i++;
      continue;
    }

    // ── H3 ──
    if (line.startsWith('### ')) {
      result.push({ type: 'h3', text: line.slice(4) });
      i++;
      continue;
    }

    // ── HR ──
    if (line.match(/^---+$/)) {
      result.push({ type: 'hr' });
      i++;
      continue;
    }

    // ── Blockquote ──
    if (line.startsWith('> ')) {
      const quoteLines = [];
      while (i < lines.length && lines[i].startsWith('> ')) {
        quoteLines.push(lines[i].slice(2));
        i++;
      }
      result.push({ type: 'blockquote', lines: quoteLines });
      continue;
    }

    // ── Ordered list ──
    if (line.match(/^\d+\.\s/)) {
      const items = [];
      while (i < lines.length && lines[i].match(/^\d+\.\s/)) {
        items.push(lines[i].replace(/^\d+\.\s/, ''));
        i++;
      }
      result.push({ type: 'ol', items });
      continue;
    }

    // ── Unordered list ──
    if (line.match(/^[-*]\s/)) {
      const items = [];
      while (i < lines.length && lines[i].match(/^[-*]\s/)) {
        items.push(lines[i].replace(/^[-*]\s/, ''));
        i++;
      }
      result.push({ type: 'ul', items });
      continue;
    }

    // ── Empty line ──
    if (line.trim() === '') {
      result.push({ type: 'br' });
      i++;
      continue;
    }

    // ── Paragraph ──
    const paraLines = [];
    while (i < lines.length &&
           lines[i].trim() !== '' &&
           !lines[i].startsWith('#') &&
           !lines[i].startsWith('|') &&
           !lines[i].startsWith('```') &&
           !lines[i].startsWith('> ') &&
           !lines[i].startsWith('- ') &&
           !lines[i].startsWith('* ') &&
           !lines[i].match(/^\d+\.\s/) &&
           !lines[i].match(/^---+$/)) {
      paraLines.push(lines[i]);
      i++;
    }
    if (paraLines.length) {
      result.push({ type: 'p', text: paraLines.join(' ') });
    }
  }

    return result;
  }, [content]); // eslint-disable-line

  return (
    <div style={{ lineHeight: 1.7, fontSize: 13, color: '#c8d4e8' }}>
      {blocks.map((block, bi) => {
        switch (block.type) {
          case 'h2':
            return (
              <div key={bi} style={{
                fontSize: 15,
                fontWeight: 700,
                color: '#e2eaf5',
                fontFamily: 'Outfit, sans-serif',
                marginBottom: 8,
                marginTop: bi > 0 ? 16 : 0,
                display: 'flex',
                alignItems: 'center',
                gap: 8,
              }}>
                <span style={{ width: 3, height: 16, background: '#7eb8f7', borderRadius: 2, display: 'inline-block', flexShrink: 0 }} />
                <InlineText text={block.text} />
              </div>
            );
          case 'h3':
            return (
              <div key={bi} style={{
                fontSize: 13,
                fontWeight: 700,
                color: '#c8d4e8',
                marginBottom: 6,
                marginTop: bi > 0 ? 12 : 0,
              }}>
                <InlineText text={block.text} />
              </div>
            );
          case 'hr':
            return <hr key={bi} style={{ border: 'none', borderTop: '1px solid rgba(168,181,204,0.1)', margin: '12px 0' }} />;
          case 'blockquote':
            return (
              <div key={bi} style={{
                borderLeft: '3px solid #7eb8f7',
                paddingLeft: 12,
                margin: '10px 0',
                background: 'rgba(126,184,247,0.05)',
                borderRadius: '0 6px 6px 0',
                padding: '8px 12px',
              }}>
                {block.lines.map((l, li) => (
                  <div key={li} style={{ color: '#a8b5cc', fontSize: 13, fontStyle: 'italic' }}>
                    <InlineText text={l} />
                  </div>
                ))}
              </div>
            );
          case 'ul':
            return (
              <ul key={bi} style={{ paddingLeft: 0, margin: '8px 0', listStyle: 'none' }}>
                {block.items.map((item, ii) => (
                  <li key={ii} style={{ display: 'flex', gap: 8, marginBottom: 5, alignItems: 'flex-start' }}>
                    <span style={{ color: '#7eb8f7', flexShrink: 0, marginTop: 2, fontSize: 10 }}>◆</span>
                    <span><InlineText text={item} /></span>
                  </li>
                ))}
              </ul>
            );
          case 'ol':
            return (
              <ol key={bi} style={{ paddingLeft: 0, margin: '8px 0', listStyle: 'none', counterReset: 'item' }}>
                {block.items.map((item, ii) => (
                  <li key={ii} style={{ display: 'flex', gap: 10, marginBottom: 6, alignItems: 'flex-start' }}>
                    <span style={{
                      color: '#060810',
                      background: '#7eb8f7',
                      borderRadius: 4,
                      width: 18,
                      height: 18,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontSize: 10,
                      fontWeight: 700,
                      flexShrink: 0,
                      marginTop: 2,
                      fontFamily: 'JetBrains Mono, monospace',
                    }}>
                      {ii + 1}
                    </span>
                    <span><InlineText text={item} /></span>
                  </li>
                ))}
              </ol>
            );
          case 'table':
            return <MarkdownTable key={bi} rows={block.rows} />;
          case 'code':
            return <CodeBlock key={bi} code={block.content} lang={block.lang} />;
          case 'p':
            return (
              <p key={bi} style={{ margin: '6px 0' }}>
                <InlineText text={block.text} />
              </p>
            );
          case 'br':
            return <div key={bi} style={{ height: 4 }} />;
          default:
            return null;
        }
      })}
      {streaming && (
        <span style={{
          display: 'inline-block',
          width: 8,
          height: 14,
          background: '#7eb8f7',
          borderRadius: 2,
          marginLeft: 2,
          animation: 'cursorBlink 0.7s step-end infinite',
          verticalAlign: 'text-bottom',
        }} />
      )}
    </div>
  );
});

export default MarkdownMessage;
ENDFILE_SRC_COMPONENTS_MARKDOWNMESSAGE_JS

cat > src/components/ChatPanel.js << 'ENDFILE_SRC_COMPONENTS_CHATPANEL_JS'
import React, { useState, useEffect, useRef, memo } from 'react';
import { useGroqChat } from '../hooks/useGroqChat';
import MarkdownMessage from './MarkdownMessage';

const SUGGESTIONS = [
  { icon: '📊', label: 'Full portfolio risk analysis' },
  { icon: '⚖️', label: 'Compare NVDA vs AMD in detail' },
  { icon: '📉', label: 'Should I cut my TSLA position?' },
  { icon: '💰', label: 'Show my complete P&L breakdown' },
  { icon: '🎯', label: 'Best buy opportunity right now?' },
  { icon: '🔄', label: 'How should I rebalance my portfolio?' },
];

// ── Individual message bubble ──────────────────────────────────────────────
// memo: only re-renders when its own props change
const MessageBubble = memo(function MessageBubble({ msg, streamingDomRef }) {
  const isUser = msg.role === 'user';

  if (isUser) {
    return (
      <div className="aria-msg aria-msg-user">
        <div className="aria-bubble aria-bubble-user">{msg.content}</div>
      </div>
    );
  }

  // Streaming placeholder — content written directly to DOM, no React re-renders
  if (msg.streaming) {
    return (
      <div className="aria-msg aria-msg-ai">
        <div className="aria-avatar">◈</div>
        <div className="aria-bubble aria-bubble-ai">
          <pre
            ref={streamingDomRef}
            style={{
              fontFamily: 'Outfit, sans-serif',
              fontSize: 13,
              color: '#c8d4e8',
              whiteSpace: 'pre-wrap',
              wordBreak: 'break-word',
              margin: 0,
              lineHeight: 1.7,
            }}
          />
          <span className="aria-cursor" />
        </div>
      </div>
    );
  }

  // Completed message — render full markdown (only fires once per message)
  return (
    <div className="aria-msg aria-msg-ai">
      <div className="aria-avatar">◈</div>
      <div className="aria-bubble aria-bubble-ai">
        <MarkdownMessage content={msg.content} streaming={false} />
      </div>
    </div>
  );
});

// ── Main ChatPanel ─────────────────────────────────────────────────────────
export default function ChatPanel({ open, onClose, quotes }) {
  const { messages, isStreaming, sendMessage, stopStreaming, clearChat, streamingDomRef } =
    useGroqChat(quotes);

  const [input,      setInput]      = useState('');
  const [fullscreen, setFullscreen] = useState(false);
  const inputRef  = useRef(null);
  const msgsRef   = useRef(null);

  // Focus input when panel opens
  useEffect(() => {
    if (open) setTimeout(() => inputRef.current?.focus(), 320);
  }, [open]);

  // Auto-resize textarea
  const handleInput = (e) => {
    setInput(e.target.value);
    e.target.style.height = 'auto';
    e.target.style.height = Math.min(e.target.scrollHeight, 120) + 'px';
  };

  const send = () => {
    const t = input.trim();
    if (!t || isStreaming) return;
    setInput('');
    if (inputRef.current) inputRef.current.style.height = 'auto';
    sendMessage(t);
  };

  const showSuggestions = messages.length <= 1 && !isStreaming;

  return (
    <>
      {fullscreen && open && (
        <div
          onClick={() => setFullscreen(false)}
          style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', zIndex: 299, backdropFilter: 'blur(3px)' }}
        />
      )}

      <div className={`aria-panel${open ? ' open' : ''}${fullscreen ? ' fullscreen' : ''}`}>

        {/* ── Header ── */}
        <div className="aria-header">
          <div className="aria-header-left">
            <div className="aria-header-avatar">◈</div>
            <div>
              <div className="aria-header-title">
                ARIA
                <span className="aria-badge">AI</span>
                {isStreaming && <span className="aria-live" title="Streaming" />}
              </div>
              <div className="aria-header-sub">
                {isStreaming ? 'Analyzing…' : 'Portfolio-aware · Groq LLM'}
              </div>
            </div>
          </div>
          <div className="aria-header-btns">
            <button className="aria-icon-btn" onClick={() => setFullscreen(f => !f)} title={fullscreen ? 'Exit fullscreen' : 'Fullscreen'}>
              {fullscreen ? '⊡' : '⊞'}
            </button>
            <button className="aria-icon-btn" onClick={clearChat} title="New conversation">↺</button>
            <button className="aria-icon-btn" onClick={onClose} title="Close">✕</button>
          </div>
        </div>

        {/* ── Messages ── */}
        <div className="aria-msgs-scroll" ref={msgsRef}>
          {messages.map((msg, i) => (
            <MessageBubble
              key={i}
              msg={msg}
              streamingDomRef={msg.streaming ? streamingDomRef : undefined}
            />
          ))}
          <div style={{ height: 8 }} />
        </div>

        {/* ── Suggestions ── */}
        {showSuggestions && (
          <div className="aria-suggestions">
            <div className="aria-suggestions-label">Quick prompts</div>
            {SUGGESTIONS.map((s, i) => (
              <button key={i} className="aria-suggestion"
                onClick={() => { setInput(s.label); inputRef.current?.focus(); }}>
                <span>{s.icon}</span>
                <span>{s.label}</span>
              </button>
            ))}
          </div>
        )}

        {/* ── Input ── */}
        <div className="aria-input-area">
          <div className="aria-input-box">
            <textarea
              ref={inputRef}
              className="aria-textarea"
              placeholder="Ask about your portfolio, any stock, market trends…"
              value={input}
              onChange={handleInput}
              onKeyDown={e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); } }}
              rows={1}
              disabled={isStreaming}
            />
            <div className="aria-input-actions">
              {isStreaming ? (
                <button className="aria-stop-btn" onClick={stopStreaming}>
                  <span style={{ width: 8, height: 8, background: '#f05070', borderRadius: 1, display: 'inline-block' }} />
                  Stop
                </button>
              ) : (
                <button
                  className={`aria-send-btn${input.trim() ? ' active' : ''}`}
                  onClick={send}
                  disabled={!input.trim()}
                >↑</button>
              )}
            </div>
          </div>
          <div className="aria-input-hint">Enter to send · Shift+Enter for new line</div>
        </div>
      </div>

      {/* ── All scoped styles ── */}
      <style>{`
        /* Panel shell */
        .aria-panel {
          display: flex; flex-direction: column;
          width: 370px; min-width: 370px;
          background: #0c0f1a;
          border-left: 1px solid rgba(168,181,204,0.08);
          overflow: hidden;
          flex-shrink: 0;
          max-width: 0; min-width: 0;
          transition: max-width 0.3s cubic-bezier(0.4,0,0.2,1),
                      min-width 0.3s cubic-bezier(0.4,0,0.2,1);
        }
        .aria-panel.open { max-width: 370px; min-width: 370px; }
        .aria-panel.fullscreen {
          position: fixed !important; inset: 0 !important;
          width: 100% !important; max-width: 100% !important;
          min-width: 100% !important; z-index: 300 !important;
          border: none !important;
        }
        @media (max-width: 1000px) {
          .aria-panel {
            position: fixed; right: 0; top: 0; bottom: 0;
            max-width: 0 !important; min-width: 0 !important;
            z-index: 200;
            box-shadow: none;
          }
          .aria-panel.open {
            max-width: 380px !important; min-width: 320px !important;
            box-shadow: -12px 0 40px rgba(0,0,0,0.6);
          }
        }
        @media (max-width: 480px) {
          .aria-panel.open { max-width: 100% !important; min-width: 100% !important; }
        }

        /* Header */
        .aria-header {
          display: flex; align-items: center; justify-content: space-between;
          padding: 13px 15px; flex-shrink: 0;
          background: linear-gradient(135deg, #0f1220, #0c0f1a);
          border-bottom: 1px solid rgba(168,181,204,0.08);
          gap: 8px;
        }
        .aria-header-left { display: flex; align-items: center; gap: 10px; min-width: 0; }
        .aria-header-avatar {
          width: 34px; height: 34px; border-radius: 9px;
          background: linear-gradient(135deg, rgba(126,184,247,0.15), rgba(126,184,247,0.05));
          border: 1px solid rgba(126,184,247,0.25);
          display: flex; align-items: center; justify-content: center;
          font-size: 15px; color: #7eb8f7; flex-shrink: 0;
        }
        .aria-header-title {
          display: flex; align-items: center; gap: 6px;
          font-family: 'Playfair Display', serif; font-size: 15px;
          font-weight: 700; color: #e2eaf5;
        }
        .aria-badge {
          font-size: 9px; padding: 2px 6px; border-radius: 10px;
          background: rgba(126,184,247,0.12); border: 1px solid rgba(126,184,247,0.22);
          color: #7eb8f7; font-family: 'JetBrains Mono', monospace; font-weight: 700;
        }
        .aria-live {
          width: 7px; height: 7px; border-radius: 50%; background: #58e8a2;
          animation: ariaPulse 1s ease-in-out infinite; display: inline-block;
        }
        @keyframes ariaPulse {
          0%,100% { opacity: 1; box-shadow: 0 0 0 0 rgba(88,232,162,0.5); }
          50%      { opacity: 0.8; box-shadow: 0 0 0 5px rgba(88,232,162,0); }
        }
        .aria-header-sub {
          font-size: 10px; color: #4a5268;
          font-family: 'JetBrains Mono', monospace; margin-top: 1px;
        }
        .aria-header-btns { display: flex; gap: 5px; flex-shrink: 0; }
        .aria-icon-btn {
          width: 28px; height: 28px; border-radius: 6px;
          background: rgba(168,181,204,0.06); border: 1px solid rgba(168,181,204,0.1);
          color: #7a879e; cursor: pointer; font-size: 13px;
          display: flex; align-items: center; justify-content: center;
          transition: all 0.15s; padding: 0;
        }
        .aria-icon-btn:hover { color: #e2eaf5; background: rgba(168,181,204,0.12); }

        /* Messages scroll area */
        .aria-msgs-scroll {
          flex: 1; overflow-y: auto; overflow-x: hidden;
          padding: 14px 14px 4px;
          display: flex; flex-direction: column; gap: 14px;
          min-height: 0;
        }
        .aria-msgs-scroll::-webkit-scrollbar { width: 3px; }
        .aria-msgs-scroll::-webkit-scrollbar-thumb { background: rgba(168,181,204,0.1); border-radius: 2px; }

        /* Message rows */
        .aria-msg { display: flex; gap: 9px; align-items: flex-start; animation: ariaMsgIn 0.18s ease both; }
        @keyframes ariaMsgIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: none; } }
        .aria-msg-user { flex-direction: row-reverse; }
        .aria-avatar {
          width: 26px; height: 26px; border-radius: 7px; flex-shrink: 0; margin-top: 1px;
          background: rgba(126,184,247,0.1); border: 1px solid rgba(126,184,247,0.2);
          display: flex; align-items: center; justify-content: center;
          font-size: 12px; color: #7eb8f7;
        }

        /* Bubbles */
        .aria-bubble { max-width: 90%; min-width: 0; word-break: break-word; }
        .aria-bubble-user {
          background: rgba(168,181,204,0.08); border: 1px solid rgba(168,181,204,0.12);
          border-radius: 12px 3px 12px 12px;
          padding: 9px 13px; font-size: 13px; color: #d8e2f0;
          line-height: 1.6; font-family: 'Outfit', sans-serif;
        }
        .aria-bubble-ai {
          background: rgba(126,184,247,0.04); border: 1px solid rgba(126,184,247,0.1);
          border-radius: 3px 12px 12px 12px;
          padding: 11px 14px;
        }

        /* Streaming cursor */
        .aria-cursor {
          display: inline-block; width: 8px; height: 14px;
          background: #7eb8f7; border-radius: 2px; margin-left: 2px;
          animation: ariaBlink 0.65s step-end infinite; vertical-align: text-bottom;
        }
        @keyframes ariaBlink { 0%,100%{opacity:1} 50%{opacity:0} }

        /* Suggestions */
        .aria-suggestions {
          padding: 0 14px 10px; flex-shrink: 0;
          border-top: 1px solid rgba(168,181,204,0.06);
        }
        .aria-suggestions-label {
          font-size: 9px; text-transform: uppercase; letter-spacing: 0.14em;
          color: #4a5268; font-family: 'JetBrains Mono', monospace;
          margin: 9px 0 7px;
        }
        .aria-suggestion {
          display: flex; align-items: center; gap: 8px; width: 100%;
          padding: 7px 10px; margin-bottom: 4px;
          background: rgba(168,181,204,0.04); border: 1px solid rgba(168,181,204,0.08);
          border-radius: 7px; color: #a8b5cc; font-size: 12px;
          font-family: 'Outfit', sans-serif; cursor: pointer; text-align: left;
          transition: all 0.13s;
        }
        .aria-suggestion:hover {
          background: rgba(126,184,247,0.07); border-color: rgba(126,184,247,0.2);
          color: #c8d4e8; transform: translateX(2px);
        }

        /* Input area */
        .aria-input-area {
          padding: 10px 12px 13px; flex-shrink: 0;
          border-top: 1px solid rgba(168,181,204,0.08);
          background: rgba(6,8,16,0.4);
        }
        .aria-input-box {
          display: flex; align-items: flex-end; gap: 7px;
          background: #111520; border: 1px solid rgba(168,181,204,0.12);
          border-radius: 10px; padding: 7px 7px 7px 13px;
          transition: border-color 0.2s;
        }
        .aria-input-box:focus-within {
          border-color: rgba(126,184,247,0.35);
          box-shadow: 0 0 0 3px rgba(126,184,247,0.05);
        }
        .aria-textarea {
          flex: 1; background: none; border: none; outline: none;
          color: #e2eaf5; font-family: 'Outfit', sans-serif; font-size: 13px;
          line-height: 1.55; resize: none; min-height: 22px; max-height: 120px;
          overflow-y: auto; padding: 0;
        }
        .aria-textarea::placeholder { color: #4a5268; }
        .aria-textarea:disabled { opacity: 0.5; }
        .aria-textarea::-webkit-scrollbar { width: 2px; }
        .aria-input-actions { display: flex; align-items: flex-end; flex-shrink: 0; }
        .aria-send-btn {
          width: 32px; height: 32px; border-radius: 7px; border: none;
          background: rgba(168,181,204,0.09); color: #4a5268;
          font-size: 16px; cursor: default; transition: all 0.15s;
          display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .aria-send-btn.active {
          background: linear-gradient(135deg, #7eb8f7, #58e8a2);
          color: #060810; cursor: pointer;
          box-shadow: 0 2px 10px rgba(126,184,247,0.25);
        }
        .aria-send-btn.active:hover { opacity: 0.88; transform: scale(1.04); }
        .aria-stop-btn {
          display: flex; align-items: center; gap: 5px; height: 32px;
          padding: 0 10px; border-radius: 7px;
          background: rgba(240,80,112,0.08); border: 1px solid rgba(240,80,112,0.25);
          color: #f05070; font-size: 11px; font-family: 'JetBrains Mono', monospace;
          cursor: pointer; transition: all 0.15s; flex-shrink: 0;
        }
        .aria-stop-btn:hover { background: rgba(240,80,112,0.15); }
        .aria-input-hint {
          font-size: 10px; color: #4a5268; font-family: 'JetBrains Mono', monospace;
          text-align: center; margin-top: 6px;
        }
      `}</style>
    </>
  );
}
ENDFILE_SRC_COMPONENTS_CHATPANEL_JS

cat > src/components/LearnTab.js << 'ENDFILE_SRC_COMPONENTS_LEARNTAB_JS'
import React, { useState, useEffect, useRef, useCallback } from 'react';

// ── Curriculum data ────────────────────────────────────────────────────────
const CURRICULUM = [
  {
    id: 'fundamentals',
    icon: '🏛️',
    title: 'Market Fundamentals',
    color: '#7eb8f7',
    topics: [
      { id: 'what-is-stock',      title: 'What is a Stock?',              level: 'Beginner',      est: '5 min' },
      { id: 'how-market-works',   title: 'How Stock Markets Work',        level: 'Beginner',      est: '7 min' },
      { id: 'bulls-bears',        title: 'Bull vs Bear Markets',          level: 'Beginner',      est: '5 min' },
      { id: 'market-cap',         title: 'Market Capitalization',         level: 'Beginner',      est: '4 min' },
      { id: 'indices',            title: 'Stock Indices (S&P, NASDAQ…)',  level: 'Beginner',      est: '6 min' },
    ],
  },
  {
    id: 'analysis',
    icon: '📊',
    title: 'Fundamental Analysis',
    color: '#58e8a2',
    topics: [
      { id: 'pe-ratio',           title: 'P/E Ratio Explained',           level: 'Intermediate',  est: '8 min' },
      { id: 'eps',                title: 'Earnings Per Share (EPS)',       level: 'Intermediate',  est: '6 min' },
      { id: 'revenue-profit',     title: 'Revenue vs Profit',             level: 'Intermediate',  est: '7 min' },
      { id: 'balance-sheet',      title: 'Reading a Balance Sheet',       level: 'Intermediate',  est: '10 min' },
      { id: 'dcf',                title: 'Discounted Cash Flow (DCF)',     level: 'Advanced',      est: '12 min' },
    ],
  },
  {
    id: 'technical',
    icon: '📈',
    title: 'Technical Analysis',
    color: '#f0c060',
    topics: [
      { id: 'candlesticks',       title: 'Candlestick Charts',            level: 'Intermediate',  est: '8 min' },
      { id: 'support-resistance', title: 'Support & Resistance Levels',   level: 'Intermediate',  est: '7 min' },
      { id: 'moving-averages',    title: 'Moving Averages (MA, EMA)',      level: 'Intermediate',  est: '9 min' },
      { id: 'rsi',                title: 'RSI & Momentum Indicators',     level: 'Advanced',      est: '10 min' },
      { id: 'macd',               title: 'MACD Explained',                level: 'Advanced',      est: '10 min' },
    ],
  },
  {
    id: 'strategy',
    icon: '🎯',
    title: 'Investment Strategies',
    color: '#c084fc',
    topics: [
      { id: 'value-investing',    title: 'Value Investing (Buffett Style)', level: 'Intermediate', est: '10 min' },
      { id: 'growth-investing',   title: 'Growth Investing',               level: 'Intermediate', est: '8 min' },
      { id: 'dividend-investing', title: 'Dividend Investing',             level: 'Beginner',     est: '7 min' },
      { id: 'index-funds',        title: 'Index Funds & ETFs',             level: 'Beginner',     est: '8 min' },
      { id: 'dollar-cost-avg',    title: 'Dollar-Cost Averaging (DCA)',    level: 'Beginner',     est: '5 min' },
    ],
  },
  {
    id: 'risk',
    icon: '🛡️',
    title: 'Risk Management',
    color: '#f05070',
    topics: [
      { id: 'diversification',    title: 'Diversification Explained',     level: 'Beginner',      est: '6 min' },
      { id: 'position-sizing',    title: 'Position Sizing',               level: 'Intermediate',  est: '8 min' },
      { id: 'stop-loss',          title: 'Stop-Loss Orders',              level: 'Intermediate',  est: '7 min' },
      { id: 'portfolio-rebalance',title: 'Portfolio Rebalancing',         level: 'Intermediate',  est: '9 min' },
      { id: 'hedging',            title: 'Hedging Strategies',            level: 'Advanced',      est: '12 min' },
    ],
  },
  {
    id: 'advanced',
    icon: '⚡',
    title: 'Advanced Concepts',
    color: '#ff9f40',
    topics: [
      { id: 'options-basics',     title: 'Options: Calls & Puts',         level: 'Advanced',      est: '15 min' },
      { id: 'short-selling',      title: 'Short Selling',                 level: 'Advanced',      est: '10 min' },
      { id: 'macro-economics',    title: 'Macro & Interest Rates',        level: 'Advanced',      est: '12 min' },
      { id: 'sector-rotation',    title: 'Sector Rotation Strategy',      level: 'Advanced',      est: '10 min' },
      { id: 'behavioral-finance', title: 'Behavioral Finance & Biases',   level: 'Advanced',      est: '11 min' },
    ],
  },
];

const LEVEL_COLORS = {
  Beginner:     { bg: 'rgba(88,232,162,0.1)',  border: 'rgba(88,232,162,0.25)',  text: '#58e8a2' },
  Intermediate: { bg: 'rgba(126,184,247,0.1)', border: 'rgba(126,184,247,0.25)', text: '#7eb8f7' },
  Advanced:     { bg: 'rgba(240,80,112,0.1)',  border: 'rgba(240,80,112,0.25)',  text: '#f05070' },
};

const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';

function buildLessonPrompt(topicTitle) {
  return `You are ARIA, an expert investment educator. Teach the topic: "${topicTitle}"

Write a comprehensive, engaging lesson following this EXACT structure:

## ${topicTitle}

### 🎯 What You'll Learn
[2-3 bullet points of key takeaways]

### 📖 The Core Concept
[2-3 paragraphs explaining the concept clearly. Use analogies and real-world examples. Write like you're explaining to a smart friend, not a textbook.]

### 🔢 The Numbers (if applicable)
[Show any formulas, calculations, or data with examples. Use a table if comparing things.]

### 💡 Real-World Example
[Give a specific, concrete example using real companies (Apple, Tesla, Warren Buffett, etc.) to make it tangible]

### ✅ Key Takeaways
[3-5 numbered bullet points summarizing the most important points]

### 🚀 How to Apply This
[2-3 practical action items the investor can take with this knowledge]

---

Rules:
- Use **bold** for important terms on first use
- Use tables for comparisons
- Keep explanations clear and jargon-free, define any technical terms
- Include real numbers and examples (actual stock prices, actual companies)
- Be encouraging and practical — this should feel like a mentor explaining, not a textbook`;
}

function buildQuizPrompt(topicTitle) {
  return `Create a 5-question multiple choice quiz about "${topicTitle}" for an investor.

Respond ONLY with valid JSON in this exact format, no other text:
{
  "questions": [
    {
      "q": "Question text here?",
      "options": ["A) ...", "B) ...", "C) ...", "D) ..."],
      "answer": 0,
      "explanation": "Brief explanation of why this is correct"
    }
  ]
}

Rules:
- answer is the 0-based index of the correct option
- Make questions practical and scenario-based, not just definitions
- Include one tricky question
- Explanations should teach, not just confirm`;
}

// ── Streaming hook for lessons ─────────────────────────────────────────────
function useLessonStream() {
  const [content,     setContent]     = useState('');
  const [isStreaming, setIsStreaming] = useState(false);
  const [error,       setError]       = useState(null);
  const abortRef   = useRef(null);
  const bufferRef  = useRef('');
  const timerRef   = useRef(null);

  const flush = useCallback((final = false) => {
    if (final) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
      setContent(bufferRef.current);
      return;
    }
    if (timerRef.current) return;
    timerRef.current = setTimeout(() => {
      timerRef.current = null;
      setContent(bufferRef.current);
    }, 60);
  }, []);

  const streamLesson = useCallback(async (topicTitle) => {
    const apiKey = process.env.REACT_APP_GROQ_API_KEY;
    if (!apiKey || apiKey === 'your_groq_api_key_here') {
      setError('Add your Groq API key to .env to unlock AI-powered lessons.');
      return;
    }
    setContent('');
    setError(null);
    setIsStreaming(true);
    bufferRef.current = '';
    abortRef.current = new AbortController();

    try {
      const res = await fetch(GROQ_API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${apiKey}` },
        signal: abortRef.current.signal,
        body: JSON.stringify({
          model: 'llama-3.3-70b-versatile',
          stream: true,
          max_tokens: 2000,
          temperature: 0.65,
          messages: [{ role: 'user', content: buildLessonPrompt(topicTitle) }],
        }),
      });
      if (!res.ok) throw new Error(`API error ${res.status}`);

      const reader  = res.body.getReader();
      const decoder = new TextDecoder();

      loop: while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        for (const line of decoder.decode(value, { stream: true }).split('\n')) {
          if (!line.startsWith('data: ')) continue;
          const raw = line.slice(6).trim();
          if (raw === '[DONE]') break loop;
          try {
            const delta = JSON.parse(raw).choices?.[0]?.delta?.content;
            if (delta) { bufferRef.current += delta; flush(false); }
          } catch (_) {}
        }
      }
      flush(true);
    } catch (e) {
      if (e.name !== 'AbortError') setError(e.message);
      else setContent(bufferRef.current);
    } finally {
      setIsStreaming(false);
    }
  }, [flush]);

  const stop = useCallback(() => abortRef.current?.abort(), []);
  const reset = useCallback(() => {
    clearTimeout(timerRef.current);
    abortRef.current?.abort();
    bufferRef.current = '';
    setContent('');
    setError(null);
    setIsStreaming(false);
  }, []);

  return { content, isStreaming, error, streamLesson, stop, reset };
}

// ── Inline markdown renderer (reuses existing logic pattern) ──────────────
function InlineText({ text }) {
  const parts = [];
  let rem = text, k = 0;
  while (rem.length > 0) {
    const bm = rem.match(/\*\*(.+?)\*\*/);
    const cm = rem.match(/`([^`]+)`/);
    const ms = [bm && { t: 'b', i: bm.index, m: bm }, cm && { t: 'c', i: cm.index, m: cm }]
      .filter(Boolean).sort((a, b) => a.i - b.i);
    if (!ms.length) { parts.push(<span key={k++}>{rem}</span>); break; }
    const f = ms[0];
    if (f.i > 0) parts.push(<span key={k++}>{rem.slice(0, f.i)}</span>);
    if (f.t === 'b') parts.push(<strong key={k++} style={{ color: '#e2eaf5', fontWeight: 700 }}>{f.m[1]}</strong>);
    else parts.push(<code key={k++} style={{ background: 'rgba(11,14,24,0.8)', border: '1px solid rgba(168,181,204,0.15)', borderRadius: 4, padding: '1px 5px', fontFamily: 'JetBrains Mono, monospace', fontSize: '0.87em', color: '#7eb8f7' }}>{f.m[1]}</code>);
    rem = rem.slice(f.i + f.m[0].length);
  }
  return <>{parts}</>;
}

function LessonContent({ text, streaming }) {
  const lines = text.split('\n');
  const blocks = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (line.startsWith('```')) {
      const codeLines = []; i++;
      while (i < lines.length && !lines[i].startsWith('```')) { codeLines.push(lines[i]); i++; }
      blocks.push({ type: 'code', content: codeLines.join('\n') }); i++; continue;
    }
    if (line.startsWith('|') && lines[i+1]?.match(/^\|[-\s|:]+\|/)) {
      const rows = [];
      while (i < lines.length && lines[i].startsWith('|')) { rows.push(lines[i]); i++; }
      blocks.push({ type: 'table', rows }); continue;
    }
    if (line.startsWith('## '))  { blocks.push({ type: 'h2', text: line.slice(3) }); i++; continue; }
    if (line.startsWith('### ')) { blocks.push({ type: 'h3', text: line.slice(4) }); i++; continue; }
    if (line.match(/^---+$/))    { blocks.push({ type: 'hr' }); i++; continue; }
    if (line.startsWith('> '))   {
      const qs = [];
      while (i < lines.length && lines[i].startsWith('> ')) { qs.push(lines[i].slice(2)); i++; }
      blocks.push({ type: 'quote', lines: qs }); continue;
    }
    if (line.match(/^\d+\.\s/)) {
      const items = [];
      while (i < lines.length && lines[i].match(/^\d+\.\s/)) { items.push(lines[i].replace(/^\d+\.\s/, '')); i++; }
      blocks.push({ type: 'ol', items }); continue;
    }
    if (line.match(/^[-*]\s/)) {
      const items = [];
      while (i < lines.length && lines[i].match(/^[-*]\s/)) { items.push(lines[i].replace(/^[-*]\s/, '')); i++; }
      blocks.push({ type: 'ul', items }); continue;
    }
    if (line.trim() === '') { blocks.push({ type: 'br' }); i++; continue; }
    const ps = [];
    while (i < lines.length && lines[i].trim() !== '' && !lines[i].match(/^[#>|`\-*]/) && !lines[i].match(/^\d+\./) && !lines[i].match(/^---/)) { ps.push(lines[i]); i++; }
    if (ps.length) blocks.push({ type: 'p', text: ps.join(' ') });
  }

  return (
    <div style={{ lineHeight: 1.75, fontSize: 14, color: '#c8d4e8' }}>
      {blocks.map((b, bi) => {
        switch (b.type) {
          case 'h2': return (
            <div key={bi} style={{ fontSize: 17, fontWeight: 700, color: '#e2eaf5', fontFamily: 'Outfit, sans-serif', margin: bi > 0 ? '20px 0 10px' : '0 0 10px', display: 'flex', alignItems: 'center', gap: 9 }}>
              <span style={{ width: 3, height: 18, background: '#7eb8f7', borderRadius: 2, flexShrink: 0 }} />
              <InlineText text={b.text} />
            </div>
          );
          case 'h3': return (
            <div key={bi} style={{ fontSize: 14, fontWeight: 700, color: '#c8d4e8', margin: '14px 0 6px' }}>
              <InlineText text={b.text} />
            </div>
          );
          case 'hr': return <hr key={bi} style={{ border: 'none', borderTop: '1px solid rgba(168,181,204,0.1)', margin: '16px 0' }} />;
          case 'quote': return (
            <div key={bi} style={{ borderLeft: '3px solid #7eb8f7', padding: '8px 14px', margin: '10px 0', background: 'rgba(126,184,247,0.05)', borderRadius: '0 8px 8px 0' }}>
              {b.lines.map((l, li) => <div key={li} style={{ fontStyle: 'italic', color: '#a8b5cc', fontSize: 13 }}><InlineText text={l} /></div>)}
            </div>
          );
          case 'ul': return (
            <ul key={bi} style={{ listStyle: 'none', padding: 0, margin: '8px 0' }}>
              {b.items.map((item, ii) => (
                <li key={ii} style={{ display: 'flex', gap: 9, marginBottom: 6, alignItems: 'flex-start' }}>
                  <span style={{ color: '#7eb8f7', fontSize: 9, marginTop: 5, flexShrink: 0 }}>◆</span>
                  <span><InlineText text={item} /></span>
                </li>
              ))}
            </ul>
          );
          case 'ol': return (
            <ol key={bi} style={{ listStyle: 'none', padding: 0, margin: '8px 0' }}>
              {b.items.map((item, ii) => (
                <li key={ii} style={{ display: 'flex', gap: 10, marginBottom: 7, alignItems: 'flex-start' }}>
                  <span style={{ background: '#7eb8f7', color: '#060810', borderRadius: 5, width: 20, height: 20, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 10, fontWeight: 700, flexShrink: 0, marginTop: 2, fontFamily: 'JetBrains Mono, monospace' }}>{ii + 1}</span>
                  <span><InlineText text={item} /></span>
                </li>
              ))}
            </ol>
          );
          case 'table': {
            const headers = b.rows[0].split('|').map(c => c.trim()).filter(Boolean);
            const dataRows = b.rows.slice(2).map(r => r.split('|').map(c => c.trim()).filter(Boolean)).filter(r => r.length);
            return (
              <div key={bi} style={{ overflowX: 'auto', margin: '12px 0' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12, fontFamily: 'JetBrains Mono, monospace' }}>
                  <thead>
                    <tr>{headers.map((h, i) => <th key={i} style={{ padding: '7px 12px', textAlign: 'left', color: '#7eb8f7', background: 'rgba(126,184,247,0.07)', borderBottom: '1px solid rgba(126,184,247,0.2)', fontWeight: 700, fontSize: 11, textTransform: 'uppercase', letterSpacing: '0.05em', whiteSpace: 'nowrap' }}><InlineText text={h} /></th>)}</tr>
                  </thead>
                  <tbody>
                    {dataRows.map((row, ri) => (
                      <tr key={ri} style={{ borderBottom: '1px solid rgba(168,181,204,0.06)' }}>
                        {row.map((cell, ci) => <td key={ci} style={{ padding: '7px 12px', color: '#c8d4e8', background: ri % 2 ? 'rgba(168,181,204,0.02)' : 'transparent' }}><InlineText text={cell} /></td>)}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            );
          }
          case 'code': return (
            <pre key={bi} style={{ background: 'rgba(6,8,16,0.8)', border: '1px solid rgba(168,181,204,0.1)', borderRadius: 8, padding: '12px 16px', overflow: 'auto', margin: '10px 0', fontSize: 12, fontFamily: 'JetBrains Mono, monospace', color: '#c8d4e8', lineHeight: 1.6 }}>
              <code>{b.content}</code>
            </pre>
          );
          case 'p': return <p key={bi} style={{ margin: '6px 0' }}><InlineText text={b.text} /></p>;
          case 'br': return <div key={bi} style={{ height: 4 }} />;
          default: return null;
        }
      })}
      {streaming && (
        <span style={{ display: 'inline-block', width: 8, height: 15, background: '#7eb8f7', borderRadius: 2, marginLeft: 2, animation: 'cursorBlink 0.7s step-end infinite', verticalAlign: 'text-bottom' }} />
      )}
    </div>
  );
}

// ── Quiz component ─────────────────────────────────────────────────────────
function Quiz({ topicTitle, onClose }) {
  const [questions, setQuestions] = useState(null);
  const [loading,   setLoading]   = useState(true);
  const [answers,   setAnswers]   = useState({});
  const [submitted, setSubmitted] = useState(false);
  const [error,     setError]     = useState(null);

  useEffect(() => {
    const apiKey = process.env.REACT_APP_GROQ_API_KEY;
    if (!apiKey || apiKey === 'your_groq_api_key_here') {
      setError('Groq API key required'); setLoading(false); return;
    }
    fetch(GROQ_API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${apiKey}` },
      body: JSON.stringify({
        model: 'llama-3.3-70b-versatile',
        max_tokens: 1500,
        temperature: 0.5,
        messages: [{ role: 'user', content: buildQuizPrompt(topicTitle) }],
      }),
    })
    .then(r => r.json())
    .then(d => {
      let text = d.choices?.[0]?.message?.content || '';
      text = text.replace(/```json|```/g, '').trim();
      const parsed = JSON.parse(text);
      setQuestions(parsed.questions);
      setLoading(false);
    })
    .catch(e => { setError(e.message); setLoading(false); });
  }, [topicTitle]);

  const score = submitted
    ? questions?.filter((q, i) => answers[i] === q.answer).length
    : 0;

  if (loading) return (
    <div style={{ padding: '40px', textAlign: 'center', color: '#7a879e' }}>
      <div style={{ width: 28, height: 28, border: '2px solid rgba(126,184,247,0.3)', borderTop: '2px solid #7eb8f7', borderRadius: '50%', animation: 'spin 0.8s linear infinite', margin: '0 auto 12px' }} />
      Generating quiz…
    </div>
  );
  if (error) return <div style={{ padding: 20, color: '#f05070', fontSize: 13 }}>⚠ {error}</div>;

  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 }}>
        <div>
          <div style={{ fontSize: 16, fontWeight: 700, color: '#e2eaf5', fontFamily: 'Outfit, sans-serif' }}>
            🎯 Quiz: {topicTitle}
          </div>
          <div style={{ fontSize: 12, color: '#7a879e', fontFamily: 'JetBrains Mono, monospace', marginTop: 2 }}>
            {questions?.length} questions
          </div>
        </div>
        {submitted && (
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: 22, fontWeight: 700, color: score >= 4 ? '#58e8a2' : score >= 3 ? '#f0c060' : '#f05070', fontFamily: 'JetBrains Mono, monospace' }}>
              {score}/{questions?.length}
            </div>
            <div style={{ fontSize: 11, color: '#7a879e', fontFamily: 'JetBrains Mono, monospace' }}>
              {score >= 4 ? 'Excellent! 🎉' : score >= 3 ? 'Good work 👍' : 'Keep learning 📚'}
            </div>
          </div>
        )}
      </div>

      {questions?.map((q, qi) => {
        const chosen    = answers[qi];
        const isCorrect = submitted && chosen === q.answer;
        const isWrong   = submitted && chosen !== undefined && chosen !== q.answer;
        return (
          <div key={qi} style={{ marginBottom: 20, padding: 16, background: 'rgba(11,14,24,0.5)', borderRadius: 10, border: `1px solid ${submitted ? (isCorrect ? 'rgba(88,232,162,0.2)' : isWrong ? 'rgba(240,80,112,0.2)' : 'rgba(168,181,204,0.07)') : 'rgba(168,181,204,0.07)'}` }}>
            <div style={{ fontSize: 13, color: '#e2eaf5', fontWeight: 600, marginBottom: 10, lineHeight: 1.5 }}>
              <span style={{ color: '#7eb8f7', fontFamily: 'JetBrains Mono, monospace', marginRight: 8 }}>Q{qi + 1}.</span>
              {q.q}
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              {q.options.map((opt, oi) => {
                const isSelected = chosen === oi;
                const isAnswer   = q.answer === oi;
                let bg = 'rgba(168,181,204,0.04)';
                let border = 'rgba(168,181,204,0.1)';
                let color = '#a8b5cc';
                if (!submitted && isSelected) { bg = 'rgba(126,184,247,0.1)'; border = 'rgba(126,184,247,0.35)'; color = '#7eb8f7'; }
                if (submitted && isAnswer)    { bg = 'rgba(88,232,162,0.1)';  border = 'rgba(88,232,162,0.35)';  color = '#58e8a2'; }
                if (submitted && isSelected && !isAnswer) { bg = 'rgba(240,80,112,0.1)'; border = 'rgba(240,80,112,0.3)'; color = '#f05070'; }
                return (
                  <button key={oi} disabled={submitted}
                    onClick={() => !submitted && setAnswers(a => ({ ...a, [qi]: oi }))}
                    style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '9px 13px', background: bg, border: `1px solid ${border}`, borderRadius: 8, color, fontSize: 13, fontFamily: 'Outfit, sans-serif', cursor: submitted ? 'default' : 'pointer', textAlign: 'left', transition: 'all 0.12s', width: '100%' }}>
                    <span style={{ width: 20, height: 20, borderRadius: 4, border: `1.5px solid ${border}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 11, fontFamily: 'JetBrains Mono, monospace', flexShrink: 0, background: isSelected || (submitted && isAnswer) ? bg : 'transparent' }}>
                      {submitted && isAnswer ? '✓' : submitted && isSelected && !isAnswer ? '✗' : String.fromCharCode(65 + oi)}
                    </span>
                    {opt.replace(/^[A-D]\)\s*/, '')}
                  </button>
                );
              })}
            </div>
            {submitted && (
              <div style={{ marginTop: 10, padding: '8px 12px', background: 'rgba(126,184,247,0.05)', border: '1px solid rgba(126,184,247,0.12)', borderRadius: 7, fontSize: 12, color: '#a8b5cc', lineHeight: 1.6 }}>
                💡 {q.explanation}
              </div>
            )}
          </div>
        );
      })}

      <div style={{ display: 'flex', gap: 10, marginTop: 8 }}>
        {!submitted ? (
          <button
            onClick={() => setSubmitted(true)}
            disabled={Object.keys(answers).length < (questions?.length || 5)}
            style={{ flex: 1, padding: '11px', background: Object.keys(answers).length === questions?.length ? 'linear-gradient(135deg, #7eb8f7, #58e8a2)' : 'rgba(168,181,204,0.08)', border: 'none', borderRadius: 9, color: Object.keys(answers).length === questions?.length ? '#060810' : '#4a5268', fontSize: 13, fontWeight: 700, fontFamily: 'Outfit, sans-serif', cursor: Object.keys(answers).length === questions?.length ? 'pointer' : 'not-allowed', transition: 'all 0.15s' }}>
            Submit Answers ({Object.keys(answers).length}/{questions?.length} answered)
          </button>
        ) : (
          <>
            <button onClick={() => { setAnswers({}); setSubmitted(false); }}
              style={{ flex: 1, padding: '11px', background: 'rgba(168,181,204,0.07)', border: '1px solid rgba(168,181,204,0.14)', borderRadius: 9, color: '#a8b5cc', fontSize: 13, fontFamily: 'Outfit, sans-serif', cursor: 'pointer' }}>
              Try Again
            </button>
            <button onClick={onClose}
              style={{ flex: 1, padding: '11px', background: 'linear-gradient(135deg, #7eb8f7, #58e8a2)', border: 'none', borderRadius: 9, color: '#060810', fontSize: 13, fontWeight: 700, fontFamily: 'Outfit, sans-serif', cursor: 'pointer' }}>
              Back to Lessons
            </button>
          </>
        )}
      </div>
    </div>
  );
}

// ── Main LearnTab ──────────────────────────────────────────────────────────
export default function LearnTab() {
  const [activeCat,   setActiveCat]   = useState(null);
  const [activeTopic, setActiveTopic] = useState(null);
  const [view,        setView]        = useState('home'); // 'home' | 'lesson' | 'quiz'
  const [completed,   setCompleted]   = useState(() => {
    try { return JSON.parse(localStorage.getItem('aria_completed') || '[]'); } catch { return []; }
  });
  const [customTopic, setCustomTopic] = useState('');
  const lessonRef = useRef(null);

  const { content, isStreaming, error: lessonError, streamLesson, stop, reset } = useLessonStream();

  const startLesson = useCallback((cat, topic) => {
    reset();
    setActiveCat(cat);
    setActiveTopic(topic);
    setView('lesson');
    streamLesson(topic.title);
  }, [reset, streamLesson]);

  const startCustomLesson = useCallback(() => {
    if (!customTopic.trim()) return;
    const fakeTopic = { id: 'custom', title: customTopic.trim(), level: 'Custom', est: '~10 min' };
    const fakeCat   = { id: 'custom', color: '#7eb8f7' };
    reset();
    setActiveCat(fakeCat);
    setActiveTopic(fakeTopic);
    setView('lesson');
    streamLesson(customTopic.trim());
    setCustomTopic('');
  }, [customTopic, reset, streamLesson]);

  const markComplete = useCallback(() => {
    if (!activeTopic) return;
    const updated = [...new Set([...completed, activeTopic.id])];
    setCompleted(updated);
    try { localStorage.setItem('aria_completed', JSON.stringify(updated)); } catch {}
  }, [activeTopic, completed]);

  // Auto-scroll lesson as it streams
  useEffect(() => {
    if (isStreaming && lessonRef.current) {
      lessonRef.current.scrollTop = lessonRef.current.scrollHeight;
    }
  }, [content, isStreaming]);

  const totalTopics = CURRICULUM.reduce((s, c) => s + c.topics.length, 0);
  const progress    = Math.round((completed.length / totalTopics) * 100);

  // ── HOME VIEW ────────────────────────────────────────────────────────────
  if (view === 'home') return (
    <div style={{ padding: '20px 20px 32px', display: 'flex', flexDirection: 'column', gap: 20 }}>

      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: 12 }}>
        <div>
          <h2 style={{ fontFamily: 'Playfair Display, serif', fontSize: 22, fontWeight: 700, color: '#e2eaf5', margin: 0 }}>
            Investment Academy
          </h2>
          <p style={{ fontSize: 13, color: '#7a879e', fontFamily: 'Outfit, sans-serif', margin: '4px 0 0' }}>
            Master investing from first principles — powered by ARIA
          </p>
        </div>
        {/* Progress */}
        <div style={{ background: 'linear-gradient(145deg, #111520, #0b0e18)', border: '1px solid rgba(168,181,204,0.08)', borderRadius: 12, padding: '12px 18px', minWidth: 180, textAlign: 'center' }}>
          <div style={{ fontSize: 24, fontWeight: 700, color: '#7eb8f7', fontFamily: 'JetBrains Mono, monospace' }}>
            {progress}%
          </div>
          <div style={{ fontSize: 11, color: '#4a5268', fontFamily: 'JetBrains Mono, monospace', margin: '4px 0 8px' }}>
            {completed.length}/{totalTopics} lessons
          </div>
          <div style={{ height: 4, background: 'rgba(168,181,204,0.1)', borderRadius: 2, overflow: 'hidden' }}>
            <div style={{ height: '100%', width: `${progress}%`, background: 'linear-gradient(90deg, #7eb8f7, #58e8a2)', borderRadius: 2, transition: 'width 0.5s ease' }} />
          </div>
        </div>
      </div>

      {/* Ask ARIA anything */}
      <div style={{ background: 'linear-gradient(135deg, rgba(126,184,247,0.07), rgba(88,232,162,0.05))', border: '1px solid rgba(126,184,247,0.18)', borderRadius: 14, padding: '16px 18px' }}>
        <div style={{ fontSize: 13, fontWeight: 600, color: '#7eb8f7', marginBottom: 10, display: 'flex', alignItems: 'center', gap: 7 }}>
          <span>◈</span> Ask ARIA to teach you anything
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <input
            value={customTopic}
            onChange={e => setCustomTopic(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && startCustomLesson()}
            placeholder='e.g. "How do ETFs work?" or "Explain the yield curve"'
            style={{ flex: 1, background: 'rgba(6,8,16,0.6)', border: '1px solid rgba(168,181,204,0.12)', borderRadius: 8, padding: '10px 14px', color: '#e2eaf5', fontFamily: 'Outfit, sans-serif', fontSize: 13, outline: 'none' }}
          />
          <button onClick={startCustomLesson} disabled={!customTopic.trim()}
            style={{ padding: '10px 18px', background: customTopic.trim() ? 'linear-gradient(135deg, #7eb8f7, #58e8a2)' : 'rgba(168,181,204,0.08)', border: 'none', borderRadius: 8, color: customTopic.trim() ? '#060810' : '#4a5268', fontSize: 13, fontWeight: 700, fontFamily: 'Outfit, sans-serif', cursor: customTopic.trim() ? 'pointer' : 'not-allowed', whiteSpace: 'nowrap', transition: 'all 0.15s' }}>
            Teach Me →
          </button>
        </div>
        <div style={{ marginTop: 8, display: 'flex', gap: 6, flexWrap: 'wrap' }}>
          {['Warren Buffett investing philosophy', 'How options theta decay works', 'Inflation and stock prices', 'Reading an income statement'].map(s => (
            <button key={s} onClick={() => { setCustomTopic(s); }}
              style={{ fontSize: 11, padding: '3px 9px', background: 'rgba(168,181,204,0.05)', border: '1px solid rgba(168,181,204,0.1)', borderRadius: 20, color: '#7a879e', cursor: 'pointer', fontFamily: 'JetBrains Mono, monospace', transition: 'all 0.12s' }}
              onMouseOver={e => { e.currentTarget.style.color = '#7eb8f7'; e.currentTarget.style.borderColor = 'rgba(126,184,247,0.3)'; }}
              onMouseOut={e => { e.currentTarget.style.color = '#7a879e'; e.currentTarget.style.borderColor = 'rgba(168,181,204,0.1)'; }}>
              {s}
            </button>
          ))}
        </div>
      </div>

      {/* Curriculum grid */}
      {CURRICULUM.map(cat => (
        <div key={cat.id}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 9, marginBottom: 10 }}>
            <span style={{ fontSize: 18 }}>{cat.icon}</span>
            <span style={{ fontSize: 15, fontWeight: 700, color: '#e2eaf5', fontFamily: 'Outfit, sans-serif' }}>{cat.title}</span>
            <span style={{ fontSize: 11, color: '#4a5268', fontFamily: 'JetBrains Mono, monospace' }}>
              {cat.topics.filter(t => completed.includes(t.id)).length}/{cat.topics.length} done
            </span>
            <div style={{ flex: 1, height: 1, background: 'rgba(168,181,204,0.06)' }} />
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))', gap: 8 }}>
            {cat.topics.map(topic => {
              const done   = completed.includes(topic.id);
              const lc     = LEVEL_COLORS[topic.level] || LEVEL_COLORS.Beginner;
              return (
                <button key={topic.id} onClick={() => startLesson(cat, topic)}
                  style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '12px 14px', background: done ? 'rgba(88,232,162,0.04)' : 'linear-gradient(145deg, #111520, #0b0e18)', border: `1px solid ${done ? 'rgba(88,232,162,0.18)' : 'rgba(168,181,204,0.08)'}`, borderRadius: 10, cursor: 'pointer', textAlign: 'left', transition: 'all 0.15s', width: '100%' }}
                  onMouseOver={e => { e.currentTarget.style.borderColor = cat.color + '44'; e.currentTarget.style.background = `rgba(${cat.color}, 0.04)`; }}
                  onMouseOut={e => { e.currentTarget.style.borderColor = done ? 'rgba(88,232,162,0.18)' : 'rgba(168,181,204,0.08)'; e.currentTarget.style.background = done ? 'rgba(88,232,162,0.04)' : 'linear-gradient(145deg, #111520, #0b0e18)'; }}>
                  <div style={{ width: 32, height: 32, borderRadius: 8, background: `${cat.color}18`, border: `1px solid ${cat.color}33`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14, flexShrink: 0, color: done ? '#58e8a2' : cat.color }}>
                    {done ? '✓' : '▶'}
                  </div>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 13, fontWeight: 600, color: '#c8d4e8', fontFamily: 'Outfit, sans-serif', marginBottom: 3, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {topic.title}
                    </div>
                    <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
                      <span style={{ fontSize: 10, padding: '1px 7px', borderRadius: 10, background: lc.bg, border: `1px solid ${lc.border}`, color: lc.text, fontFamily: 'JetBrains Mono, monospace' }}>
                        {topic.level}
                      </span>
                      <span style={{ fontSize: 10, color: '#4a5268', fontFamily: 'JetBrains Mono, monospace' }}>
                        {topic.est}
                      </span>
                    </div>
                  </div>
                </button>
              );
            })}
          </div>
        </div>
      ))}
      <style>{`@keyframes spin { to { transform: rotate(360deg); } } @keyframes cursorBlink { 0%,100%{opacity:1} 50%{opacity:0} }`}</style>
    </div>
  );

  // ── QUIZ VIEW ────────────────────────────────────────────────────────────
  if (view === 'quiz') return (
    <div style={{ padding: '20px', maxWidth: 720, margin: '0 auto' }}>
      <Quiz topicTitle={activeTopic?.title} onClose={() => setView('lesson')} />
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );

  // ── LESSON VIEW ──────────────────────────────────────────────────────────
  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', overflow: 'hidden' }}>
      {/* Lesson topbar */}
      <div style={{ padding: '12px 20px', borderBottom: '1px solid rgba(168,181,204,0.08)', display: 'flex', alignItems: 'center', gap: 12, flexShrink: 0, background: '#060810', flexWrap: 'wrap' }}>
        <button onClick={() => { setView('home'); reset(); }}
          style={{ background: 'rgba(168,181,204,0.07)', border: '1px solid rgba(168,181,204,0.12)', color: '#a8b5cc', borderRadius: 7, padding: '5px 12px', fontSize: 12, fontFamily: 'JetBrains Mono, monospace', cursor: 'pointer', flexShrink: 0 }}>
          ← Back
        </button>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: '#e2eaf5', fontFamily: 'Outfit, sans-serif', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
            {activeTopic?.title}
          </div>
          {activeTopic?.level && (
            <div style={{ fontSize: 10, color: LEVEL_COLORS[activeTopic.level]?.text || '#7a879e', fontFamily: 'JetBrains Mono, monospace' }}>
              {activeTopic.level} · {activeTopic.est}
            </div>
          )}
        </div>
        <div style={{ display: 'flex', gap: 7, flexShrink: 0 }}>
          {isStreaming && (
            <button onClick={stop}
              style={{ padding: '5px 12px', background: 'rgba(240,80,112,0.08)', border: '1px solid rgba(240,80,112,0.25)', borderRadius: 7, color: '#f05070', fontSize: 12, fontFamily: 'JetBrains Mono, monospace', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 6 }}>
              <span style={{ width: 7, height: 7, background: '#f05070', borderRadius: 1 }} />
              Stop
            </button>
          )}
          {content && !isStreaming && (
            <>
              <button onClick={markComplete}
                disabled={completed.includes(activeTopic?.id)}
                style={{ padding: '5px 12px', background: completed.includes(activeTopic?.id) ? 'rgba(88,232,162,0.08)' : 'rgba(168,181,204,0.07)', border: `1px solid ${completed.includes(activeTopic?.id) ? 'rgba(88,232,162,0.25)' : 'rgba(168,181,204,0.12)'}`, borderRadius: 7, color: completed.includes(activeTopic?.id) ? '#58e8a2' : '#a8b5cc', fontSize: 12, fontFamily: 'JetBrains Mono, monospace', cursor: completed.includes(activeTopic?.id) ? 'default' : 'pointer' }}>
                {completed.includes(activeTopic?.id) ? '✓ Done' : '✓ Mark Done'}
              </button>
              <button onClick={() => setView('quiz')}
                style={{ padding: '5px 14px', background: 'linear-gradient(135deg, rgba(126,184,247,0.15), rgba(88,232,162,0.1))', border: '1px solid rgba(126,184,247,0.3)', borderRadius: 7, color: '#7eb8f7', fontSize: 12, fontFamily: 'JetBrains Mono, monospace', cursor: 'pointer', fontWeight: 600 }}>
                🎯 Take Quiz
              </button>
            </>
          )}
        </div>
      </div>

      {/* Lesson content */}
      <div ref={lessonRef} style={{ flex: 1, overflowY: 'auto', padding: '24px 24px 40px', maxWidth: 820, width: '100%', margin: '0 auto', boxSizing: 'border-box' }}>
        {lessonError ? (
          <div style={{ padding: 20, background: 'rgba(240,80,112,0.06)', border: '1px solid rgba(240,80,112,0.2)', borderRadius: 10, color: '#f05070', fontSize: 13, fontFamily: 'JetBrains Mono, monospace' }}>
            ⚠ {lessonError}
          </div>
        ) : !content ? (
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: 200, flexDirection: 'column', gap: 14, color: '#4a5268' }}>
            <div style={{ width: 30, height: 30, border: '2px solid rgba(126,184,247,0.3)', borderTop: '2px solid #7eb8f7', borderRadius: '50%', animation: 'spin 0.8s linear infinite' }} />
            <span style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 12 }}>ARIA is preparing your lesson…</span>
          </div>
        ) : (
          <LessonContent text={content} streaming={isStreaming} />
        )}
      </div>

      <style>{`@keyframes spin { to { transform: rotate(360deg); } } @keyframes cursorBlink { 0%,100%{opacity:1} 50%{opacity:0} }`}</style>
    </div>
  );
}
ENDFILE_SRC_COMPONENTS_LEARNTAB_JS

cat > src/pages/LandingPage.js << 'ENDFILE_SRC_PAGES_LANDINGPAGE_JS'
import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import TickerTape from '../components/TickerTape';
import styles from './LandingPage.module.css';

/* ── Intersection Observer hook ── */
function useInView(threshold = 0.12) {
  const ref = useRef(null);
  const [inView, setInView] = useState(false);
  useEffect(() => {
    const obs = new IntersectionObserver(([e]) => { if (e.isIntersecting) setInView(true); }, { threshold });
    if (ref.current) obs.observe(ref.current);
    return () => obs.disconnect();
  }, [threshold]);
  return [ref, inView];
}

/* ── Counter animation ── */
function AnimatedCounter({ target, prefix = '', suffix = '', decimals = 0 }) {
  const [val, setVal] = useState(0);
  const [ref, inView] = useInView(0.3);
  useEffect(() => {
    if (!inView) return;
    const start = Date.now(), duration = 1800;
    const tick = () => {
      const p = Math.min((Date.now() - start) / duration, 1);
      setVal(+(target * (1 - Math.pow(1 - p, 3))).toFixed(decimals));
      if (p < 1) requestAnimationFrame(tick);
    };
    requestAnimationFrame(tick);
  }, [inView, target, decimals]);
  return <span ref={ref}>{prefix}{val.toLocaleString('en', { minimumFractionDigits: decimals, maximumFractionDigits: decimals })}{suffix}</span>;
}

/* ── Navbar ── */
function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const navigate = useNavigate();
  useEffect(() => {
    const h = () => setScrolled(window.scrollY > 40);
    window.addEventListener('scroll', h);
    return () => window.removeEventListener('scroll', h);
  }, []);
  const links = ['Features', 'How It Works', 'About'];
  return (
    <nav className={`${styles.navbar} ${scrolled ? styles.navbarScrolled : ''}`}>
      <div className={styles.navInner}>
        <div className={styles.navLogo}>
          <span className={styles.logoSymbol}>◈</span>
          ARIA
        </div>
        <div className={`${styles.navLinks} ${menuOpen ? styles.navLinksOpen : ''}`}>
          {links.map(l => (
            <a key={l} href={`#${l.toLowerCase().replace(/ /g, '-')}`} className={styles.navLink} onClick={() => setMenuOpen(false)}>
              {l}
            </a>
          ))}
          <button className={styles.navCta} onClick={() => navigate('/dashboard')}>
            Launch App →
          </button>
        </div>
        <button className={styles.hamburger} onClick={() => setMenuOpen(!menuOpen)} aria-label="Menu">
          <span /><span /><span />
        </button>
      </div>
    </nav>
  );
}

/* ── Hero ── */
function Hero() {
  const navigate = useNavigate();
  return (
    <section className={styles.hero}>
      <div className={styles.heroGlow1} />
      <div className={styles.heroGlow2} />
      <div className={styles.heroGrid} />
      <div className={styles.particles}>
        {Array.from({ length: 16 }, (_, i) => (
          <div key={i} className={styles.particle} style={{
            left: `${10 + (i * 6.2) % 80}%`,
            top:  `${5  + (i * 11.7) % 85}%`,
            animationDelay: `${(i * 0.6) % 6}s`,
            animationDuration: `${5 + (i * 0.7) % 5}s`,
            width:  `${1.2 + (i % 3) * 0.6}px`,
            height: `${1.2 + (i % 3) * 0.6}px`,
            opacity: 0.12 + (i % 4) * 0.07,
          }} />
        ))}
      </div>

      <div className={styles.heroInner}>
        {/* Left: text */}
        <div className={styles.heroContent}>
          <div className={styles.heroBadge}>
            <span className={styles.heroBadgeDot} />
            AI-Powered · Real-Time · Institutional Grade
          </div>
          <h1 className={styles.heroTitle}>
            The Future of
            <span className={styles.heroAccent}>Smart Investing</span>
          </h1>
          <p className={styles.heroSub}>
            ARIA is your elite AI stock market assistant — analyzing portfolios,
            decoding market signals, and delivering institutional-grade insights
            in plain English. Faster than any analyst. Available 24/7.
          </p>
          <div className={styles.heroCtas}>
            <button className={styles.ctaPrimary} onClick={() => navigate('/dashboard')}>
              <span>Launch ARIA</span>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path d="M3 8h10M9 4l4 4-4 4" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </button>
            <a href="#how-it-works" className={styles.ctaSecondary}>See How It Works</a>
          </div>
          <div className={styles.heroStats}>
            {[
              { label: 'Assets Tracked',  value: '$2B+' },
              { label: 'Stocks Analyzed', value: '15,000+' },
              { label: 'Accuracy Rate',   value: '94.2%' },
              { label: 'Active Users',    value: '120K+' },
            ].map(s => (
              <div key={s.label} className={styles.heroStat}>
                <div className={styles.heroStatVal}>{s.value}</div>
                <div className={styles.heroStatLabel}>{s.label}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Right: mockup */}
        <div className={styles.heroMockup}>
          <div className={styles.mockupWindow}>
            <div className={styles.mockupBar}>
              <span /><span /><span />
              <div className={styles.mockupTitle}>ARIA Dashboard</div>
            </div>
            <div className={styles.mockupBody}>
              {[
                { sym: 'NVDA', chg: '+2.31%', up: true,  w: 78 },
                { sym: 'AAPL', chg: '-0.42%', up: false, w: 55 },
                { sym: 'MSFT', chg: '+1.12%', up: true,  w: 67 },
                { sym: 'TSLA', chg: '-3.12%', up: false, w: 42 },
              ].map((s, i) => (
                <div key={s.sym} className={styles.mockupRow} style={{ animationDelay: `${i * 0.15}s` }}>
                  <span className={styles.mockupSym}>{s.sym}</span>
                  <div className={styles.mockupBarTrack}>
                    <div className={styles.mockupBarFill} style={{ width: `${s.w}%`, background: s.up ? 'rgba(88,232,162,0.35)' : 'rgba(240,80,112,0.35)' }} />
                  </div>
                  <span className={s.up ? styles.mockupUp : styles.mockupDown}>{s.chg}</span>
                </div>
              ))}
              <div className={styles.mockupAI}>
                <div className={styles.mockupAIIcon}>◈</div>
                <div className={styles.mockupAIText}>
                  <div className={styles.mockupAILine} style={{ width: '88%' }} />
                  <div className={styles.mockupAILine} style={{ width: '68%' }} />
                  <div className={styles.mockupAILine} style={{ width: '80%' }} />
                </div>
              </div>
            </div>
          </div>
          <div className={`${styles.floatCard} ${styles.floatCard1}`}>
            <div className={styles.floatCardLabel}>Portfolio Return</div>
            <div className={styles.floatCardVal} style={{ color: '#58e8a2' }}>+28.4%</div>
          </div>
          <div className={`${styles.floatCard} ${styles.floatCard2}`}>
            <div className={styles.floatCardLabel}>AI Insight</div>
            <div className={styles.floatCardVal} style={{ fontSize: 11, color: '#a8b5cc' }}>NVDA overweight risk ↑</div>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ── Stats ── */
function Stats() {
  const [ref, inView] = useInView(0.2);
  const stats = [
    { val: 2,    suffix: 'B+', prefix: '$', label: 'Assets Analyzed',    decimals: 0 },
    { val: 15,   suffix: 'K+', prefix: '',  label: 'Stocks & ETFs',       decimals: 0 },
    { val: 94.2, suffix: '%',  prefix: '',  label: 'Prediction Accuracy', decimals: 1 },
    { val: 120,  suffix: 'K+', prefix: '',  label: 'Active Investors',    decimals: 0 },
    { val: 24,   suffix: '/7', prefix: '',  label: 'AI Availability',     decimals: 0 },
    { val: 0.3,  suffix: 's',  prefix: '<', label: 'Avg Response Time',   decimals: 1 },
  ];
  return (
    <section className={styles.statsSection} ref={ref}>
      <div className={styles.statsInner}>
        {stats.map((s, i) => (
          <div key={i} className={`${styles.statItem} ${inView ? styles.statItemVisible : ''}`} style={{ animationDelay: `${i * 0.1}s` }}>
            <div className={styles.statVal}>
              {inView && <AnimatedCounter target={s.val} prefix={s.prefix} suffix={s.suffix} decimals={s.decimals} />}
            </div>
            <div className={styles.statLabel}>{s.label}</div>
          </div>
        ))}
      </div>
    </section>
  );
}

/* ── Feature Deep-Dives ── */
const FEATURES = [
  {
    id: 'ai-chat',
    image: '/images/image1.png',
    tag: 'AI Assistant',
    tagColor: '#7eb8f7',
    accentClass: 'gradTextBlue',
    title: 'Chat With a Fund Manager — Powered by AI',
    points: [
      { icon: '💬', text: 'Ask anything in plain English and get instant, data-backed answers about your portfolio, stocks, or market conditions.' },
      { icon: '📊', text: 'ARIA knows your holdings, cost basis, and P&L — so every response is tailored to your exact situation, not generic advice.' },
      { icon: '⚡', text: 'Streamed in real time via Groq — the fastest AI engine available. Get analyst-quality answers in under a second.' },
    ],
    color: '#7eb8f7',
    side: 'right',
  },
  {
    id: 'live-data',
    image: '/images/image2.png',
    tag: 'Live Market Data',
    tagColor: '#58e8a2',
    accentClass: 'gradTextGreen',
    title: 'Real Prices. Zero Delay. Always On.',
    points: [
      { icon: '📡', text: "Live quotes from Finnhub's institutional-grade API — the same data used by hedge funds and fintech platforms." },
      { icon: '🔄', text: 'Prices refresh every 2 minutes automatically. A live ticker tape keeps you aware of moves across all screens.' },
      { icon: '📉', text: 'Track S&P 500, NASDAQ, DOW, and VIX alongside your stocks — full macro context, always visible.' },
    ],
    color: '#58e8a2',
    side: 'left',
  },
  {
    id: 'charts',
    image: '/images/image3.png',
    tag: 'Interactive Charts',
    tagColor: '#f0c060',
    accentClass: 'gradTextGold',
    title: 'See the Past. Forecast the Future.',
    points: [
      { icon: '📈', text: 'View 6 time periods from 1W to 2Y with full OHLCV data on every candle — just hover to inspect.' },
      { icon: '🔮', text: 'Toggle AI Forecast to see a 30-day projection with a volatility confidence band — direction made visible.' },
      { icon: '📦', text: 'Overlay trading volume beneath price to spot accumulation, breakouts, and distribution in seconds.' },
    ],
    color: '#f0c060',
    side: 'right',
  },
  {
    id: 'portfolio',
    image: '/images/image4.png',
    tag: 'Portfolio Analytics',
    tagColor: '#c084fc',
    accentClass: 'gradTextPurple',
    title: 'Know Your Risk Before the Market Does.',
    points: [
      { icon: '💼', text: 'Live P&L on every position — see exactly what each holding contributes to your total return, ranked by performance.' },
      { icon: '🥧', text: 'Sector allocation donut updates in real time. Instantly spot dangerous over-concentration before it becomes a loss.' },
      { icon: '🧠', text: 'Ask ARIA about your risk and it computes position weights, correlations, and tail-risk alerts on demand.' },
    ],
    color: '#c084fc',
    side: 'left',
  },
  {
    id: 'markets',
    image: '/images/image5.png',
    tag: 'Markets Overview',
    tagColor: '#f05070',
    accentClass: 'gradTextRed',
    title: 'Spot Every Move. Miss Nothing.',
    points: [
      { icon: '🔍', text: 'A live grid of 10 stocks with real-time prices and % change — click any to instantly load its full chart.' },
      { icon: '🏆', text: 'Top Gainers and Losers auto-ranked every refresh — see where momentum is building or collapsing at a glance.' },
      { icon: '🌐', text: 'Four index cards track S&P, NASDAQ, DOW, and VIX simultaneously — macro and micro in one view.' },
    ],
    color: '#f05070',
    side: 'right',
  },
  {
    id: 'learn',
    image: '/images/image6.png',
    tag: 'Investment Academy',
    tagColor: '#7eb8f7',
    accentClass: 'gradTextBlue',
    title: 'Learn Investing. Get Tested. Level Up.',
    points: [
      { icon: '🎓', text: '30 structured lessons across 6 tracks — from basic stocks to options, sector rotation, and behavioral finance.' },
      { icon: '✍️', text: 'Each lesson streams live, word-by-word, with real examples, tables, and a clear "How to Apply This" takeaway.' },
      { icon: '🎯', text: 'After each lesson, take an AI-generated quiz with scenario questions and full explanations for every answer.' },
    ],
    color: '#7eb8f7',
    side: 'left',
  },
];

/* ── Animated Feature Block ── */
function FeatureDeepDive({ feature, index }) {
  const [ref, inView] = useInView(0.12);
  const isRight = feature.side === 'right';

  return (
    <div
      ref={ref}
      id={feature.id}
      className={`${styles.featureDeep} ${inView ? styles.featureDeepVisible : ''}`}
      style={{ '--feat-color': feature.color, '--delay': `${index * 0.05}s` }}
    >
      {/* Image side */}
      {!isRight && (
        <div className={`${styles.featureImgCol} ${inView ? styles.featureImgSlideIn : ''}`}>
          <div className={styles.featureImgWrap} style={{ '--feat-color': feature.color }}>
            <div className={styles.featureImgGlow} />
            <img
              src={feature.image}
              alt={feature.tag}
              className={styles.featureImg}
              onError={e => { e.target.style.display = 'none'; e.target.nextSibling.style.display = 'flex'; }}
            />
            <div className={styles.featureImgFallback} style={{ display: 'none' }}>
              <span style={{ fontSize: 56, filter: 'drop-shadow(0 0 20px var(--feat-color))' }}>
                {['◈','◉','📈','◈','⬡','🎓'][index]}
              </span>
            </div>
          </div>
        </div>
      )}

      {/* Text side */}
      <div className={`${styles.featureTextCol} ${inView ? styles.featureTextSlideIn : ''}`} style={{ animationDelay: `${index * 0.05 + 0.1}s` }}>
        <div className={styles.featureTagSmall} style={{ color: feature.tagColor, borderColor: `${feature.tagColor}40` }}>
          {feature.tag}
        </div>
        <h3 className={styles.featureDeepTitle}>
          <span className={styles[feature.accentClass]}>{feature.title}</span>
        </h3>
        <div className={styles.featurePoints}>
          {feature.points.map((p, i) => (
            <div
              key={i}
              className={`${styles.featurePoint} ${inView ? styles.featurePointVisible : ''}`}
              style={{ transitionDelay: `${index * 0.05 + 0.15 + i * 0.1}s` }}
            >
              <div className={styles.featurePointIcon} style={{ background: `${feature.color}15`, border: `1px solid ${feature.color}30` }}>
                {p.icon}
              </div>
              <p className={styles.featurePointText}>{p.text}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Image side (right) */}
      {isRight && (
        <div className={`${styles.featureImgCol} ${inView ? styles.featureImgSlideIn : ''}`} style={{ animationDelay: `${index * 0.05 + 0.05}s` }}>
          <div className={styles.featureImgWrap} style={{ '--feat-color': feature.color }}>
            <div className={styles.featureImgGlow} />
            <img
              src={feature.image}
              alt={feature.tag}
              className={styles.featureImg}
              onError={e => { e.target.style.display = 'none'; e.target.nextSibling.style.display = 'flex'; }}
            />
            <div className={styles.featureImgFallback} style={{ display: 'none' }}>
              <span style={{ fontSize: 56, filter: 'drop-shadow(0 0 20px var(--feat-color))' }}>
                {['◈','◉','📈','◈','⬡','🎓'][index]}
              </span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function FeaturesSection() {
  const [ref, inView] = useInView();
  return (
    <section id="features" className={styles.featuresSection} ref={ref}>
      <div className={styles.container}>
        <div className={`${styles.sectionTag} ${inView ? styles.visible : ''}`}>Features</div>
        <h2 className={`${styles.sectionTitle} ${styles.centered} ${inView ? styles.visible : ''}`}>
          Everything You Need to<br />
          <span className={styles.gradText}>Invest With Confidence</span>
        </h2>
        <p className={`${styles.sectionDesc} ${styles.centered} ${inView ? styles.visible : ''}`}>
          Six powerful modules, each purpose-built to make you a sharper, faster, more confident investor.
        </p>
      </div>
      <div className={styles.featureDeepList}>
        {FEATURES.map((f, i) => (
          <FeatureDeepDive key={f.id} feature={f} index={i} />
        ))}
      </div>
    </section>
  );
}

/* ── Why You Need It ── */
function WhyYouNeedIt() {
  const [ref, inView] = useInView();
  const problems = [
    { icon: '⏱', pain: 'Hours spent analyzing stocks manually',    solution: 'Ask ARIA in seconds — instant institutional analysis' },
    { icon: '🧩', pain: 'Portfolio blind spots and hidden risk',     solution: 'Automatic risk detection across all your positions' },
    { icon: '📉', pain: 'Emotional, reactive trading decisions',     solution: 'Data-driven AI guidance removes emotion from the equation' },
    { icon: '💸', pain: 'Expensive financial advisors & research',   solution: 'AI advisor quality at a fraction of the cost' },
    { icon: '🌐', pain: 'Missing market-moving events',             solution: 'Real-time feeds and proactive alerts keep you ahead' },
    { icon: '📊', pain: 'Complex data with no clear narrative',      solution: 'ARIA turns raw data into clear, actionable insights' },
  ];
  return (
    <section className={styles.whySection} ref={ref}>
      <div className={styles.container}>
        <div className={`${styles.sectionTag} ${inView ? styles.visible : ''}`} style={{ '--tag-color': '#58e8a2' }}>
          Why You Need ARIA
        </div>
        <h2 className={`${styles.sectionTitle} ${inView ? styles.visible : ''}`}>
          Every Investor's Problem.<br />
          <span className={styles.gradTextGreen}>One Elegant Solution.</span>
        </h2>
        <div className={styles.whyGrid}>
          {problems.map((p, i) => (
            <div key={i} className={`${styles.whyCard} ${inView ? styles.whyCardVisible : ''}`} style={{ animationDelay: `${i * 0.08}s` }}>
              <div className={styles.whyIcon}>{p.icon}</div>
              <div className={styles.whyContent}>
                <div className={styles.whyPain}><span className={styles.whyX}>✗</span>{p.pain}</div>
                <div className={styles.whySolution}><span className={styles.whyCheck}>✓</span>{p.solution}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ── How It Works ── */
function HowItWorks() {
  const [ref, inView] = useInView();
  const steps = [
    { num: '01', icon: '◈', title: 'Connect Your Portfolio',    desc: 'Input your holdings manually or use the pre-loaded demo portfolio. ARIA immediately begins analyzing your positions with live market data.' },
    { num: '02', icon: '⬡', title: 'Ask Anything',              desc: 'Type a question in plain English — "What\'s my biggest risk?" or "Compare NVDA vs AMD" — and ARIA delivers expert-level analysis instantly.' },
    { num: '03', icon: '◉', title: 'Get Intelligent Insights',  desc: 'Receive data-driven analysis, risk flags, opportunity highlights, and actionable recommendations tailored to your specific portfolio.' },
    { num: '04', icon: '⊕', title: 'Learn & Optimize',           desc: 'Use the Investment Academy to deepen your knowledge, track progress, and continuously sharpen your decision-making with AI-powered lessons.' },
  ];
  return (
    <section id="how-it-works" className={styles.howSection} ref={ref}>
      <div className={styles.container}>
        <div className={`${styles.sectionTag} ${inView ? styles.visible : ''}`} style={{ '--tag-color': '#f0c060' }}>
          How It Works
        </div>
        <h2 className={`${styles.sectionTitle} ${styles.centered} ${inView ? styles.visible : ''}`}>
          From Question to<br />
          <span className={styles.gradTextGold}>Insight in Seconds</span>
        </h2>
        <div className={styles.stepsWrap}>
          {steps.map((step, i) => (
            <div key={i} className={`${styles.stepCard} ${inView ? styles.stepCardVisible : ''}`} style={{ animationDelay: `${i * 0.15}s` }}>
              <div className={styles.stepNum}>{step.num}</div>
              <div className={styles.stepIconWrap}><div className={styles.stepIcon}>{step.icon}</div></div>
              <h3 className={styles.stepTitle}>{step.title}</h3>
              <p className={styles.stepDesc}>{step.desc}</p>
              {i < steps.length - 1 && <div className={styles.stepConnector} />}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ── AI Chat Demo ── */
function AIDemo() {
  const [ref, inView] = useInView();
  const msgs = [
    { role: 'user',      text: "What's my biggest portfolio risk right now?" },
    { role: 'assistant', text: "Your largest risk is **concentration in Tech** — NVDA, AAPL, and MSFT together represent ~68% of your portfolio. NVDA alone is up **+112%** from your cost basis ($412 → $875), meaning it now has outsized weight.\n\nIf the semiconductor sector corrects 15–20%, you could see a **~$8,400 drawdown** from that position alone.\n\n**Recommendation:** Consider trimming NVDA by 3–4 shares and rotating proceeds into non-tech exposure like JPM or a broad ETF." },
    { role: 'user',      text: "Should I cut my TSLA position?" },
    { role: 'assistant', text: "TSLA is your only significant loser — **-22.2%** from your $230 avg cost. At 20 shares, that's a **-$1,020 unrealized loss**.\n\nThe case for cutting: harvesting the loss offsets gains elsewhere for **tax efficiency**, and capital could move into higher-conviction names.\n\n**Bottom line:** Rotating into **AMZN or GOOGL** before year-end improves both your tax position and portfolio quality." },
  ];
  return (
    <section className={styles.demoSection} ref={ref}>
      <div className={styles.container}>
        <div className={`${styles.sectionTag} ${inView ? styles.visible : ''}`} style={{ '--tag-color': '#7eb8f7' }}>Live AI Demo</div>
        <h2 className={`${styles.sectionTitle} ${styles.centered} ${inView ? styles.visible : ''}`}>
          See ARIA in<br /><span className={styles.gradTextBlue}>Action</span>
        </h2>
        <p className={`${styles.sectionDesc} ${styles.centered} ${inView ? styles.visible : ''}`}>
          A real example of the depth and quality of analysis ARIA provides every time you ask a question.
        </p>
        <div className={`${styles.chatDemo} ${inView ? styles.chatDemoVisible : ''}`}>
          <div className={styles.chatDemoHeader}>
            <div className={styles.chatDemoDots}><span/><span/><span/></div>
            <div className={styles.chatDemoTitle}>◈ ARIA — AI Assistant</div>
            <div className={styles.chatDemoStatus}><span className={styles.pulseDot}/>Live</div>
          </div>
          <div className={styles.chatDemoBody}>
            {msgs.map((m, i) => (
              <div key={i} className={`${styles.demoMsg} ${m.role === 'user' ? styles.demoMsgUser : styles.demoMsgAI}`} style={{ animationDelay: `${0.3 + i * 0.2}s` }}>
                {m.role === 'assistant' && <div className={styles.demoMsgLabel}>◈ ARIA</div>}
                <div className={styles.demoMsgBubble}>
                  {m.text.split(/\*\*(.+?)\*\*/g).map((part, j) =>
                    j % 2 === 1
                      ? <strong key={j} style={{ color: '#7eb8f7' }}>{part}</strong>
                      : part.split('\n').map((line, k) => <span key={k}>{line}{k < part.split('\n').length - 1 ? <br/> : null}</span>)
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

/* ── CTA ── */
function CTASection() {
  const navigate = useNavigate();
  const [ref, inView] = useInView();
  return (
    <section className={styles.ctaSection} ref={ref}>
      <div className={styles.ctaGlow1} />
      <div className={styles.ctaGlow2} />
      <div className={`${styles.ctaContent} ${inView ? styles.ctaContentVisible : ''}`}>
        <div className={styles.ctaIcon}>◈</div>
        <h2 className={styles.ctaTitle}>
          Start Investing Smarter<br />
          <span className={styles.shimmer}>Today — It's Free</span>
        </h2>
        <p className={styles.ctaDesc}>
          Join 120,000+ investors using ARIA to make better, faster, and more confident decisions.
          Your API keys are all you need to get started.
        </p>
        <button className={styles.ctaBigBtn} onClick={() => navigate('/dashboard')}>
          Launch ARIA Free
          <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
            <path d="M3.5 9h11M10 5l4.5 4-4.5 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </button>
        <div className={styles.ctaTrust}>
          <span>✓ No credit card</span>
          <span>✓ Instant access</span>
          <span>✓ Your data stays local</span>
        </div>
      </div>
    </section>
  );
}

/* ── Footer ── */
function Footer() {
  return (
    <footer className={styles.footer}>
      <div className={styles.footerInner}>
        <div className={styles.footerTop}>
          <div className={styles.footerBrand}>
            <div className={styles.footerLogo}><span className={styles.logoSymbol}>◈</span> ARIA</div>
            <p className={styles.footerTagline}>AI-powered stock market intelligence for every investor.</p>
            <div className={styles.footerSocials}>
              {['𝕏', 'in', '▶'].map((s, i) => <div key={i} className={styles.socialIcon}>{s}</div>)}
            </div>
          </div>
          {[
            { head: 'Product', links: ['Features', 'How It Works', 'Investment Academy', 'Changelog'] },
            { head: 'Company', links: ['About Us', 'Blog', 'Careers', 'Contact'] },
            { head: 'Legal',   links: ['Privacy Policy', 'Terms of Service', 'Disclaimer'] },
          ].map(col => (
            <div key={col.head} className={styles.footerCol}>
              <div className={styles.footerColHead}>{col.head}</div>
              {col.links.map(l => <a key={l} href="#" className={styles.footerLink}>{l}</a>)}
            </div>
          ))}
        </div>
        <div className={styles.footerBottom}>
          <span>© 2025 ARIA. All rights reserved.</span>
          <span style={{ color: '#4a5268' }}>Built with AI · Powered by Groq</span>
        </div>
      </div>
    </footer>
  );
}

/* ── Page ── */
export default function LandingPage() {
  return (
    <div className={styles.page}>
      <TickerTape />
      <Navbar />
      <Hero />
      <Stats />
      <FeaturesSection />
      <WhyYouNeedIt />
      <HowItWorks />
      <AIDemo />
      <CTASection />
      <Footer />
    </div>
  );
}
ENDFILE_SRC_PAGES_LANDINGPAGE_JS

cat > src/pages/LandingPage.module.css << 'ENDFILE_SRC_PAGES_LANDINGPAGE_MODULE_CSS'
/* ── Keyframes ── */
@keyframes fadeUp   { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: none; } }
@keyframes float    { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
@keyframes pulse    { 0%,100% { opacity: 1; box-shadow: 0 0 0 0 rgba(88,232,162,0.5); } 50% { opacity: 0.8; box-shadow: 0 0 0 6px rgba(88,232,162,0); } }
@keyframes shimmer  { 0%,100% { background-position: 200% center; } to { background-position: -200% center; } }

/* ── Shimmer text ── */
.shimmer {
  background: linear-gradient(90deg, #a8b5cc 0%, #ffffff 40%, #7eb8f7 60%, #a8b5cc 100%);
  background-size: 200% auto;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: shimmer 3s linear infinite;
}

/* ── Page ── */
.page { min-height: 100vh; background: #060810; color: #e2eaf5; }

/* ── Navbar ── */
.navbar {
  position: fixed;
  top: 40px;
  left: 0; right: 0;
  z-index: 500;
  padding: 0 24px;
  transition: background 0.3s, border-color 0.3s, top 0.3s;
}
.navbarScrolled {
  top: 0;
  background: rgba(6,8,16,0.94);
  border-bottom: 1px solid rgba(168,181,204,0.10);
  backdrop-filter: blur(20px);
}
.navInner {
  max-width: 1280px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 68px;
}
.navLogo {
  font-family: 'Playfair Display', serif;
  font-size: 22px;
  font-weight: 700;
  color: #e2eaf5;
  display: flex;
  align-items: center;
  gap: 8px;
  letter-spacing: 0.02em;
}
.logoSymbol { color: #7eb8f7; font-size: 18px; }
.navLinks { display: flex; align-items: center; gap: 4px; }
.navLink {
  color: #7a879e;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  padding: 6px 14px;
  border-radius: 6px;
  transition: color 0.2s, background 0.2s;
  font-family: 'Outfit', sans-serif;
}
.navLink:hover { color: #e2eaf5; background: rgba(168,181,204,0.06); }
.navCta {
  background: linear-gradient(135deg, #a8b5cc, #e2eaf5, #7a879e);
  color: #060810;
  border: none;
  border-radius: 8px;
  padding: 9px 20px;
  font-size: 13px;
  font-weight: 700;
  font-family: 'Outfit', sans-serif;
  cursor: pointer;
  margin-left: 8px;
  transition: opacity 0.2s, transform 0.2s;
  letter-spacing: 0.02em;
}
.navCta:hover { opacity: 0.88; transform: translateY(-1px); }
.hamburger {
  display: none;
  flex-direction: column;
  gap: 5px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
}
.hamburger span {
  display: block;
  width: 22px; height: 2px;
  background: #a8b5cc;
  border-radius: 2px;
  transition: transform 0.3s;
}

/* ── Hero ── */
.hero {
  position: relative;
  min-height: 100vh;
  /* push content below ticker (40px) + navbar (68px) + breathing room */
  padding: 152px 40px 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: #060810;
}
.heroGlow1 {
  position: absolute; top: -15%; left: -8%;
  width: 65%; height: 65%;
  background: radial-gradient(ellipse, rgba(126,184,247,0.09) 0%, transparent 70%);
  pointer-events: none;
}
.heroGlow2 {
  position: absolute; bottom: -8%; right: -4%;
  width: 50%; height: 50%;
  background: radial-gradient(ellipse, rgba(88,232,162,0.05) 0%, transparent 70%);
  pointer-events: none;
}
.heroGrid {
  position: absolute; inset: 0;
  background-image:
    linear-gradient(rgba(168,181,204,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(168,181,204,0.03) 1px, transparent 1px);
  background-size: 60px 60px;
  pointer-events: none;
}
.particles { position: absolute; inset: 0; pointer-events: none; }
.particle {
  position: absolute;
  border-radius: 50%;
  background: #7eb8f7;
  animation: float 5s ease-in-out infinite;
}

/* Inner layout: text left, mockup right */
.heroInner {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 1200px;
  display: flex;
  align-items: center;
  gap: 64px;
}

/* Left column */
.heroContent {
  flex: 1;
  min-width: 0;
  max-width: 580px;
  animation: fadeUp 0.8s ease both;
}
.heroBadge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(126,184,247,0.08);
  border: 1px solid rgba(126,184,247,0.22);
  border-radius: 20px;
  padding: 7px 16px;
  font-size: 12px;
  color: #7eb8f7;
  font-family: 'JetBrains Mono', monospace;
  letter-spacing: 0.05em;
  margin-bottom: 28px;
}
.heroBadgeDot {
  width: 6px; height: 6px;
  border-radius: 50%;
  background: #58e8a2;
  animation: pulse 2s infinite;
  flex-shrink: 0;
}
.heroTitle {
  font-family: 'Playfair Display', serif;
  font-size: clamp(40px, 5.5vw, 72px);
  font-weight: 900;
  line-height: 1.06;
  color: #e2eaf5;
  margin: 0 0 22px;
  letter-spacing: -0.02em;
}
/* Accent line on its own row, italic + shimmer */
.heroAccent {
  display: block;
  font-style: italic;
  background: linear-gradient(90deg, #a8b5cc 0%, #ffffff 40%, #7eb8f7 60%, #a8b5cc 100%);
  background-size: 200% auto;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: shimmer 4s linear infinite;
  margin-top: 4px;
}
.heroSub {
  font-size: 17px;
  color: #7a879e;
  line-height: 1.72;
  max-width: 500px;
  margin-bottom: 36px;
  font-family: 'Outfit', sans-serif;
}
.heroCtas {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
  margin-bottom: 48px;
}
.ctaPrimary {
  display: flex; align-items: center; gap: 8px;
  background: linear-gradient(135deg, #a8b5cc 0%, #e2eaf5 50%, #7a879e 100%);
  color: #060810; border: none; border-radius: 10px;
  padding: 14px 28px; font-size: 15px; font-weight: 700;
  font-family: 'Outfit', sans-serif; cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  box-shadow: 0 4px 24px rgba(168,181,204,0.2); letter-spacing: 0.02em;
}
.ctaPrimary:hover { transform: translateY(-2px); box-shadow: 0 8px 32px rgba(168,181,204,0.3); }
.ctaSecondary {
  display: flex; align-items: center; gap: 8px;
  background: transparent; color: #a8b5cc;
  border: 1px solid rgba(168,181,204,0.2); border-radius: 10px;
  padding: 14px 28px; font-size: 15px; font-weight: 500;
  font-family: 'Outfit', sans-serif; cursor: pointer;
  text-decoration: none; transition: border-color 0.2s, color 0.2s;
}
.ctaSecondary:hover { border-color: rgba(168,181,204,0.5); color: #e2eaf5; }

.heroStats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  padding-top: 24px;
  border-top: 1px solid rgba(168,181,204,0.08);
}
.heroStatVal {
  font-family: 'Playfair Display', serif;
  font-size: 21px; font-weight: 700; color: #e2eaf5; margin-bottom: 4px;
}
.heroStatLabel {
  font-size: 10px; color: #4a5268;
  font-family: 'JetBrains Mono', monospace;
  text-transform: uppercase; letter-spacing: 0.08em;
}

/* Right column: mockup */
.heroMockup {
  flex: 1;
  max-width: 460px;
  position: relative;
  animation: fadeUp 0.8s 0.2s ease both;
}
.mockupWindow {
  background: linear-gradient(145deg, rgba(24,29,46,0.96), rgba(11,14,24,0.99));
  border: 1px solid rgba(168,181,204,0.13);
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 24px 64px rgba(0,0,0,0.65), 0 0 40px rgba(126,184,247,0.08);
}
.mockupBar {
  display: flex; align-items: center; gap: 6px;
  padding: 12px 16px;
  background: rgba(11,14,24,0.8);
  border-bottom: 1px solid rgba(168,181,204,0.08);
}
.mockupBar span { width: 10px; height: 10px; border-radius: 50%; }
.mockupBar span:nth-child(1) { background: #f05070; }
.mockupBar span:nth-child(2) { background: #f0c060; }
.mockupBar span:nth-child(3) { background: #58e8a2; }
.mockupTitle { margin-left: 8px; font-size: 11px; color: #4a5268; font-family: 'JetBrains Mono', monospace; }
.mockupBody { padding: 20px; display: flex; flex-direction: column; gap: 10px; }
.mockupRow { display: flex; align-items: center; gap: 10px; animation: fadeUp 0.5s both; }
.mockupSym { font-family: 'JetBrains Mono', monospace; font-size: 12px; color: #7eb8f7; width: 40px; flex-shrink: 0; }
.mockupBarTrack { flex: 1; height: 6px; background: rgba(168,181,204,0.06); border-radius: 3px; overflow: hidden; }
.mockupBarFill { height: 100%; border-radius: 3px; transition: width 1.2s ease; }
.mockupUp   { font-size: 11px; color: #58e8a2; font-family: 'JetBrains Mono', monospace; width: 52px; text-align: right; }
.mockupDown { font-size: 11px; color: #f05070; font-family: 'JetBrains Mono', monospace; width: 52px; text-align: right; }
.mockupAI {
  margin-top: 8px; display: flex; gap: 10px; align-items: flex-start;
  background: rgba(126,184,247,0.05); border: 1px solid rgba(126,184,247,0.12);
  border-radius: 10px; padding: 12px;
}
.mockupAIIcon { color: #7eb8f7; font-size: 16px; flex-shrink: 0; margin-top: 2px; }
.mockupAIText { flex: 1; display: flex; flex-direction: column; gap: 5px; }
.mockupAILine {
  height: 7px;
  background: linear-gradient(90deg, rgba(168,181,204,0.14), rgba(168,181,204,0.04));
  border-radius: 4px;
  animation: shimmer 2.5s infinite linear;
  background-size: 200%;
}
.floatCard {
  position: absolute;
  background: rgba(17,21,32,0.96);
  border: 1px solid rgba(168,181,204,0.15);
  border-radius: 10px;
  padding: 10px 14px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.5);
  animation: float 5s ease-in-out infinite;
}
.floatCard1 { bottom: -18px; left: -28px; animation-delay: 0s; }
.floatCard2 { top: 28px; right: -28px; animation-delay: 2.2s; }
.floatCardLabel { font-size: 10px; color: #4a5268; font-family: 'JetBrains Mono', monospace; margin-bottom: 3px; text-transform: uppercase; letter-spacing: 0.1em; }
.floatCardVal { font-size: 15px; font-weight: 600; font-family: 'Outfit', sans-serif; }

/* ── Shared section utilities ── */
.container { max-width: 1200px; margin: 0 auto; padding: 0 24px; }
.centered { text-align: center; margin-left: auto !important; margin-right: auto !important; }
.sectionTag {
  display: inline-block;
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px; text-transform: uppercase; letter-spacing: 0.14em;
  color: var(--tag-color, #7eb8f7);
  border: 1px solid; border-color: rgba(126,184,247,0.25);
  border-radius: 20px; padding: 5px 14px; margin-bottom: 20px;
  opacity: 0; transform: translateY(12px);
  transition: opacity 0.5s, transform 0.5s;
}
.sectionTag.visible, .sectionTitle.visible, .sectionDesc.visible {
  opacity: 1; transform: translateY(0);
}
.sectionTitle {
  font-family: 'Playfair Display', serif;
  font-size: clamp(30px, 3.8vw, 52px);
  font-weight: 900; line-height: 1.1; color: #e2eaf5;
  margin-bottom: 20px; letter-spacing: -0.02em;
  opacity: 0; transform: translateY(16px);
  transition: opacity 0.6s 0.1s, transform 0.6s 0.1s;
}
.sectionDesc {
  font-size: 16px; color: #7a879e; max-width: 560px;
  line-height: 1.72; margin-bottom: 48px;
  font-family: 'Outfit', sans-serif;
  opacity: 0; transform: translateY(12px);
  transition: opacity 0.6s 0.2s, transform 0.6s 0.2s;
}
.gradText       { background: linear-gradient(135deg, #a8b5cc, #e2eaf5); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.gradTextGreen  { background: linear-gradient(135deg, #58e8a2, #a8ffcc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.gradTextGold   { background: linear-gradient(135deg, #f0c060, #ffe8a0); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.gradTextBlue   { background: linear-gradient(135deg, #7eb8f7, #b8d8ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.gradTextPurple { background: linear-gradient(135deg, #c084fc, #e0b8ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.gradTextRed    { background: linear-gradient(135deg, #f05070, #ff8099); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }

/* ── Stats ── */
.statsSection {
  padding: 72px 24px;
  background: linear-gradient(90deg, #0b0e18, #111520, #0b0e18);
  border-top: 1px solid rgba(168,181,204,0.08);
  border-bottom: 1px solid rgba(168,181,204,0.08);
}
.statsInner {
  max-width: 1200px; margin: 0 auto;
  display: grid; grid-template-columns: repeat(6, 1fr);
  gap: 24px; text-align: center;
}
.statItem { opacity: 0; transform: translateY(12px); transition: opacity 0.5s, transform 0.5s; }
.statItemVisible { opacity: 1; transform: translateY(0); }
.statVal {
  font-family: 'Playfair Display', serif; font-size: 36px; font-weight: 700;
  background: linear-gradient(135deg, #a8b5cc, #e2eaf5);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
}
.statLabel { font-size: 11px; color: #4a5268; font-family: 'JetBrains Mono', monospace; text-transform: uppercase; letter-spacing: 0.08em; margin-top: 6px; }

/* ── Feature Deep Dives ── */
@keyframes slideFromLeft  { from { opacity: 0; transform: translateX(-48px); } to { opacity: 1; transform: none; } }
@keyframes slideFromRight { from { opacity: 0; transform: translateX(48px);  } to { opacity: 1; transform: none; } }
@keyframes riseUp         { from { opacity: 0; transform: translateY(24px);  } to { opacity: 1; transform: none; } }

.featuresSection {
  padding: 100px 0 60px;
  background: #060810;
}
.featuresSection .container { text-align: center; }
.featureDeepList { margin-top: 24px; }

/* Each feature row */
.featureDeep {
  display: grid;
  grid-template-columns: 1fr 1fr;
  min-height: 420px;
  border-top: 1px solid rgba(168,181,204,0.06);
}
.featureDeep:last-child { border-bottom: 1px solid rgba(168,181,204,0.06); }
.featureDeep:nth-child(odd)  { background: #060810; }
.featureDeep:nth-child(even) { background: #080b14; }

/* ── Image column ── */
.featureImgCol {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px 40px;
  overflow: hidden;
  opacity: 0;
}
/* Odd rows: image is on the RIGHT → slide in from right */
.featureDeep:nth-child(odd) .featureImgCol  { order: 2; }
/* Even rows: image is on the LEFT → slide in from left */
.featureDeep:nth-child(even) .featureImgCol { order: 1; }

.featureImgSlideIn {
  animation: slideFromRight 0.75s cubic-bezier(0.22,1,0.36,1) both;
}
.featureDeep:nth-child(even) .featureImgSlideIn {
  animation-name: slideFromLeft;
}

.featureImgWrap {
  position: relative;
  width: 100%;
  max-width: 400px;
  border-radius: 16px;
  overflow: hidden;
  border: 1px solid rgba(168,181,204,0.10);
  box-shadow:
    0 0 0 1px rgba(168,181,204,0.05),
    0 24px 60px rgba(0,0,0,0.55),
    0 0 50px -10px var(--feat-color, #7eb8f7);
  transition: transform 0.4s ease, box-shadow 0.4s ease;
}
.featureImgWrap:hover {
  transform: translateY(-6px) scale(1.01);
  box-shadow:
    0 0 0 1px rgba(168,181,204,0.08),
    0 32px 72px rgba(0,0,0,0.65),
    0 0 70px -10px var(--feat-color, #7eb8f7);
}
.featureImgGlow {
  position: absolute; inset: 0; z-index: 0;
  background: radial-gradient(ellipse at 50% 0%, var(--feat-color, #7eb8f7) 0%, transparent 70%);
  opacity: 0.08;
  pointer-events: none;
}
.featureImg {
  display: block;
  width: 100%;
  height: auto;
  position: relative;
  z-index: 1;
  border-radius: 16px;
}
.featureImgFallback {
  width: 100%;
  min-height: 220px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(168,181,204,0.03);
}

/* ── Text column ── */
.featureTextCol {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 56px 52px;
  opacity: 0;
}
.featureDeep:nth-child(odd)  .featureTextCol { order: 1; }
.featureDeep:nth-child(even) .featureTextCol { order: 2; }

.featureTextSlideIn {
  animation: slideFromLeft 0.75s cubic-bezier(0.22,1,0.36,1) both;
}
.featureDeep:nth-child(even) .featureTextSlideIn {
  animation-name: slideFromRight;
}

.featureTagSmall {
  display: inline-block;
  font-size: 11px; font-family: 'JetBrains Mono', monospace;
  text-transform: uppercase; letter-spacing: 0.12em;
  border: 1px solid; border-radius: 20px;
  padding: 4px 14px; margin-bottom: 16px;
  width: fit-content;
}
.featureDeepTitle {
  font-family: 'Playfair Display', serif;
  font-size: clamp(20px, 2.2vw, 30px);
  font-weight: 800; line-height: 1.2;
  color: #e2eaf5; margin-bottom: 28px;
  letter-spacing: -0.01em;
}

/* ── Bullet points ── */
.featurePoints {
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.featurePoint {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  opacity: 0;
  transform: translateY(16px);
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.featurePointVisible {
  opacity: 1;
  transform: translateY(0);
}
.featurePoint:hover .featurePointIcon {
  transform: scale(1.12);
}
.featurePointIcon {
  width: 38px; height: 38px; flex-shrink: 0;
  border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  font-size: 17px;
  transition: transform 0.25s ease;
}
.featurePointText {
  font-size: 14px;
  color: #a8b5cc;
  line-height: 1.65;
  font-family: 'Outfit', sans-serif;
  margin: 0;
  padding-top: 8px;
}

/* ── Why section ── */
.whySection { padding: 100px 24px; background: #060810; }
.whyGrid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; margin-top: 48px; }
.whyCard {
  display: flex; align-items: flex-start; gap: 16px;
  background: rgba(11,14,24,0.8); border: 1px solid rgba(168,181,204,0.08);
  border-radius: 14px; padding: 20px 22px;
  opacity: 0; transform: translateX(-16px);
  transition: opacity 0.5s, transform 0.5s, border-color 0.2s;
}
.whyCardVisible { opacity: 1; transform: translateX(0); }
.whyCard:hover { border-color: rgba(168,181,204,0.16); }
.whyIcon { font-size: 22px; flex-shrink: 0; margin-top: 2px; }
.whyContent { flex: 1; }
.whyPain     { display: flex; align-items: flex-start; gap: 8px; font-size: 13px; color: #f05070; font-family: 'Outfit', sans-serif; margin-bottom: 8px; }
.whySolution { display: flex; align-items: flex-start; gap: 8px; font-size: 13px; color: #58e8a2; font-family: 'Outfit', sans-serif; }
.whyX     { color: #f05070; font-weight: 700; flex-shrink: 0; }
.whyCheck { color: #58e8a2; font-weight: 700; flex-shrink: 0; }

/* ── How It Works ── */
.howSection { padding: 100px 24px; background: #080b14; text-align: center; }
.howSection .sectionTitle { margin-left: auto; margin-right: auto; }
.stepsWrap { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-top: 56px; text-align: left; }
.stepCard {
  background: linear-gradient(145deg, rgba(17,21,32,0.9), rgba(11,14,24,0.95));
  border: 1px solid rgba(168,181,204,0.08); border-radius: 16px; padding: 28px 24px;
  position: relative;
  opacity: 0; transform: translateY(20px);
  transition: opacity 0.5s, transform 0.5s, border-color 0.2s;
}
.stepCardVisible { opacity: 1; transform: translateY(0); }
.stepCard:hover { border-color: rgba(168,181,204,0.18); }
.stepNum { font-family: 'JetBrains Mono', monospace; font-size: 11px; color: #4a5268; letter-spacing: 0.12em; margin-bottom: 16px; }
.stepIconWrap { margin-bottom: 16px; }
.stepIcon { font-size: 24px; color: #7eb8f7; }
.stepTitle { font-family: 'Outfit', sans-serif; font-size: 15px; font-weight: 700; color: #e2eaf5; margin-bottom: 10px; }
.stepDesc { font-size: 13px; color: #7a879e; line-height: 1.65; font-family: 'Outfit', sans-serif; }
.stepConnector {
  display: none; /* horizontal connector in desktop */
}

/* ── AI Chat Demo ── */
.demoSection { padding: 100px 24px; background: #060810; text-align: center; }
.demoSection .sectionTitle { margin-left: auto; margin-right: auto; }
.chatDemo {
  max-width: 760px; margin: 0 auto;
  background: linear-gradient(145deg, rgba(17,21,32,0.98), rgba(11,14,24,1));
  border: 1px solid rgba(168,181,204,0.12); border-radius: 16px; overflow: hidden;
  box-shadow: 0 24px 64px rgba(0,0,0,0.6), 0 0 40px rgba(126,184,247,0.06);
  opacity: 0; transform: translateY(24px);
  transition: opacity 0.7s 0.1s, transform 0.7s 0.1s;
}
.chatDemoVisible { opacity: 1; transform: translateY(0); }
.chatDemoHeader {
  display: flex; align-items: center; gap: 12px;
  padding: 14px 20px; background: rgba(11,14,24,0.8);
  border-bottom: 1px solid rgba(168,181,204,0.08);
}
.chatDemoDots { display: flex; gap: 6px; }
.chatDemoDots span { width: 10px; height: 10px; border-radius: 50%; }
.chatDemoDots span:nth-child(1) { background: #f05070; }
.chatDemoDots span:nth-child(2) { background: #f0c060; }
.chatDemoDots span:nth-child(3) { background: #58e8a2; }
.chatDemoTitle { flex: 1; text-align: center; font-size: 12px; color: #7a879e; font-family: 'JetBrains Mono', monospace; }
.chatDemoStatus { display: flex; align-items: center; gap: 6px; font-size: 11px; color: #58e8a2; font-family: 'JetBrains Mono', monospace; }
.pulseDot { width: 7px; height: 7px; border-radius: 50%; background: #58e8a2; animation: pulse 1.5s infinite; display: inline-block; }
.chatDemoBody { padding: 24px 20px; display: flex; flex-direction: column; gap: 20px; text-align: left; }
.demoMsg { opacity: 0; animation: fadeUp 0.5s ease both; }
.demoMsgUser { display: flex; justify-content: flex-end; }
.demoMsgAI {}
.demoMsgLabel { font-size: 11px; color: #7eb8f7; font-family: 'JetBrains Mono', monospace; margin-bottom: 6px; }
.demoMsgBubble {
  font-size: 13.5px; color: #c8d4e8; line-height: 1.7;
  font-family: 'Outfit', sans-serif; max-width: 90%;
}
.demoMsgUser .demoMsgBubble {
  background: rgba(168,181,204,0.07); border: 1px solid rgba(168,181,204,0.12);
  border-radius: 12px 3px 12px 12px; padding: 10px 14px;
}
.demoMsgAI .demoMsgBubble {
  background: rgba(126,184,247,0.04); border: 1px solid rgba(126,184,247,0.1);
  border-radius: 3px 12px 12px 12px; padding: 12px 16px;
}

/* ── CTA ── */
.ctaSection { padding: 120px 24px; background: #080b14; text-align: center; position: relative; overflow: hidden; }
.ctaGlow1 { position: absolute; top: -30%; left: 20%; width: 60%; height: 100%; background: radial-gradient(ellipse, rgba(168,181,204,0.05) 0%, transparent 70%); pointer-events: none; }
.ctaGlow2 { position: absolute; bottom: -20%; right: 10%; width: 40%; height: 80%; background: radial-gradient(ellipse, rgba(88,232,162,0.04) 0%, transparent 70%); pointer-events: none; }
.ctaContent { position: relative; z-index: 1; opacity: 0; transform: translateY(24px); transition: opacity 0.7s, transform 0.7s; }
.ctaContentVisible { opacity: 1; transform: translateY(0); }
.ctaIcon { font-size: 48px; color: #7eb8f7; margin-bottom: 24px; display: block; }
.ctaTitle {
  font-family: 'Playfair Display', serif;
  font-size: clamp(34px, 5vw, 58px);
  font-weight: 900; color: #e2eaf5;
  margin-bottom: 20px; letter-spacing: -0.02em; line-height: 1.1;
}
.ctaDesc { font-size: 17px; color: #7a879e; max-width: 480px; margin: 0 auto 40px; font-family: 'Outfit', sans-serif; line-height: 1.65; }
.ctaBigBtn {
  display: inline-flex; align-items: center; gap: 10px;
  background: linear-gradient(135deg, #a8b5cc 0%, #e2eaf5 50%, #7a879e 100%);
  color: #060810; border: none; border-radius: 12px;
  padding: 18px 40px; font-size: 16px; font-weight: 800;
  font-family: 'Outfit', sans-serif; cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  box-shadow: 0 4px 32px rgba(168,181,204,0.25); letter-spacing: 0.02em;
}
.ctaBigBtn:hover { transform: translateY(-3px); box-shadow: 0 10px 40px rgba(168,181,204,0.35); }
.ctaTrust { display: flex; gap: 24px; justify-content: center; margin-top: 20px; font-size: 13px; color: #4a5268; font-family: 'JetBrains Mono', monospace; flex-wrap: wrap; }

/* ── Footer ── */
.footer { background: #0b0e18; border-top: 1px solid rgba(168,181,204,0.08); padding: 60px 24px 32px; }
.footerInner { max-width: 1200px; margin: 0 auto; }
.footerTop { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 40px; margin-bottom: 48px; }
.footerLogo { display: flex; align-items: center; gap: 8px; font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 700; color: #e2eaf5; margin-bottom: 12px; }
.footerTagline { font-size: 13px; color: #4a5268; font-family: 'Outfit', sans-serif; line-height: 1.6; max-width: 240px; margin-bottom: 20px; }
.footerSocials { display: flex; gap: 10px; }
.socialIcon { width: 34px; height: 34px; background: rgba(168,181,204,0.06); border: 1px solid rgba(168,181,204,0.1); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 13px; color: #7a879e; cursor: pointer; transition: all 0.2s; }
.socialIcon:hover { border-color: rgba(168,181,204,0.3); color: #e2eaf5; }
.footerColHead { font-size: 11px; text-transform: uppercase; letter-spacing: 0.12em; color: #7a879e; font-family: 'JetBrains Mono', monospace; margin-bottom: 16px; }
.footerLink { display: block; font-size: 13px; color: #4a5268; font-family: 'Outfit', sans-serif; text-decoration: none; margin-bottom: 8px; transition: color 0.2s; }
.footerLink:hover { color: #a8b5cc; }
.footerBottom { display: flex; justify-content: space-between; align-items: center; padding-top: 24px; border-top: 1px solid rgba(168,181,204,0.06); font-size: 12px; color: #4a5268; font-family: 'JetBrains Mono', monospace; }

/* ── Responsive ── */
@media (max-width: 1100px) {
  .heroInner     { gap: 40px; }
  .statsInner    { grid-template-columns: repeat(3, 1fr); }
  .stepsWrap     { grid-template-columns: repeat(2, 1fr); }
  .footerTop     { grid-template-columns: 1fr 1fr; gap: 32px; }
  .featureTextCol { padding: 48px 36px; }
}

@media (max-width: 900px) {
  /* Hero */
  .heroMockup  { display: none; }
  .heroContent { max-width: 100%; text-align: center; }
  .heroSub     { margin-left: auto; margin-right: auto; }
  .heroCtas    { justify-content: center; }
  .heroStats   { max-width: 440px; margin: 0 auto; }
  .heroBadge   { margin-left: auto; margin-right: auto; }

  /* Features: stack vertically, image always on top */
  .featureDeep        { grid-template-columns: 1fr; }
  .featureImgCol      { order: 1 !important; padding: 36px 24px 20px; }
  .featureTextCol     { order: 2 !important; padding: 20px 28px 40px; }
  .featureImgWrap     { max-width: 100%; }
}

@media (max-width: 768px) {
  .navLinks    { display: none; flex-direction: column; position: absolute; top: 68px; left: 0; right: 0; background: rgba(6,8,16,0.98); border-bottom: 1px solid rgba(168,181,204,0.1); padding: 16px 24px 24px; gap: 4px; }
  .navLinksOpen { display: flex; }
  .hamburger   { display: flex; }
  .hero        { padding: 130px 20px 60px; }
  .heroTitle   { font-size: 38px; }
  .heroStats   { grid-template-columns: repeat(2, 1fr); }
  .whyGrid     { grid-template-columns: 1fr; }
  .stepsWrap   { grid-template-columns: 1fr; }
  .statsInner  { grid-template-columns: repeat(2, 1fr); }
  .footerTop   { grid-template-columns: 1fr 1fr; }
  .footerBottom { flex-direction: column; gap: 8px; text-align: center; }
  .heroCtas    { flex-direction: column; align-items: center; }
  .ctaTrust    { flex-direction: column; gap: 8px; }
  .featureTextCol { padding: 16px 20px 36px; }
}

@media (max-width: 480px) {
  .heroStats   { grid-template-columns: repeat(2, 1fr); }
  .statsInner  { grid-template-columns: 1fr 1fr; }
  .footerTop   { grid-template-columns: 1fr; }
}
ENDFILE_SRC_PAGES_LANDINGPAGE_MODULE_CSS

cat > src/pages/DashboardPage.js << 'ENDFILE_SRC_PAGES_DASHBOARDPAGE_JS'
import React, { useState, useEffect, useRef, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';

import ChatPanel from '../components/ChatPanel';
import LearnTab from '../components/LearnTab';
import { useStockData, useIndexData, PORTFOLIO_HOLDINGS, SECTOR_COLORS } from '../hooks/useStockData';
import StockChart from '../components/StockChart';
import MiniChart from '../components/MiniChart';
import DonutChart from '../components/DonutChart';
import styles from './DashboardPage.module.css';

/* ─── helpers ──────────────────────────────────────────────────────────── */
const fmt  = (n, d = 2) => n != null ? n.toLocaleString('en-US', { minimumFractionDigits: d, maximumFractionDigits: d }) : '—';
const fmtK = (n) => {
  if (!n) return '—';
  if (n >= 1e12) return `$${(n / 1e12).toFixed(2)}T`;
  if (n >= 1e9)  return `$${(n / 1e9).toFixed(1)}B`;
  if (n >= 1e6)  return `$${(n / 1e6).toFixed(1)}M`;
  return `$${n.toLocaleString()}`;
};
const fmtVol = (n) => {
  if (!n) return '—';
  if (n >= 1e9) return `${(n / 1e9).toFixed(2)}B`;
  if (n >= 1e6) return `${(n / 1e6).toFixed(1)}M`;
  return String(n);
};

function Skeleton({ w = '100%', h = 16, radius = 4 }) {
  return (
    <div style={{
      width: w, height: h, borderRadius: radius,
      background: 'linear-gradient(90deg,#1a2035 25%,#222840 50%,#1a2035 75%)',
      backgroundSize: '200% 100%',
      animation: 'skeletonShimmer 1.4s infinite',
      display: 'inline-block',
    }} />
  );
}

function StatCard({ label, value, sub, up, loading }) {
  return (
    <div className={styles.statCard}>
      <div className={styles.statLabel}>{label}</div>
      {loading
        ? <div style={{ marginTop: 4 }}><Skeleton h={28} radius={4} /></div>
        : <div className={`${styles.statValue} ${up === true ? styles.up : up === false ? styles.down : ''}`}>{value}</div>
      }
      {sub && !loading && (
        <div className={`${styles.statSub} ${up === true ? styles.up : up === false ? styles.down : styles.muted}`}>{sub}</div>
      )}
    </div>
  );
}

/* ─── Sidebar ──────────────────────────────────────────────────────────── */
function Sidebar({ activeTab, setActiveTab, collapsed, setCollapsed, indices, mobileOpen, setMobileOpen }) {
  const navigate = useNavigate();
  const tabs = [
    { id: 'dashboard', icon: '⬡', label: 'Dashboard' },
    { id: 'portfolio', icon: '◈', label: 'Portfolio'  },
    { id: 'markets',   icon: '◉', label: 'Markets'    },
    { id: 'search',    icon: '⊕', label: 'Search'     },
    { id: 'learn',     icon: '🎓', label: 'Learn'      },
  ];
  return (
    <>
      {mobileOpen && <div className={styles.mobileOverlay} onClick={() => setMobileOpen(false)} />}
      <aside className={`${styles.sidebar} ${collapsed ? styles.sidebarCollapsed : ''} ${mobileOpen ? styles.sidebarMobileOpen : ''}`}>
        <div className={styles.sidebarTop}>
          <div className={styles.sidebarLogo}>
            <span className={styles.logoIcon}>◈</span>
            {!collapsed && <span className={styles.logoText}>ARIA</span>}
          </div>
          <button className={styles.collapseBtn} onClick={() => { setCollapsed(!collapsed); setMobileOpen(false); }}>
            {collapsed ? '›' : '‹'}
          </button>
        </div>

        <nav className={styles.sidebarNav}>
          {!collapsed && <div className={styles.navGroup}>Menu</div>}
          {tabs.map(t => (
            <button
              key={t.id}
              className={`${styles.navItem} ${activeTab === t.id ? styles.navItemActive : ''}`}
              onClick={() => { setActiveTab(t.id); setMobileOpen(false); }}
              title={collapsed ? t.label : undefined}
            >
              <span className={styles.navIcon}>{t.icon}</span>
              {!collapsed && <span>{t.label}</span>}
            </button>
          ))}
        </nav>

        {!collapsed && indices.length > 0 && (
          <div className={styles.sidebarIndices}>
            <div className={styles.navGroup}>Indices</div>
            {indices.map(idx => (
              <div key={idx.symbol} className={styles.indexRow}>
                <span className={styles.indexName}>{idx.name}</span>
                <span className={idx.up ? styles.up : styles.down} style={{ fontSize: 11, fontFamily: 'var(--font-mono)' }}>
                  {idx.up ? '+' : ''}{fmt(idx.changePct)}%
                </span>
              </div>
            ))}
          </div>
        )}

        <div className={styles.sidebarFooter}>
          <button className={styles.backBtn} onClick={() => navigate('/')} title="Back to Home">
            {collapsed ? '←' : '← Home'}
          </button>
        </div>
      </aside>
    </>
  );
}

/* ─── Ticker tape ──────────────────────────────────────────────────────── */
function TickerTape({ quotes, indices }) {
  const items = [
    ...indices.map(i => ({ label: i.name, val: i.value, chg: `${i.up ? '+' : ''}${fmt(i.changePct)}%`, up: i.up })),
    ...Object.entries(quotes).slice(0, 10).map(([sym, d]) => ({
      label: sym,
      val:   `$${fmt(d.price)}`,
      chg:   `${d.changePct >= 0 ? '+' : ''}${fmt(d.changePct)}%`,
      up:    d.changePct >= 0,
    })),
  ];
  if (!items.length) return (
    <div className={styles.ticker} style={{ display: 'flex', alignItems: 'center', padding: '0 24px', fontSize: 11, color: '#4a5268', fontFamily: 'var(--font-mono)' }}>
      Loading market data…
    </div>
  );
  const doubled = [...items, ...items];
  return (
    <div className={styles.ticker}>
      <div className={styles.tickerInner}>
        {doubled.map((item, i) => (
          <div key={i} className={styles.tickerItem}>
            <span className={styles.tickerLabel}>{item.label}</span>
            <span className={styles.tickerVal}>{item.val}</span>
            <span className={item.up ? styles.up : styles.down} style={{ fontSize: 10, fontFamily: 'var(--font-mono)' }}>
              {item.chg}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

/* ─── Dashboard Tab ────────────────────────────────────────────────────── */
function DashboardTab({ quotes, loadHistory, loading }) {
  const [selected, setSelected] = useState('AAPL');

  const portfolioStats = useMemo(() => {
    if (!Object.keys(quotes).length) return null;
    const value    = PORTFOLIO_HOLDINGS.reduce((s, p) => s + (quotes[p.symbol]?.price || 0) * p.shares, 0);
    const cost     = PORTFOLIO_HOLDINGS.reduce((s, p) => s + p.shares * p.avgCost, 0);
    const gain     = value - cost;
    const gainPct  = cost ? (gain / cost) * 100 : 0;
    const dayChange= PORTFOLIO_HOLDINGS.reduce((s, p) => s + (quotes[p.symbol]?.change || 0) * p.shares, 0);
    return { value, cost, gain, gainPct, dayChange };
  }, [quotes]);

  const sectorMap = useMemo(() => {
    const m = {};
    PORTFOLIO_HOLDINGS.forEach(p => {
      const val = (quotes[p.symbol]?.price || p.avgCost) * p.shares;
      m[p.sector] = (m[p.sector] || 0) + val;
    });
    return m;
  }, [quotes]);

  // Use sector map total so percentages always sum to 100%
  const sectorTotal = Object.values(sectorMap).reduce((s, v) => s + v, 0) || 1;
  const donutSegs = Object.entries(sectorMap).map(([name, value]) => ({ name, value, color: SECTOR_COLORS[name] || '#7eb8f7' }));

  return (
    <div className={styles.tab}>
      <div className={styles.statsRow}>
        <StatCard label="Portfolio Value" loading={loading} up={portfolioStats?.gain >= 0}
          value={portfolioStats ? `$${fmt(portfolioStats.value)}` : '—'}
          sub={portfolioStats ? `${portfolioStats.gain >= 0 ? '+' : ''}$${fmt(portfolioStats.gain, 0)} total` : null}
        />
        <StatCard label="Total Return" loading={loading} up={portfolioStats?.gainPct >= 0}
          value={portfolioStats ? `${portfolioStats.gainPct >= 0 ? '+' : ''}${fmt(portfolioStats.gainPct)}%` : '—'}
          sub="vs. cost basis"
        />
        <StatCard label="Day P&L" loading={loading} up={portfolioStats?.dayChange >= 0}
          value={portfolioStats ? `${portfolioStats.dayChange >= 0 ? '+' : ''}$${fmt(Math.abs(portfolioStats.dayChange), 0)}` : '—'}
          sub="Today's change"
        />
        <StatCard label="Positions" loading={false} value={String(PORTFOLIO_HOLDINGS.length)} sub="3 sectors" />
      </div>

      <div className={styles.mainGrid}>
        <div className={styles.leftCol}>
          <div className={styles.card}>
            <div className={styles.cardHead}>
              <span className={styles.cardTitle}>Holdings</span>
              <span className={styles.badge}>Click a row to chart</span>
            </div>
            <div className={styles.tableScroll}>
              <table className={styles.table}>
                <thead>
                  <tr><th>Stock</th><th className={styles.right}>Price</th><th className={styles.right}>Day %</th><th className={styles.right}>Value</th><th className={styles.right}>P&L</th></tr>
                </thead>
                <tbody>
                  {PORTFOLIO_HOLDINGS.map(p => {
                    const q   = quotes[p.symbol];
                    const val = (q?.price || 0) * p.shares;
                    const pl  = ((q?.price || 0) - p.avgCost) * p.shares;
                    const plP = q ? ((q.price - p.avgCost) / p.avgCost) * 100 : 0;
                    return (
                      <tr key={p.symbol} className={`${styles.tableRow} ${selected === p.symbol ? styles.tableRowActive : ''}`} onClick={() => setSelected(p.symbol)}>
                        <td>
                          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                            <span className={styles.sym}>{p.symbol}</span>
                            <span style={{ fontSize: 12, color: '#7a879e' }}>{p.name}</span>
                          </div>
                          <div style={{ fontSize: 11, color: '#4a5268', marginTop: 1 }}>{p.shares} sh · avg ${fmt(p.avgCost)}</div>
                        </td>
                        <td className={`${styles.right} ${styles.mono}`}>{loading ? <Skeleton w={60} h={13} /> : q ? `$${fmt(q.price)}` : '—'}</td>
                        <td className={`${styles.right} ${q?.changePct >= 0 ? styles.up : styles.down}`}>{loading ? <Skeleton w={50} h={13} /> : q ? `${q.changePct >= 0 ? '+' : ''}${fmt(q.changePct)}%` : '—'}</td>
                        <td className={`${styles.right} ${styles.mono}`}>{loading ? <Skeleton w={60} h={13} /> : `$${fmt(val, 0)}`}</td>
                        <td className={`${styles.right} ${pl >= 0 ? styles.up : styles.down}`}>
                          {loading ? <Skeleton w={60} h={13} /> : (<>{pl >= 0 ? '+' : ''}${fmt(Math.abs(pl), 0)}<br/><span style={{ fontSize: 10 }}>({plP >= 0 ? '+' : ''}{fmt(plP)}%)</span></>)}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>

          <div className={styles.card}>
            <div className={styles.cardHead}>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, flexWrap: 'wrap' }}>
                <span className={styles.cardTitle}>{selected}</span>
                {quotes[selected] && <span style={{ fontSize: 18, fontWeight: 700, color: '#e2eaf5', fontFamily: 'var(--font-mono)' }}>${fmt(quotes[selected].price)}</span>}
                {quotes[selected] && <span className={quotes[selected].changePct >= 0 ? styles.up : styles.down} style={{ fontSize: 13, fontFamily: 'var(--font-mono)' }}>{quotes[selected].changePct >= 0 ? '+' : ''}{fmt(quotes[selected].changePct)}%</span>}
              </div>
            </div>
            <StockChart symbol={selected} loadHistory={loadHistory} quote={quotes[selected]} height={240} />
          </div>
        </div>

        <div className={styles.rightCol}>
          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle}>Allocation</span></div>
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 12 }}>
              <DonutChart segments={donutSegs} size={100} />
            </div>
            <div className={styles.allocBar}>
              {donutSegs.map((s, i) => <div key={i} style={{ flex: s.value, background: s.color, height: '100%', borderRadius: 3 }} />)}
            </div>
            <div style={{ marginTop: 12 }}>
              {donutSegs.map(s => (
                <div key={s.name} style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12, marginBottom: 6 }}>
                  <div style={{ width: 8, height: 8, borderRadius: '50%', background: s.color, flexShrink: 0 }} />
                  <span style={{ flex: 1, color: '#a8b5cc' }}>{s.name}</span>
                  <span style={{ color: '#7a879e', fontFamily: 'JetBrains Mono, monospace', fontSize: 11 }}>{((s.value / sectorTotal) * 100).toFixed(1)}%</span>
                </div>
              ))}
            </div>
          </div>

          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle}>Watchlist</span></div>
            {['GOOGL','META','NFLX','AMD'].map(sym => {
              const q  = quotes[sym];
              const up = (q?.changePct || 0) >= 0;
              return (
                <div key={sym} className={styles.watchRow} onClick={() => setSelected(sym)} style={{ cursor: 'pointer' }}>
                  <div style={{ minWidth: 0 }}>
                    <div style={{ fontSize: 13, fontWeight: 600, color: '#e2eaf5' }}>{sym}</div>
                    <div style={{ fontSize: 11, color: '#4a5268' }}>{q?.name || sym}</div>
                  </div>
                  <div style={{ flex: 1, padding: '0 8px' }} />
                  <div style={{ textAlign: 'right', flexShrink: 0 }}>
                    <div style={{ fontSize: 13, fontFamily: 'var(--font-mono)', color: '#e2eaf5' }}>{loading ? '—' : q ? `$${fmt(q.price)}` : '—'}</div>
                    <div className={up ? styles.up : styles.down} style={{ fontSize: 11, fontFamily: 'var(--font-mono)' }}>{loading ? '—' : q ? `${up ? '+' : ''}${fmt(q.changePct)}%` : '—'}</div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}

/* ─── Portfolio Tab ────────────────────────────────────────────────────── */
function PortfolioTab({ quotes, loadHistory, loading }) {
  const [selected, setSelected] = useState('NVDA');

  const rows = useMemo(() => PORTFOLIO_HOLDINGS.map(p => {
    const q   = quotes[p.symbol];
    const val = (q?.price || 0) * p.shares;
    const pl  = ((q?.price || 0) - p.avgCost) * p.shares;
    const plP = q ? ((q.price - p.avgCost) / p.avgCost) * 100 : 0;
    return { ...p, q, val, pl, plP };
  }), [quotes]);

  const totalVal   = rows.reduce((s, r) => s + r.val, 0);
  const totalCost  = rows.reduce((s, r) => s + r.shares * r.avgCost, 0);
  const totalPL    = totalVal - totalCost;
  const totalPLPct = totalCost ? (totalPL / totalCost) * 100 : 0;

  const sectorMap = useMemo(() => {
    const m = {};
    rows.forEach(r => { m[r.sector] = (m[r.sector] || 0) + r.val; });
    return m;
  }, [rows]);

  return (
    <div className={styles.tab}>
      <div className={styles.statsRow}>
        <StatCard label="Total Value"    loading={loading} value={`$${fmt(totalVal)}`} />
        <StatCard label="Cost Basis"     loading={loading} value={`$${fmt(totalCost)}`} />
        <StatCard label="Unrealized P&L" loading={loading} up={totalPL >= 0}
          value={`${totalPL >= 0 ? '+' : ''}$${fmt(Math.abs(totalPL), 0)}`}
          sub={`${totalPLPct >= 0 ? '+' : ''}${fmt(totalPLPct)}%`}
        />
        <StatCard label="Positions" loading={false} value={String(rows.length)} sub="Active" />
      </div>

      <div className={styles.mainGrid}>
        <div className={styles.leftCol}>
          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle}>All Positions</span><span className={styles.badge}>Live</span></div>
            <div className={styles.tableScroll}>
              <table className={styles.table}>
                <thead><tr><th>Symbol</th><th className={styles.right}>Shares</th><th className={styles.right}>Avg Cost</th><th className={styles.right}>Price</th><th className={styles.right}>Value</th><th className={styles.right}>P&L</th><th className={styles.right}>%</th><th className={styles.right}>Weight</th></tr></thead>
                <tbody>
                  {rows.map(r => (
                    <tr key={r.symbol} className={`${styles.tableRow} ${selected === r.symbol ? styles.tableRowActive : ''}`} onClick={() => setSelected(r.symbol)}>
                      <td><span className={styles.sym}>{r.symbol}</span><span style={{ fontSize: 11, color: '#7a879e', marginLeft: 8 }}>{r.name}</span></td>
                      <td className={`${styles.right} ${styles.mono}`}>{r.shares}</td>
                      <td className={`${styles.right} ${styles.mono} ${styles.muted}`}>${fmt(r.avgCost)}</td>
                      <td className={`${styles.right} ${styles.mono}`}>{loading ? <Skeleton w={60} h={13} /> : r.q ? `$${fmt(r.q.price)}` : '—'}</td>
                      <td className={`${styles.right} ${styles.mono}`}>{loading ? <Skeleton w={60} h={13} /> : `$${fmt(r.val, 0)}`}</td>
                      <td className={`${styles.right} ${r.pl >= 0 ? styles.up : styles.down} ${styles.mono}`}>{loading ? <Skeleton w={60} h={13} /> : `${r.pl >= 0 ? '+' : ''}$${fmt(Math.abs(r.pl), 0)}`}</td>
                      <td className={`${styles.right} ${r.plP >= 0 ? styles.up : styles.down} ${styles.mono}`}>{loading ? <Skeleton w={50} h={13} /> : `${r.plP >= 0 ? '+' : ''}${fmt(r.plP)}%`}</td>
                      <td className={`${styles.right} ${styles.muted} ${styles.mono}`}>{totalVal ? `${((r.val / totalVal) * 100).toFixed(1)}%` : '—'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          <div className={styles.card}>
            <div className={styles.cardHead}>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
                <span className={styles.cardTitle}>{selected}</span>
                {quotes[selected] && <span style={{ fontSize: 18, fontWeight: 700, color: '#e2eaf5', fontFamily: 'var(--font-mono)' }}>${fmt(quotes[selected].price)}</span>}
              </div>
            </div>
            <StockChart symbol={selected} loadHistory={loadHistory} quote={quotes[selected]} height={220} />
          </div>
        </div>

        <div className={styles.rightCol}>
          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle}>By Sector</span></div>
            {Object.entries(sectorMap).map(([sector, val]) => {
              const color = SECTOR_COLORS[sector] || '#7eb8f7';
              const pct   = totalVal ? (val / totalVal) * 100 : 0;
              return (
                <div key={sector} style={{ marginBottom: 14 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 5, fontSize: 12 }}>
                    <span style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
                      <div style={{ width: 8, height: 8, borderRadius: '50%', background: color }} />
                      <span style={{ color: '#c8d4e8' }}>{sector}</span>
                    </span>
                    <span style={{ color: '#7a879e', fontFamily: 'var(--font-mono)' }}>${fmt(val, 0)} · {pct.toFixed(1)}%</span>
                  </div>
                  <div style={{ height: 4, background: 'rgba(168,181,204,0.07)', borderRadius: 2 }}>
                    <div style={{ width: `${pct}%`, height: '100%', background: color, borderRadius: 2, transition: 'width 0.8s ease' }} />
                  </div>
                </div>
              );
            })}
          </div>

          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle}>Performance Rank</span></div>
            {[...rows].sort((a, b) => b.plP - a.plP).map((r, i) => (
              <div key={r.symbol} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '8px 0', borderBottom: i < rows.length - 1 ? '1px solid rgba(168,181,204,0.05)' : 'none', cursor: 'pointer' }} onClick={() => setSelected(r.symbol)}>
                <span style={{ color: '#4a5268', fontSize: 11, width: 20, fontFamily: 'var(--font-mono)' }}>#{i + 1}</span>
                <span className={styles.sym}>{r.symbol}</span>
                <span style={{ flex: 1, fontSize: 12, color: '#7a879e' }}>{r.name}</span>
                <span className={r.plP >= 0 ? styles.up : styles.down} style={{ fontFamily: 'var(--font-mono)', fontSize: 12 }}>{loading ? '—' : `${r.plP >= 0 ? '+' : ''}${fmt(r.plP)}%`}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

/* ─── Markets Tab ──────────────────────────────────────────────────────── */
function MarketsTab({ quotes, indices, loadHistory, loading }) {
  const [selected, setSelected] = useState('AAPL');
  const gainers = Object.entries(quotes).filter(([, q]) => q.changePct > 0).sort((a, b) => b[1].changePct - a[1].changePct);
  const losers  = Object.entries(quotes).filter(([, q]) => q.changePct < 0).sort((a, b) => a[1].changePct - b[1].changePct);

  return (
    <div className={styles.tab}>
      <div className={styles.statsRow}>
        {indices.slice(0, 4).map(idx => (
          <StatCard key={idx.symbol} label={idx.name} loading={loading} value={idx.value}
            sub={`${idx.up ? '+' : ''}${fmt(idx.changePct)}%`} up={idx.up}
          />
        ))}
      </div>

      <div className={styles.mainGrid}>
        <div className={styles.leftCol}>
          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle}>Market Overview</span><span className={styles.badge}>Click to chart</span></div>
            <div className={styles.mktGrid}>
              {Object.entries(quotes).map(([sym, q]) => {
                const up = q.changePct >= 0;
                return (
                  <div key={sym} className={`${styles.mktCard} ${selected === sym ? styles.mktCardActive : ''}`} onClick={() => setSelected(sym)}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                      <span style={{ fontWeight: 700, fontSize: 14, color: '#e2eaf5' }}>{sym}</span>
                      <span className={up ? styles.up : styles.down} style={{ fontSize: 12, fontFamily: 'var(--font-mono)' }}>{up ? '+' : ''}{fmt(q.changePct)}%</span>
                    </div>
                    <div style={{ fontSize: 15, fontWeight: 600, fontFamily: 'var(--font-mono)', color: '#e2eaf5', marginBottom: 2 }}>${fmt(q.price)}</div>
                    <div style={{ fontSize: 10, color: '#4a5268' }}>{q.name}</div>
                  </div>
                );
              })}
            </div>
          </div>

          <div className={styles.card}>
            <div className={styles.cardHead}>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, flexWrap: 'wrap' }}>
                <span className={styles.cardTitle}>{selected}</span>
                {quotes[selected] && <span style={{ fontSize: 18, fontWeight: 700, color: '#e2eaf5', fontFamily: 'var(--font-mono)' }}>${fmt(quotes[selected].price)}</span>}
                {quotes[selected] && <span className={quotes[selected].changePct >= 0 ? styles.up : styles.down} style={{ fontSize: 13, fontFamily: 'var(--font-mono)' }}>{quotes[selected].changePct >= 0 ? '+' : ''}{fmt(quotes[selected].changePct)}%</span>}
              </div>
              <span style={{ fontSize: 11, color: '#4a5268', fontFamily: 'var(--font-mono)' }}>
                Vol: {fmtVol(quotes[selected]?.volume)} · Cap: {fmtK(quotes[selected]?.marketCap)}
              </span>
            </div>
            <StockChart symbol={selected} loadHistory={loadHistory} quote={quotes[selected]} height={240} />
          </div>
        </div>

        <div className={styles.rightCol}>
          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle} style={{ color: '#58e8a2' }}>▲ Top Gainers</span></div>
            {(loading ? [1,2,3,4] : gainers.slice(0, 6)).map((item, i) => loading ? (
              <div key={i} style={{ padding: '8px 0', borderBottom: '1px solid rgba(168,181,204,0.05)' }}><Skeleton h={14} /></div>
            ) : (
              <div key={item[0]} className={styles.moverRow} onClick={() => setSelected(item[0])}>
                <span className={styles.sym}>{item[0]}</span>
                <span style={{ flex: 1, fontSize: 12, color: '#7a879e', marginLeft: 8, overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis' }}>{item[1].name}</span>
                <span style={{ fontFamily: 'var(--font-mono)', fontSize: 13, color: '#e2eaf5', marginRight: 12 }}>${fmt(item[1].price)}</span>
                <span className={styles.up} style={{ fontFamily: 'var(--font-mono)', fontSize: 12 }}>+{fmt(item[1].changePct)}%</span>
              </div>
            ))}
          </div>

          <div className={styles.card}>
            <div className={styles.cardHead}><span className={styles.cardTitle} style={{ color: '#f05070' }}>▼ Top Losers</span></div>
            {(loading ? [1,2,3,4] : losers.slice(0, 6)).map((item, i) => loading ? (
              <div key={i} style={{ padding: '8px 0', borderBottom: '1px solid rgba(168,181,204,0.05)' }}><Skeleton h={14} /></div>
            ) : (
              <div key={item[0]} className={styles.moverRow} onClick={() => setSelected(item[0])}>
                <span className={styles.sym}>{item[0]}</span>
                <span style={{ flex: 1, fontSize: 12, color: '#7a879e', marginLeft: 8, overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'ellipsis' }}>{item[1].name}</span>
                <span style={{ fontFamily: 'var(--font-mono)', fontSize: 13, color: '#e2eaf5', marginRight: 12 }}>${fmt(item[1].price)}</span>
                <span className={styles.down} style={{ fontFamily: 'var(--font-mono)', fontSize: 12 }}>{fmt(item[1].changePct)}%</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

/* ─── Search Tab ───────────────────────────────────────────────────────── */
function SearchTab({ quotes, loadHistory, loading }) {
  const [query,    setQuery]    = useState('');
  const [selected, setSelected] = useState(null);

  const all      = useMemo(() => Object.entries(quotes).map(([sym, q]) => ({ sym, ...q })), [quotes]);
  const filtered = all.filter(q =>
    q.sym.toLowerCase().includes(query.toLowerCase()) ||
    (q.name || '').toLowerCase().includes(query.toLowerCase())
  );

  return (
    <div className={styles.tab}>
      <div className={styles.searchBar}>
        <span className={styles.searchIcon}>⊕</span>
        <input className={styles.searchInput}
          placeholder="Search by symbol or company name…"
          value={query} onChange={e => { setQuery(e.target.value); setSelected(null); }} autoFocus />
        {query && <button className={styles.searchClear} onClick={() => setQuery('')}>✕</button>}
      </div>

      {selected ? (
        <div className={styles.card}>
          <div className={styles.cardHead}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, flexWrap: 'wrap' }}>
              <button className={styles.backBtnInline} onClick={() => setSelected(null)}>← Back</button>
              <span className={styles.cardTitle}>{selected}</span>
              {quotes[selected] && <span style={{ fontSize: 20, fontWeight: 700, color: '#e2eaf5', fontFamily: 'var(--font-mono)' }}>${fmt(quotes[selected].price)}</span>}
              {quotes[selected] && <span className={quotes[selected].changePct >= 0 ? styles.up : styles.down} style={{ fontFamily: 'var(--font-mono)', fontSize: 14 }}>{quotes[selected].changePct >= 0 ? '+' : ''}{fmt(quotes[selected].changePct)}%</span>}
            </div>
            <div style={{ display: 'flex', gap: 16, fontSize: 12, color: '#7a879e', fontFamily: 'var(--font-mono)', flexWrap: 'wrap' }}>
              <span>Vol: {fmtVol(quotes[selected]?.volume)}</span>
              <span>Cap: {fmtK(quotes[selected]?.marketCap)}</span>
              <span>52W H: ${fmt(quotes[selected]?.week52High)}</span>
              <span>52W L: ${fmt(quotes[selected]?.week52Low)}</span>
            </div>
          </div>
          <StockChart symbol={selected} loadHistory={loadHistory} quote={quotes[selected]} height={300} />
        </div>
      ) : (
        <div className={styles.stockGrid}>
          {(filtered.length ? filtered : all).map(q => {
            const up = q.changePct >= 0;
            return (
              <div key={q.sym} className={styles.stockCard} onClick={() => setSelected(q.sym)}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 8 }}>
                  <div>
                    <div style={{ fontSize: 16, fontWeight: 800, color: '#e2eaf5', fontFamily: 'var(--font-display)' }}>{q.sym}</div>
                    <div style={{ fontSize: 11, color: '#4a5268', marginTop: 2 }}>{q.name}</div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 15, fontWeight: 600, fontFamily: 'var(--font-mono)', color: up ? '#58e8a2' : '#f05070' }}>
                      {loading ? '—' : `$${fmt(q.price)}`}
                    </div>
                    <div className={up ? styles.up : styles.down} style={{ fontSize: 12 }}>
                      {loading ? '—' : `${up ? '+' : ''}${fmt(q.changePct)}%`}
                    </div>
                  </div>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: '#4a5268', fontFamily: 'var(--font-mono)', marginTop: 8 }}>
                  <span>Vol: {fmtVol(q.volume)}</span>
                  <span>Cap: {fmtK(q.marketCap)}</span>
                  <span style={{ color: '#7eb8f7' }}>View Chart →</span>
                </div>
              </div>
            );
          })}
          {!loading && filtered.length === 0 && (
            <div style={{ gridColumn: '1/-1', textAlign: 'center', color: '#4a5268', padding: '60px 0', fontFamily: 'var(--font-mono)' }}>
              No results for "{query}"
            </div>
          )}
        </div>
      )}
    </div>
  );
}

/* ─── API Key Banner ────────────────────────────────────────────────────── */
function NoKeyBanner() {
  return (
    <div className={styles.tab}>
      <div className={styles.apiBanner}>
        <strong style={{ display: 'block', marginBottom: 8, fontSize: 14 }}>
          ⚠ Finnhub API Key Required for Live Data
        </strong>
        <ol style={{ paddingLeft: 18, marginBottom: 10 }}>
          <li>Go to <a href="https://finnhub.io" target="_blank" rel="noreferrer">finnhub.io</a> and sign up free</li>
          <li>Copy your API key from the dashboard</li>
          <li>Open <code>.env</code> in your project folder</li>
          <li>Add: <code>REACT_APP_FINNHUB_KEY=your_key_here</code></li>
          <li>Restart the app: <code>npm start</code></li>
        </ol>
        <div style={{ fontSize: 12, color: '#a8b5cc' }}>
          Free tier: 60 calls/min · Real-time US stock data · No credit card needed
        </div>
      </div>
    </div>
  );
}

/* ─── Main ─────────────────────────────────────────────────────────────── */
export default function DashboardPage() {
  const [activeTab,  setActiveTab]  = useState('dashboard');
  const [collapsed,  setCollapsed]  = useState(false);
  const [chatOpen,   setChatOpen]   = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  const { quotes, loading, error, lastUpdated, loadHistory } = useStockData();
  const { indices } = useIndexData();

  const hasKey     = !!(process.env.REACT_APP_FINNHUB_KEY);
  const tabLabels  = { dashboard: 'Dashboard', portfolio: 'Portfolio', markets: 'Markets', search: 'Search', learn: 'Investment Academy' };
  const hasData    = Object.keys(quotes).length > 0;

  return (
    <div className={styles.root}>
      <TickerTape quotes={quotes} indices={indices} />
      <div className={styles.body}>
        <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} collapsed={collapsed} setCollapsed={setCollapsed}
          indices={indices} mobileOpen={mobileOpen} setMobileOpen={setMobileOpen} />

        <div className={styles.main}>
          <header className={styles.topbar}>
            <div className={styles.topbarL}>
              <button className={styles.menuBtn} onClick={() => setMobileOpen(true)}>☰</button>
              <h1 className={styles.pageTitle}>{tabLabels[activeTab]}</h1>
              {loading && hasKey && (
                <span style={{ fontSize: 11, color: '#7eb8f7', fontFamily: 'JetBrains Mono, monospace', marginLeft: 10 }}>
                  ⟳ Loading…
                </span>
              )}
            </div>
            <div className={styles.topbarR}>
              {lastUpdated && (
                <span style={{ fontSize: 11, color: '#4a5268', fontFamily: 'JetBrains Mono, monospace', display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span style={{ width: 5, height: 5, borderRadius: '50%', background: '#58e8a2', display: 'inline-block' }} />
                  {lastUpdated.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}
                </span>
              )}
              <button className={`${styles.ariaBtn} ${chatOpen ? styles.ariaBtnActive : ''}`} onClick={() => setChatOpen(!chatOpen)}>
                <span style={{ width: 6, height: 6, borderRadius: '50%', background: '#58e8a2', flexShrink: 0 }} />
                Ask ARIA
              </button>
            </div>
          </header>

          <main className={styles.content}>
            {activeTab === 'learn' ? (
              <LearnTab />
            ) : !hasKey ? (
              <NoKeyBanner />
            ) : (
              <>
                {activeTab === 'dashboard' && <DashboardTab quotes={quotes} loadHistory={loadHistory} loading={loading} />}
                {activeTab === 'portfolio' && <PortfolioTab quotes={quotes} loadHistory={loadHistory} loading={loading} />}
                {activeTab === 'markets'   && <MarketsTab   quotes={quotes} indices={indices} loadHistory={loadHistory} loading={loading} />}
                {activeTab === 'search'    && <SearchTab    quotes={quotes} loadHistory={loadHistory} loading={loading} />}
              </>
            )}
          </main>
        </div>

        <ChatPanel open={chatOpen} onClose={() => setChatOpen(false)} quotes={quotes} />
      </div>

      <style>{`
        @keyframes skeletonShimmer { 0%{background-position:200% center} 100%{background-position:-200% center} }
      `}</style>
    </div>
  );
}
ENDFILE_SRC_PAGES_DASHBOARDPAGE_JS

cat > src/pages/DashboardPage.module.css << 'ENDFILE_SRC_PAGES_DASHBOARDPAGE_MODULE_CSS'
/* ══════════════════════════════════════════════════════
   ARIA Dashboard — Layout & Component Styles
   Fixed: sidebar overlap, allocation percentage bug,
   full responsiveness, clean card spacing
   ══════════════════════════════════════════════════════ */

/* ── Page root: full viewport, no scroll on body ── */
.root {
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden;
  background: #060810;
  color: #e2eaf5;
  font-family: 'Outfit', sans-serif;
}

/* ── Body: sidebar + main area side by side ── */
.body {
  display: flex;
  flex: 1;
  min-height: 0;      /* CRITICAL: prevents flex children from overflowing */
  overflow: hidden;
  position: relative;
}

/* ════════════════════════════
   TICKER TAPE
   ════════════════════════════ */
.ticker {
  height: 34px;
  background: #0b0e18;
  border-bottom: 1px solid rgba(168,181,204,0.08);
  overflow: hidden;
  flex-shrink: 0;
  display: flex;
  align-items: center;
}
.tickerInner {
  display: flex;
  align-items: center;
  animation: tickerScroll 60s linear infinite;
  width: max-content;
  will-change: transform;
}
@keyframes tickerScroll {
  from { transform: translateX(0); }
  to   { transform: translateX(-50%); }
}
.tickerItem {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0 20px;
  border-right: 1px solid rgba(168,181,204,0.06);
  white-space: nowrap;
}
.tickerLabel { color: #4a5268; font-size: 11px; font-family: 'JetBrains Mono', monospace; }
.tickerVal   { color: #c8d4e8; font-size: 11px; font-family: 'JetBrains Mono', monospace; }

/* ════════════════════════════
   SIDEBAR
   ════════════════════════════ */
.sidebar {
  width: 220px;
  min-width: 220px;        /* CRITICAL: prevents shrinking */
  flex-shrink: 0;
  background: #0b0e18;
  border-right: 1px solid rgba(168,181,204,0.08);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  transition: width 0.25s ease, min-width 0.25s ease;
  z-index: 10;
}
.sidebarCollapsed {
  width: 56px;
  min-width: 56px;
}

/* Logo row */
.sidebarTop {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 12px 12px;
  border-bottom: 1px solid rgba(168,181,204,0.06);
  flex-shrink: 0;
  gap: 8px;
}
.sidebarLogo {
  display: flex;
  align-items: center;
  gap: 8px;
  overflow: hidden;
  min-width: 0;
}
.logoIcon { color: #7eb8f7; font-size: 18px; flex-shrink: 0; }
.logoText {
  font-family: 'Playfair Display', serif;
  font-size: 19px;
  font-weight: 700;
  color: #e2eaf5;
  white-space: nowrap;
  overflow: hidden;
}
.collapseBtn {
  background: rgba(168,181,204,0.06);
  border: 1px solid rgba(168,181,204,0.1);
  color: #7a879e;
  border-radius: 5px;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 14px;
  flex-shrink: 0;
  transition: all 0.15s;
  line-height: 1;
  padding: 0;
}
.collapseBtn:hover { color: #e2eaf5; background: rgba(168,181,204,0.12); }

/* Nav items */
.sidebarNav {
  flex: 1;
  padding: 10px 8px 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
  overflow: hidden;
}
.navGroup {
  font-size: 9px;
  text-transform: uppercase;
  letter-spacing: 0.14em;
  color: #4a5268;
  font-family: 'JetBrains Mono', monospace;
  padding: 0 6px;
  margin: 4px 0 5px;
  white-space: nowrap;
  overflow: hidden;
}
.navItem {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 9px 8px;
  border-radius: 7px;
  border: none;
  border-left: 2px solid transparent;
  background: none;
  color: #7a879e;
  font-size: 13px;
  font-family: 'Outfit', sans-serif;
  font-weight: 500;
  cursor: pointer;
  text-align: left;
  width: 100%;
  white-space: nowrap;
  overflow: hidden;
  transition: all 0.15s;
}
.navItem:hover { color: #e2eaf5; background: rgba(168,181,204,0.05); }
.navItemActive { color: #7eb8f7 !important; background: rgba(126,184,247,0.08) !important; border-left-color: #7eb8f7; }
.navIcon { font-size: 15px; width: 18px; text-align: center; flex-shrink: 0; }

/* Sidebar indices */
.sidebarIndices {
  padding: 8px;
  border-top: 1px solid rgba(168,181,204,0.06);
}
.indexRow {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 5px 6px;
}
.indexName { font-size: 11px; color: #4a5268; font-family: 'JetBrains Mono', monospace; }

/* Sidebar footer */
.sidebarFooter {
  padding: 10px 8px;
  border-top: 1px solid rgba(168,181,204,0.06);
  flex-shrink: 0;
}
.backBtn {
  width: 100%;
  background: rgba(168,181,204,0.05);
  border: 1px solid rgba(168,181,204,0.1);
  color: #7a879e;
  border-radius: 7px;
  padding: 8px 6px;
  font-size: 12px;
  font-family: 'JetBrains Mono', monospace;
  cursor: pointer;
  transition: all 0.2s;
  text-align: left;
  white-space: nowrap;
  overflow: hidden;
}
.backBtn:hover { color: #e2eaf5; border-color: rgba(168,181,204,0.25); }

/* Mobile overlay */
.mobileOverlay {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.65);
  z-index: 55;
}

/* ════════════════════════════
   MAIN AREA
   ════════════════════════════ */
.main {
  flex: 1;
  min-width: 0;          /* CRITICAL: allow flex child to shrink below content size */
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* Chat panel open: shrink main slightly on large screens */
.mainChatOpen {
  /* chat is overlay on small screens; on large screens main stays same width */
}

/* ════════════════════════════
   TOPBAR
   ════════════════════════════ */
.topbar {
  height: 54px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  background: #060810;
  border-bottom: 1px solid rgba(168,181,204,0.08);
  flex-shrink: 0;
  gap: 10px;
}
.topbarL { display: flex; align-items: center; gap: 10px; min-width: 0; overflow: hidden; }
.topbarR { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
.menuBtn {
  display: none;
  background: none;
  border: none;
  color: #a8b5cc;
  font-size: 20px;
  cursor: pointer;
  padding: 2px 6px;
  flex-shrink: 0;
}
.pageTitle {
  font-family: 'Playfair Display', serif;
  font-size: 17px;
  font-weight: 700;
  color: #e2eaf5;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.ariaBtn {
  display: flex;
  align-items: center;
  gap: 7px;
  background: rgba(168,181,204,0.07);
  border: 1px solid rgba(168,181,204,0.14);
  border-radius: 7px;
  padding: 7px 14px;
  font-size: 13px;
  font-weight: 600;
  font-family: 'Outfit', sans-serif;
  color: #c8d4e8;
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
}
.ariaBtn:hover { border-color: rgba(168,181,204,0.28); color: #e2eaf5; }
.ariaBtnActive { background: rgba(126,184,247,0.1) !important; border-color: rgba(126,184,247,0.3) !important; color: #7eb8f7 !important; }

/* ════════════════════════════
   SCROLLABLE CONTENT
   ════════════════════════════ */
.content {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  overflow-x: hidden;
}
.content::-webkit-scrollbar { width: 4px; }
.content::-webkit-scrollbar-thumb { background: rgba(168,181,204,0.1); border-radius: 2px; }

/* ════════════════════════════
   TAB WRAPPER
   ════════════════════════════ */
.tab {
  padding: 18px 20px 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  animation: fadeUp 0.25s ease both;
}
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(6px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* ════════════════════════════
   STAT CARDS ROW
   ════════════════════════════ */
.statsRow {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}
.statCard {
  background: linear-gradient(145deg, #111520, #0b0e18);
  border: 1px solid rgba(168,181,204,0.08);
  border-radius: 12px;
  padding: 16px 18px;
  position: relative;
  overflow: hidden;
  min-width: 0;
}
.statCard::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; height: 2px;
  background: linear-gradient(90deg, rgba(126,184,247,0.3), transparent);
}
.statLabel {
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 1.1px;
  color: #4a5268;
  font-family: 'JetBrains Mono', monospace;
  margin-bottom: 7px;
}
.statValue {
  font-family: 'Playfair Display', serif;
  font-size: 22px;
  font-weight: 700;
  color: #e2eaf5;
  line-height: 1.1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.statSub {
  font-size: 11px;
  margin-top: 4px;
  font-family: 'JetBrains Mono', monospace;
  color: #7a879e;
}

/* ════════════════════════════
   MAIN CONTENT GRID
   ════════════════════════════ */
.mainGrid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 300px;
  gap: 16px;
  align-items: start;
  min-width: 0;
}
.leftCol  { display: flex; flex-direction: column; gap: 16px; min-width: 0; }
.rightCol { display: flex; flex-direction: column; gap: 16px; min-width: 0; }

/* ════════════════════════════
   CARD
   ════════════════════════════ */
.card {
  background: linear-gradient(145deg, #111520, #0b0e18);
  border: 1px solid rgba(168,181,204,0.08);
  border-radius: 12px;
  padding: 16px 18px;
  min-width: 0;
}
.cardHead {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 14px;
  flex-wrap: wrap;
}
.cardTitle {
  font-size: 14px;
  font-weight: 700;
  color: #e2eaf5;
  font-family: 'Outfit', sans-serif;
}
.badge {
  font-size: 10px;
  padding: 2px 8px;
  border-radius: 20px;
  background: rgba(88,232,162,0.07);
  border: 1px solid rgba(88,232,162,0.18);
  color: #58e8a2;
  font-family: 'JetBrains Mono', monospace;
  white-space: nowrap;
  flex-shrink: 0;
}

/* ════════════════════════════
   TABLE
   ════════════════════════════ */
.tableScroll { overflow-x: auto; }
.table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
  min-width: 500px;
}
.table th {
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #4a5268;
  font-family: 'JetBrains Mono', monospace;
  text-align: left;
  padding: 0 0 8px;
  border-bottom: 1px solid rgba(168,181,204,0.07);
  white-space: nowrap;
}
.table td {
  padding: 10px 0;
  vertical-align: middle;
  color: #c8d4e8;
  line-height: 1.3;
}
.table tr:not(:last-child) td { border-bottom: 1px solid rgba(168,181,204,0.04); }
.tableRow { cursor: pointer; transition: background 0.12s; }
.tableRow:hover td { background: rgba(168,181,204,0.03); }
.tableRowActive td { background: rgba(126,184,247,0.06) !important; }
.right { text-align: right !important; }

/* ── Symbol badge ── */
.sym {
  display: inline-block;
  background: rgba(11,14,24,0.9);
  border: 1px solid rgba(168,181,204,0.1);
  border-radius: 4px;
  padding: 1px 6px;
  font-size: 11px;
  font-weight: 700;
  color: #7eb8f7;
  font-family: 'JetBrains Mono', monospace;
  white-space: nowrap;
}

/* ── Utility classes ── */
.up    { color: #58e8a2 !important; }
.down  { color: #f05070 !important; }
.muted { color: #7a879e !important; }
.mono  { font-family: 'JetBrains Mono', monospace !important; }

/* ════════════════════════════
   ALLOCATION SECTION
   ════════════════════════════ */
.allocBar {
  display: flex;
  height: 5px;
  border-radius: 3px;
  overflow: hidden;
  gap: 2px;
  margin-bottom: 2px;
}

/* ════════════════════════════
   WATCHLIST ROWS
   ════════════════════════════ */
.watchRow {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 9px 0;
  border-bottom: 1px solid rgba(168,181,204,0.05);
  cursor: pointer;
  transition: background 0.12s;
}
.watchRow:last-child { border-bottom: none; }
.watchRow:hover { background: rgba(168,181,204,0.03); padding-left: 4px; }

/* ════════════════════════════
   MARKETS GRID
   ════════════════════════════ */
.mktGrid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  gap: 10px;
}
.mktCard {
  background: rgba(11,14,24,0.8);
  border: 1px solid rgba(168,181,204,0.07);
  border-radius: 9px;
  padding: 12px;
  cursor: pointer;
  transition: border-color 0.15s, background 0.15s;
}
.mktCard:hover { border-color: rgba(168,181,204,0.18); background: rgba(168,181,204,0.04); }
.mktCardActive { border-color: rgba(126,184,247,0.4) !important; background: rgba(126,184,247,0.06) !important; }

/* ── Movers rows ── */
.moverRow {
  display: flex;
  align-items: center;
  padding: 9px 0;
  border-bottom: 1px solid rgba(168,181,204,0.05);
  cursor: pointer;
  transition: background 0.12s;
  gap: 4px;
}
.moverRow:last-child { border-bottom: none; }
.moverRow:hover { background: rgba(168,181,204,0.03); }

/* ════════════════════════════
   SEARCH
   ════════════════════════════ */
.searchBar {
  position: relative;
  display: flex;
  align-items: center;
}
.searchIcon {
  position: absolute;
  left: 14px;
  color: #7a879e;
  font-size: 15px;
  pointer-events: none;
}
.searchInput {
  width: 100%;
  background: #111520;
  border: 1px solid rgba(168,181,204,0.1);
  border-radius: 10px;
  padding: 12px 42px 12px 44px;
  color: #e2eaf5;
  font-family: 'Outfit', sans-serif;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}
.searchInput:focus { border-color: rgba(126,184,247,0.4); }
.searchInput::placeholder { color: #4a5268; }
.searchClear {
  position: absolute;
  right: 14px;
  background: none;
  border: none;
  color: #7a879e;
  cursor: pointer;
  font-size: 13px;
  padding: 4px;
  line-height: 1;
}
.searchClear:hover { color: #e2eaf5; }
.backBtnInline {
  background: rgba(168,181,204,0.07);
  border: 1px solid rgba(168,181,204,0.14);
  color: #a8b5cc;
  border-radius: 6px;
  padding: 5px 12px;
  font-size: 12px;
  font-family: 'JetBrains Mono', monospace;
  cursor: pointer;
  transition: all 0.15s;
  flex-shrink: 0;
}
.backBtnInline:hover { color: #e2eaf5; }
.stockGrid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}
.stockCard {
  background: #111520;
  border: 1px solid rgba(168,181,204,0.08);
  border-radius: 11px;
  padding: 16px;
  cursor: pointer;
  transition: border-color 0.2s, transform 0.15s;
}
.stockCard:hover { border-color: rgba(168,181,204,0.22); transform: translateY(-1px); }

/* ════════════════════════════
   NO-KEY / ERROR BANNER
   ════════════════════════════ */
.apiBanner {
  background: rgba(240,192,96,0.07);
  border: 1px solid rgba(240,192,96,0.2);
  border-radius: 10px;
  padding: 14px 18px;
  font-size: 13px;
  color: #f0c060;
  line-height: 1.7;
}
.apiBanner code {
  background: rgba(0,0,0,0.3);
  border: 1px solid rgba(240,192,96,0.15);
  border-radius: 4px;
  padding: 1px 6px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 12px;
}
.apiBanner a { color: #7eb8f7; text-decoration: underline; }

/* ════════════════════════════
   RESPONSIVE BREAKPOINTS
   ════════════════════════════ */

/* 1200px: tighten right column */
@media (max-width: 1200px) {
  .mainGrid { grid-template-columns: minmax(0, 1fr) 270px; }
}

/* 1000px: stack to single column */
@media (max-width: 1000px) {
  .mainGrid { grid-template-columns: 1fr; }
  .rightCol { flex-direction: row; flex-wrap: wrap; }
  .rightCol > .card { flex: 1; min-width: 240px; }
  .statsRow { grid-template-columns: repeat(2, 1fr); }
  .chatPanel {
    position: fixed !important;
    right: 0; top: 0; bottom: 0;
    z-index: 200;
    max-width: 0 !important;
    min-width: 0 !important;
    box-shadow: -8px 0 32px rgba(0,0,0,0.5);
    transition: max-width 0.3s ease, min-width 0.3s ease !important;
  }
  .chatOpen {
    max-width: 360px !important;
    min-width: 320px !important;
  }
}

/* 768px: mobile sidebar */
@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    left: 0; top: 0; bottom: 0;
    transform: translateX(-100%);
    transition: transform 0.3s ease;
    z-index: 70;
    width: 220px !important;
    min-width: 220px !important;
    box-shadow: 4px 0 20px rgba(0,0,0,0.5);
  }
  .sidebarMobileOpen {
    transform: translateX(0) !important;
  }
  .mobileOverlay { display: block; }
  .menuBtn { display: block; }
  .tab { padding: 12px 14px 20px; }
}

/* 560px: single col stats, small grids */
@media (max-width: 560px) {
  .statsRow { grid-template-columns: 1fr 1fr; }
  .stockGrid { grid-template-columns: 1fr; }
  .mktGrid   { grid-template-columns: repeat(2, 1fr); }
  .rightCol  { flex-direction: column; }
  .rightCol > .card { min-width: unset; }
  .statValue { font-size: 18px; }
  .topbar    { padding: 0 12px; }
  .chatOpen  { min-width: 100% !important; max-width: 100% !important; }
}
ENDFILE_SRC_PAGES_DASHBOARDPAGE_MODULE_CSS

echo ''
echo '✅ ARIA v8 ready! Run: npm start'