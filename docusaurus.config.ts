import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import path from 'path';
import { remarkKroki } from 'remark-kroki';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'Documentacio',
  tagline: '',
  favicon: 'img/favicon.ico',
  trailingSlash: false,  
  // Set the production url of your site here
  url: 'https://estmi.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/nowtech-docs/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'estmi', // Usually your GitHub org/user name.
  projectName: 'nowtech-docs', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  plugins: [
    path.resolve(__dirname, './plugins/auto-image-references.js'),
  ],
  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'ca',
    locales: ['ca'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          remarkPlugins: [
            [remarkKroki, {
              server: 'https://kroki.io',
              alias: ['plantuml', 'graphviz', 'mermaid'], // alias para usar ```plantuml
              target: 'mdx3'
            }]
          ],
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/estmi/nowtech-docs/tree/master/',
        },
        blog: false /*{
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
          // Useful options to enforce blogging best practices
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        }*/,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],
  themeConfig: {
    // Replace with your project's social card
    image: 'img/docusaurus-social-card.jpg',
    docs: {
	    sidebar: {
	        hideable: true,
		autoCollapseCategories: true,
      },
    },
    navbar: {
      title: 'Documentacio',
      logo: {
        alt: '',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'nowtechSidebar',
          position: 'left',
          label: 'Nowtech',
        },
        {
          type: 'docSidebar',
          sidebarId: 'clientsSidebar',
          position: 'left',
          label: 'Clients',
        },
        {
          type: 'docSidebar',
          sidebarId: 'ahoraSidebar',
          position: 'left',
          label: 'Ahora',
        },
        //{to: '/blog', label: 'Blog', position: 'left'},
        {
          href: 'https://github.com/estmi/nowtech-docs',
          label: 'GitHub',
          position: 'right',
        },
        {
          href: 'vscode://file/D:/nowtech-docs/nowtech-docs.code-workspace',
          label: 'VSCode',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [/*
        {
          title: 'Docs',
          items: [
            {
              label: 'Tutorial',
              to: '/docs/intro',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/docusaurus',
            },
            {
              label: 'Discord',
              href: 'https://discordapp.com/invite/docusaurus',
            },
            {
              label: 'X',
              href: 'https://x.com/docusaurus',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: '/blog',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/facebook/docusaurus',
            },
          ],
        },*/
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Documentacio by Esteve Miquel, Inc. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
