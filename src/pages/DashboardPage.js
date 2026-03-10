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
