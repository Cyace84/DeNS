import vue from "@vitejs/plugin-vue";
import { resolve } from "path";
//import typescript from "@rollup/plugin-typescript";

import nodeExternals from "vite-plugin-node-externals";

import dotenv from "dotenv";

dotenv.config({ path: resolve(__dirname, "./../", ".env") });

const env = process.env;

const HELP_URL = env.HELP_URL || "";
const FEEDBACK_URL = env.FEEDBACK_URL || "";

const flexSearchIndexOptions = {
  preset: "default",
  tokenize: "strict",
  cache: true,
  resolution: 9,
  context: false,
  optimize: true,
};

var options = {
  ...flexSearchIndexOptions,
  previewLength: 62,
  buttonLabel: "Search",
  placeholder: "Search docs",
  allow: [],
  ignore: [],
};

module.exports = {
  title: "DeNs",
  base: "",
  description: "",
  // head: [
  //   [
  //     'script',
  //     {
  //       async: true,
  //       src: 'https://www.googletagmanager.com/gtag/js?id=',
  //     },
  //   ],
  //   [
  //     'script',
  //     {},
  //     "window.dataLayer = window.dataLayer || [];\nfunction gtag(){dataLayer.push(arguments);}\ngtag('js', new Date());\ngtag('config', 'G-');",
  //   ],
  // ],
  plugins: [
    vue(),
    // typescript(),

    nodeExternals({
      allowList: ["vue"],
    }),
  ],
  themeConfig: {
    search: {
      provider: "local",
    },
    nav: [
      { text: "Feedback", link: `${FEEDBACK_URL}` },
      { text: "Community", link: `${HELP_URL}` },
    ],
    sidebar: [
      { text: "Introduction", link: "/" },
      { text: "Architecture", link: "/src/pages/architecture" },
      { text: "Smart Contracts", link: "/src/pages/contracts" },
      { text: "Interfaces", link: "/src/pages/interfaces" },
      // {
      //   text: "Guide",
      //   collapsable: false,
      //   items: [{ text: "Introduction", link: "/src/pages/2-Introduction" }],
      // },
    ],

    socialLinks: [{ icon: "github", link: "https://github.com/tonred/DeNS" }],
  },

  esbuild: {
    target: ["chrome89", "edge89", "firefox79", "safari14.1"],
  },
};
