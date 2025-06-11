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

  const filename = file.split('\\').pop() || file.split('/').pop() || file;

  useEffect(() => {
    fetch(`/${file}`)
      .then((res) => {
        if (!res.ok) throw new Error(`No se pudo cargar el archivo: ${file}`);
        return res.text();
      })
      .then(setSql)
      .catch((err) => setError(err.message));
  }, [file]);

  const handleToggle = () => setExpanded(!expanded);

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  if (sql === null) {
    return <p>Cargando archivo SQL...</p>;
  }
  const handleCopy = () => {
 if (sql) {
 navigator.clipboard.writeText(sql);
 }
 };
  const lines = sql.split('\n');
  const preview = lines.slice(0, 10).join('\n');
  const isTruncated = lines.length > 10;

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <strong>{title || filename}</strong>
        {isTruncated && (
          <button className={styles.toggleButton} onClick={handleToggle}>
            {expanded ? 'Ocultar' : 'Mostrar todo'}
          </button>
        )}
        <button className={styles.copyButton} onClick={handleCopy}>Copiar</button>
      </div>
      <SyntaxHighlighter language="sql" style={atomDark} showLineNumbers>
        {expanded || !isTruncated ? sql : preview}
      </SyntaxHighlighter>
    </div>
  );
};

export default SqlViewer;
