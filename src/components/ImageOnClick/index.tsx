  // Import React and the useState hook, used to manage the visibility of the image.
  import React, { useState } from 'react';
  // Import clsx library for conditional classes.
  import clsx from 'clsx';
  // Import the useBaseUrl function from Docusaurus.
  import useBaseUrl from '@docusaurus/useBaseUrl';
  // Import styles from SCSS module.
  import styles from './styles.module.css';
  // Define the type for props passed to the ImageOnClick component.
  interface ImageOnClickProps {
    imageUrl: string; // URL of the image
    altText: string; // Alternative text for the image
    buttonName: string; // Name of the button to show/hide the image
  }
  // Define the ImageOnClick component as a functional component.
  const ImageOnClick: React.FC<ImageOnClickProps> = ({ imageUrl, altText, buttonName }) => {
    // State to track whether image should be shown or hidden.
    const [showImg, setShowImg] = useState(false);
    // Use the useBaseUrl function to generate the image URL.
    const generatedImageUrl = useBaseUrl(imageUrl);

    return (
      <span>
        {/* Button to toggle visibility of the image */}
        <a onClick={() => setShowImg(!showImg)} className={styles.cursor}>
          {buttonName}  
        </a>
        {/* Conditionally render the image if showImg is true */}
        {showImg && (
          <span className={styles.imageonclick}>
            {/* Image element */}
            <img src={generatedImageUrl} alt={altText} /> 
          </span>
        )}
      </span>
    );
  }
  {/* Export the ImageOnClick component */}
  export default ImageOnClick;