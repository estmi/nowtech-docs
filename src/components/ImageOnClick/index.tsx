import React, { useState, ReactNode } from 'react';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './styles.module.css';
  // Define the type for props passed to the ImageOnClick component.
interface ImageOnClickProps {
  imageUrl: string;   // URL of the image
  altText: string;    // Alternative text for the image
  children: ReactNode; // Content inside the tag (button text, icons, etc.)
}

const ImageOnClick: React.FC<ImageOnClickProps> = ({ imageUrl, altText, children }) => {
  const [showImg, setShowImg] = useState(false);
  const generatedImageUrl = useBaseUrl(imageUrl);

  return (
    <span>
      {/* Button to toggle visibility of the image */}
      <a onClick={() => setShowImg(!showImg)} className={styles.cursor}>
        {children}
      </a>
      {/* Conditionally render the image */}
      {showImg && (
        <span className={styles.imageonclick}>
          <img src={generatedImageUrl} alt={altText} />
        </span>
      )}
    </span>
  );
};
  {/* Export the ImageOnClick component */}
  export default ImageOnClick;