  import React from 'react';
  // Importing the original mapper + our components according to the Docusaurus doc
  import MDXComponents from '@theme-original/MDXComponents';
  import Button from '@site/src/components/Button';
  import Columns from '@site/src/components/Columns';
  import Column from '@site/src/components/Column';
  import ImageOnClick from '@site/src/components/ImageOnClick';
  import SqlViewer from '@site/src/components/SqlViewer';
  export default {
    // Reusing the default mapping
    ...MDXComponents,
    Button,
    Columns,
    Column,
    ImageOnClick,
    SqlViewer,
  };
