import vue from "@vitejs/plugin-vue";
import { resolve } from "path";
//import typescript from "@rollup/plugin-typescript";
import Components from "unplugin-vue-components/vite";
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
  title: "DeNS Documentation",
  base: "",
  description: "Decentralized Name Service",
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
    Components({ dst: true }),
    // typescript(),

    nodeExternals({
      allowList: ["vue"],
    }),
  ],
  //theme: require("./theme"),
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
      {
        text: "Guide",
        collapsable: false,
        items: [
          //{ text: "Introduction", link: "/src/pages/guides/index" },
          { text: "Working with DeNS", link: "/src/pages/guides/working_with_dens" },
          { text: "Resolving names", link: "/src/pages/guides/resolving_names" },
          { text: "Domain registration", link: "/src/pages/guides/domain_registration" },
          { text: "Subdomain registration", link: "/src/pages/guides/subdomain_registration" },
          {
            text: "Changing Domain/Subdomain Ownership and Management",
            link: "/src/pages/guides/transfer_ownership",
          },
          //{ text: "Associating domain with address", link: "/src/pages/guides/associating_address_with_domain" },
        ],
      },
    ],

    socialLinks: [{ icon: "github", link: "https://github.com/tonred/DeNS" }],
  },

  esbuild: {
    target: ["chrome89", "edge89", "firefox79", "safari14.1"],
  },
};
