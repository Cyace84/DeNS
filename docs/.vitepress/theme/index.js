import "./style.css";

import DefaultTheme from "vitepress/theme";
import Layout from "./Layout.vue";

export default {
  ...DefaultTheme,
  enhanceApp({ app }) {
    DefaultTheme.enhanceApp({ app });
    app.component("Layout", Layout);
  },
};
