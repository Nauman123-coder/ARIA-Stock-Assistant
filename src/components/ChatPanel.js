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
