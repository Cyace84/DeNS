import "./style.css";

import DefaultTheme from "vitepress/theme";
//import Header from "./../../src/components/Header.vue";
import Layout from "./Layout.vue";
import DisconnectIcon from "./../../src/components/shared/DisconnectIcon.vue";
import EdInput from "./../../src/components/shared/EdInput.vue";
import DnsResolver from "./../../src/components/snippets/DnsResolver.vue";

import GetRegistrationPrice from "./../../src/components/snippets/GetRegistrationPrice.vue";
import DomainRegistration from "./../../src/components/snippets/DomainRegistration.vue";
import SetTarget from "./../../src/components/snippets/SetTarget.vue";
import SubdomainRegistration from "./../../src/components/snippets/SubdomainRegistration.vue";
import ChangeOwner from "./../../src/components/snippets/ChangeOwner.vue";
import ChangeManager from "./../../src/components/snippets/ChangeManager.vue";
import Transfer from "./../../src/components/snippets/Transfer.vue";

export default {
  ...DefaultTheme,
  Layout: Layout,
  enhanceApp({ app }) {
    DefaultTheme.enhanceApp({ app });

    app.component("Layout", Layout);
    app.component("DisconnectIcon", DisconnectIcon);

    app.component("EdInput", EdInput);
    app.component("DnsResolver", DnsResolver);
    app.component("GetRegistrationPrice", GetRegistrationPrice);
    app.component("DomainRegistration", DomainRegistration);
    app.component("SetTarget", SetTarget);
    app.component("SubdomainRegistration", SubdomainRegistration);
    app.component("ChangeOwner", ChangeOwner);
    app.component("ChangeManager", ChangeManager);
    app.component("Transfer", Transfer);
  },
};
