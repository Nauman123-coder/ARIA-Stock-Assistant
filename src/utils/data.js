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
