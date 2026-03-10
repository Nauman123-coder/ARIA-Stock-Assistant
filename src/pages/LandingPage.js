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
