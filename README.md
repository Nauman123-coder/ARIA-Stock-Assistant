<div align="center">

# ARIA — AI Stock Market Assistant

### *Institutional-grade portfolio intelligence, powered by AI*

![React](https://img.shields.io/badge/React-18.2-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![JavaScript](https://img.shields.io/badge/JavaScript-ES2024-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Groq](https://img.shields.io/badge/Groq-LLM-F55036?style=for-the-badge&logo=groq&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-Deployed-000000?style=for-the-badge&logo=vercel&logoColor=white)
![CSS Modules](https://img.shields.io/badge/CSS_Modules-Styled-000000?style=for-the-badge&logo=cssmodules&logoColor=white)
![Recharts](https://img.shields.io/badge/Recharts-Charts-22B5BF?style=for-the-badge&logo=chartdotjs&logoColor=white)

[![Live Demo](https://img.shields.io/badge/🚀_Live_Demo-aria--stock--assistant.vercel.app-7eb8f7?style=for-the-badge)](https://aria-stock-assistant.vercel.app)
[![GitHub Stars](https://img.shields.io/github/stars/Nauman123-coder/ARIA-Stock-Assistant?style=for-the-badge&color=f0c060)](https://github.com/Nauman123-coder/ARIA-Stock-Assistant)

</div>

---

<div align="center">
  <img src="public/images/image1.png" alt="ARIA Dashboard" width="80%" style="border-radius:12px; margin: 20px 0;" />
</div>

---

## 📖 Overview

**ARIA** (Advanced Real-time Investment Assistant) is a full-stack AI-powered stock market platform that brings institutional-grade financial analysis to every investor. Ask questions in plain English, get real-time market data, explore interactive charts with AI forecasting, track your portfolio's risk, and learn investing from scratch — all in one sleek interface.

Built with **React 18**, streamed via **Groq's ultra-fast LLM API**, and deployed on **Vercel** with serverless Yahoo Finance proxying for live historical chart data.

> *"The analytical power of a full research team — at a fraction of the cost."*

---

## ✨ Features

### 🤖 AI Chat Assistant
- Conversational AI powered by **Groq's `llama-3.1-8b-instant`** model — responds in under a second
- Has full awareness of your live portfolio: holdings, cost basis, unrealized P&L, sector allocation
- DOM-write streaming architecture — **zero React re-renders** during streaming, zero browser freeze
- Ask anything: risk analysis, stock comparisons, buy/sell verdicts, macro commentary
- Maintains full conversation history within the session

### 📈 Interactive Stock Charts
- Historical price data via **Yahoo Finance v8 API**, proxied through a Vercel serverless function
- **6 time periods**: 1W · 1M · 3M · 6M · 1Y · 2Y
- **AI Forecast toggle**: 30-day linear regression projection with volatility confidence band
- **Volume overlay**: bar chart beneath price for accumulation/distribution analysis
- Full **OHLCV tooltip** on every candle, plus period stats bar (high, low, avg, % return)

### 💼 Portfolio Analytics
- Real-time P&L across all holdings using live Finnhub quotes
- **Sector allocation donut chart** — updates as prices move
- Performance ranking bar chart — see winners and losers at a glance
- AI-powered risk concentration analysis on demand

### 📡 Live Market Data
- Live quotes from **Finnhub's institutional-grade API** — auto-refreshes every 2 minutes
- Scrolling **ticker tape** across the top of the entire app
- Tracks **S&P 500, NASDAQ, DOW, and VIX** index cards in real time
- 10-stock market overview grid with color-coded % change indicators

### 🔍 Stock Search
- Search any of 15,000+ symbols and ETFs
- Click any result to load its full interactive chart instantly
- **Top Gainers** and **Top Losers** auto-ranked on every data refresh

### 🎓 Investment Academy
- **30 structured lessons** across 6 learning tracks:
  - 🏛️ Market Fundamentals · 📊 Fundamental Analysis · 📈 Technical Analysis
  - 🎯 Investment Strategies · 🛡️ Risk Management · ⚡ Advanced Concepts
- Lessons stream **live word-by-word** — like a senior analyst briefing you in real time
- **5-question AI quiz** after every lesson with full answer explanations
- Progress tracking across all 30 lessons with completion percentage
- Ask any **custom topic** not in the curriculum

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | React 18 + React Router v6 | SPA with client-side routing |
| **Styling** | CSS Modules | Scoped, component-level styles |
| **AI / LLM** | Groq API (`llama-3.1-8b-instant`) | Ultra-fast streaming chat responses |
| **Charts** | Recharts | Interactive ComposedChart with forecasting |
| **Live Quotes** | Finnhub API | Real-time stock prices (free tier) |
| **Chart History** | Yahoo Finance v8 | Historical OHLCV candle data |
| **Proxy** | Vercel Serverless (`/api/yahoo.js`) | Bypasses Yahoo Finance CORS/403 |
| **Deployment** | Vercel | Auto-deploy on every `git push` |
| **Fonts** | Playfair Display · Outfit · JetBrains Mono | Typography system |

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** v16 or higher
- A free **Groq API key** → [console.groq.com](https://console.groq.com)
- A free **Finnhub API key** → [finnhub.io](https://finnhub.io)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Nauman123-coder/ARIA-Stock-Assistant.git
cd ARIA-Stock-Assistant

# 2. Run the setup script (creates all source files)
bash setup.sh

# 3. Install dependencies
npm install

# 4. Add your API keys to .env
```

### Environment Variables

Create a `.env` file in the project root:

```env
REACT_APP_GROQ_API_KEY=your_groq_api_key_here
REACT_APP_FINNHUB_KEY=your_finnhub_api_key_here
```

> ⚠️ **Never commit your `.env` file.** It is already listed in `.gitignore`.

### Run Locally

```bash
npm start
# App runs at http://localhost:3000
```

---

## 📁 Project Structure

```
ARIA-Stock-Assistant/
├── api/
│   └── yahoo.js                  # Vercel serverless — Yahoo Finance proxy
├── public/
│   └── images/                   # Feature screenshots (image1.png – image6.png)
├── src/
│   ├── components/
│   │   ├── ChatPanel.js          # DOM-write streaming chat UI
│   │   ├── MarkdownMessage.js    # Rich markdown renderer
│   │   ├── StockChart.js         # Interactive Recharts chart + AI forecast
│   │   ├── MiniChart.js          # Sparkline chart for watchlist
│   │   ├── DonutChart.js         # Sector allocation donut
│   │   ├── LearnTab.js           # Investment Academy — 30 lessons + quiz
│   │   └── TickerTape.js         # Live scrolling ticker tape
│   ├── hooks/
│   │   ├── useGroqChat.js        # Groq streaming chat — zero-render architecture
│   │   └── useStockData.js       # Finnhub quotes + Yahoo Finance history
│   ├── pages/
│   │   ├── LandingPage.js        # Marketing homepage
│   │   ├── LandingPage.module.css
│   │   ├── DashboardPage.js      # Main 5-tab app dashboard
│   │   └── DashboardPage.module.css
│   ├── utils/
│   │   └── data.js               # Shared constants and helpers
│   ├── App.js                    # Router setup
│   ├── index.js                  # React entry point
│   └── index.css                 # Global styles + CSS variables
├── .env                          # API keys (not committed)
├── .gitignore
└── package.json
```

---

## 🌐 Deployment on Vercel

ARIA is configured for zero-config deployment on Vercel.

### One-Click Deploy

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/Nauman123-coder/ARIA-Stock-Assistant)

### Manual Deploy

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod
```

### Required Environment Variables on Vercel

Go to **Project Settings → Environment Variables** and add:

| Variable | Value |
|----------|-------|
| `REACT_APP_GROQ_API_KEY` | Your Groq API key |
| `REACT_APP_FINNHUB_KEY` | Your Finnhub API key |

> The `api/yahoo.js` serverless function is automatically picked up by Vercel — no configuration needed.

---

## 🏗️ Architecture Highlights

### Zero-Render Streaming
The chat system uses a **DOM-write architecture** to prevent browser freeze during AI streaming:
- `insertAdjacentText()` writes tokens directly to a DOM node — React is never involved
- `setMessages()` is called **exactly twice** per response: once to add the placeholder, once to finalize
- A `setTimeout(0)` yield every 8 chunks hands the main thread back to the browser

### Yahoo Finance Proxy
A Vercel serverless function at `/api/yahoo` proxies all chart requests server-side:
- Mimics a real browser `User-Agent` so Yahoo serves the data
- Tries `query1` then falls back to `query2` automatically
- Responses are **CDN-cached for 5 minutes** via `Cache-Control: s-maxage=300`

### Stable History Cache
Chart history is cached in a `useRef` (not `useState`) to prevent the infinite reload loop:
- Writing to a ref never triggers re-renders
- `loadHistory` has an empty dependency array — always a stable reference
- Cache key is `symbol-period` (e.g., `AAPL-3M`)

---

## 📊 Dashboard Tabs

| Tab | Description |
|-----|-------------|
| **Dashboard** | Portfolio overview, holdings table, sector donut, watchlist, AI chart |
| **Portfolio** | Full P&L breakdown, sector allocation, performance ranking |
| **Markets** | 10-stock live grid, index cards, top gainers & losers |
| **Search** | Search any symbol, load chart, get AI commentary |
| **Learn** | Investment Academy — 30 AI-streamed lessons with quizzes |

---

## 🔑 API Keys & Limits

| API | Free Tier Limit | Used For |
|-----|----------------|---------|
| **Groq** | 14,400 requests/day | AI chat responses |
| **Finnhub** | 60 calls/minute | Live stock quotes |
| **Yahoo Finance** | Unlimited (proxied) | Historical chart data |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome.

```bash
# Fork the repo, then:
git checkout -b feature/your-feature-name
git commit -m "Add: your feature description"
git push origin feature/your-feature-name
# Open a Pull Request
```


## 👨‍💻 Author

**Nauman** · [@Nauman123-coder](https://github.com/Nauman123-coder)

---

<div align="center">

*Built with ◈ ARIA — where AI meets the market*

⭐ **Star this repo** if you found it useful!

</div>
