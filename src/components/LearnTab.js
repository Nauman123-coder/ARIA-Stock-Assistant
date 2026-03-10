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
