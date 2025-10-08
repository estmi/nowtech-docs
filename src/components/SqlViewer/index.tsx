import React, { useEffect, useState } from 'react';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { atomDark, duotoneLight } from 'react-syntax-highlighter/dist/esm/styles/prism';
import { useColorMode } from '@docusaurus/theme-common';
import { motion, AnimatePresence } from 'framer-motion';
import styles from './SqlViewer.module.css';

interface CodeViewerProps {
  file: string;
  title?: string;
  baseUrl?: string;
}

// Detect syntax language from file extension
const getLanguageFromFile = (filename: string): string => {
  const ext = filename.split('.').pop()?.toLowerCase();
  switch (ext) {
    case 'sql': return 'sql';
    case 'js': return 'javascript';
    case 'ts': return 'typescript';
    case 'json': return 'json';
    case 'py': return 'python';
    case 'java': return 'java';
    case 'html': return 'html';
    case 'css': return 'css';
    case 'sh': return 'bash';
    case 'yml':
    case 'yaml': return 'yaml';
    default: return 'text';
  }
};

const SqlViewer: React.FC<CodeViewerProps> = ({ file, title, baseUrl }) => {
  const [content, setContent] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [expanded, setExpanded] = useState(false);
  const [copied, setCopied] = useState(false);

  const { colorMode } = useColorMode();
  const syntaxStyle = colorMode === 'dark' ? atomDark : duotoneLight;

  if (!baseUrl) baseUrl = 'clients/';
  if (baseUrl === '/') baseUrl = '';

  const filename = file.split('/').pop()?.split('\\').pop() || file;
  const language = getLanguageFromFile(filename);
  const storageKey = `SqlViewer_${file}_expanded`;

  // 🔹 Load expanded/collapsed state from localStorage
  useEffect(() => {
    const saved = localStorage.getItem(storageKey);
    if (saved === 'true') setExpanded(true);
  }, [storageKey]);

  const loadFile = () => {
    setError(null);
    fetch(`/${baseUrl}${file}`)
      .then((res) => {
        if (!res.ok) throw new Error(`No se pudo cargar el archivo: /${baseUrl}${file}`);
        return res.text();
      })
      .then(setContent)
      .catch((err) => setError(err.message));
  };

  useEffect(() => {
    loadFile();
  }, [file]);

  const handleCopy = () => {
    if (content) {
      navigator.clipboard.writeText(content);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  // 🔹 Toggle expanded state and save to localStorage
  const handleToggle = () => {
    const newState = !expanded;
    setExpanded(newState);
    localStorage.setItem(storageKey, newState.toString());
  };

  if (error) return <p style={{ color: 'red' }}>{error}</p>;
  if (content === null) return <p>Cargando archivo...</p>;

  const lines = content.split('\n');
  const preview = lines.slice(0, 10).join('\n') + '\n    << Mostrar més línies >>';
  const isTruncated = lines.length > 10;
  const displayText = expanded || !isTruncated ? content : preview;

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <strong>{title || filename}</strong>
        <div className={styles.actions}>
          <button onClick={handleCopy}>{copied ? 'Copiat' : 'Copiar'}</button>
          {isTruncated && (
            <button onClick={handleToggle}>
              {expanded ? 'Amagar línies' : 'Veure tot'}
            </button>
          )}
          <button onClick={loadFile}>Rellegir</button>
          <a
            href={`vscode://file/D:/nowtech-docs/static/${baseUrl}${file}`}
            className={styles.vscodeButton}
            title="Abrir en Visual Studio Code"
          >
            <img src="/img/vscode.svg" height={20} width={20} />
          </a>
        </div>
      </div>

      {/* 🔹 Smooth fade + height animation on theme or expand change */}
      <AnimatePresence mode="wait">
        <motion.div
          key={`${colorMode}-${expanded}`}
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto' }}
          exit={{ opacity: 0, height: 0 }}
          transition={{ duration: 0.4, ease: 'easeInOut' }}
        >
          <SyntaxHighlighter language={language} style={syntaxStyle} showLineNumbers>
            {displayText}
          </SyntaxHighlighter>
        </motion.div>
      </AnimatePresence>
    </div>
  );
};

export default SqlViewer;
