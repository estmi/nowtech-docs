import React, { useEffect, useState } from 'react';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { atomDark, vs } from 'react-syntax-highlighter/dist/esm/styles/prism';
import styles from './SqlViewer.module.css';
import { useColorMode } from '@docusaurus/theme-common';

interface SqlViewerProps {
  file: string;
  title?: string;
  baseUrl?: string;
}

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

const SqlViewer: React.FC<SqlViewerProps> = ({ file, title,baseUrl }) => {
  const [sql, setSql] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [expanded, setExpanded] = useState(false);
  const [copied, setCopied] = useState(false);
  if (baseUrl === null || baseUrl == undefined ) baseUrl = 'clients/';
  if (baseUrl === '/') baseUrl = '';
  const filename = file.split('/').pop().split('\\').pop().split('.')[0] || file;
  const language = getLanguageFromFile(filename);
  const loadSql = () => {
    setError(null);
    fetch(`/${baseUrl}${file}`)
      .then((res) => {
        if (!res.ok) 
          throw new Error(`No se pudo cargar el archivo: /${baseUrl}${file}`);
        return res.text();
      })
      .then(setSql)
      .catch((err) => setError(err.message));
  };

  useEffect(() => {
    loadSql();
  }, [file]);

  const handleCopy = () => {
    if (sql) {
      navigator.clipboard.writeText(sql);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const handleToggle = () => setExpanded(!expanded);

  if (error) return <p style={{ color: 'red' }}>{error}</p>;
  if (sql === null) return <p>Cargando archivo SQL...</p>;

  const lines = sql.split('\n');
  const preview = lines.slice(0, 10).join('\n')+'\n    << Mostrar mes linies >>';
  const isTruncated = lines.length > 10;
  const { colorMode } = useColorMode();
  const syntaxStyle = colorMode === 'dark' ? atomDark : vs;
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <strong>{title || filename}</strong>
        <div className={styles.actions}>
          <button onClick={handleCopy}>{copied ? 'Copiat' :  'Copiar'}</button>
          {isTruncated && (
            <button onClick={handleToggle}>
              {expanded ? 'Amagar linies' : 'Veure tot'}
            </button>
          )}
          <button onClick={loadSql}>Rellegir</button>
          <a
  href={`vscode://file/D:/nowtech-docs/static/${baseUrl}${file}`}
  className={styles.vscodeButton}
  title="Abrir en Visual Studio Code"
>
<img src = "/img/vscode.svg" height={20} width={20}/>
</a>

        </div>
      </div>
      <SyntaxHighlighter language={language} style={syntaxStyle} showLineNumbers>
        {expanded || !isTruncated ? sql : preview}
      </SyntaxHighlighter>
    </div>
  );
};

export default SqlViewer;
