
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
  
  const filename = file.split('/').pop() || file;

  useEffect(() => {
    fetch(`/${file}`)
      .then((res) => {
        if (!res.ok) throw new Error(`No se pudo cargar el archivo: ${file}`);
        return res.text();
      })
      .then(setSql)
      .catch((err) => setError(err.message));
  }, [file]);

 const handleCopy = () => {
 if (sql) {
 navigator.clipboard.writeText(sql);
 }
 };

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  if (sql === null) {
    return <p>Cargando archivo SQL...</p>;
  }

  return (
    <div className={styles.sqlContainer}>
      <div className={styles.header}>
        <span className={styles.title}>{title || filename}</span>
        <button className={styles.copyButton} onClick={handleCopy}>Copiar</button>
      </div>
      <SyntaxHighlighter language="sql" style={atomDark} showLineNumbers>
        {sql}
      </SyntaxHighlighter>
    </div>
  );
};

export default SqlViewer;
