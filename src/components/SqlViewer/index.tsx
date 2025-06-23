import React, { useEffect, useState } from 'react';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { atomDark } from 'react-syntax-highlighter/dist/esm/styles/prism';
import styles from './SqlViewer.module.css';

interface SqlViewerProps {
  file: string;
  title?: string;
}

const SqlViewer: React.FC<SqlViewerProps> = ({ file, title }) => {
  const [sql, setSql] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [expanded, setExpanded] = useState(false);
  const [copied, setCopied] = useState(false);

  const filename = file.split('/').pop() || file;

  const loadSql = () => {
    setError(null);
    fetch(`/${file}`)
      .then((res) => {
        if (!res.ok) throw new Error(`No se pudo cargar el archivo: ${file}`);
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

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <strong>{title || filename}</strong>
        <div className={styles.actions}>
          <button onClick={handleCopy}>{copied ? 'Copiat' : 'Copiar'}</button>
          {isTruncated && (
            <button onClick={handleToggle}>
              {expanded ? 'Amagar linies' : 'Veure tot'}
            </button>
          )}
          <button onClick={loadSql}>Rellegir</button>
          <a
  href={`vscode://file/D:/nowtech-docs/static/${file}`}
  className={styles.vscodeButton}
  title="Abrir en Visual Studio Code"
>
<img src = "/icons/vscode.svg" height={20} width={20}/>
</a>

        </div>
      </div>
      <SyntaxHighlighter language="sql" style={atomDark} showLineNumbers>
        {expanded || !isTruncated ? sql : preview}
      </SyntaxHighlighter>
    </div>
  );
};

export default SqlViewer;
