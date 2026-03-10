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
