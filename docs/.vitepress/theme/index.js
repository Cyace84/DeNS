import "./style.css";

import DefaultTheme from "vitepress/theme";
import Layout from "./Layout.vue";
import EdInput from "./../../src/components/shared/EdInput.vue";
import DnsResolver from "./../../src/components/snippets/DnsResolver.vue";

import GetRegistrationPrice from "./../../src/components/snippets/GetRegistrationPrice.vue";
import DomainRegistration from "./../../src/components/snippets/DomainRegistration.vue";
import SetTarget from "./../../src/components/snippets/SetTarget.vue";
import SubdomainRegistration from "./../../src/components/snippets/SubdomainRegistration.vue";

export default {
  ...DefaultTheme,
  enhanceApp({ app }) {
    DefaultTheme.enhanceApp({ app });
    app.component("Layout", Layout);
    app.component("EdInput", EdInput);
    app.component("DnsResolver", DnsResolver);
    app.component("GetRegistrationPrice", GetRegistrationPrice);
    app.component("DomainRegistration", DomainRegistration);
    app.component("SetTarget", SetTarget);
    app.component("SubdomainRegistration", SubdomainRegistration);
  },
};
