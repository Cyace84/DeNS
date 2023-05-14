<template>
  <div class="demo">
    <div class="input-group">
      <label>Domain name:</label>
      <EdInput v-model="domainName" />
    </div>
    <div class="input-group">
      <label>Subdomain to register:</label>
      <EdInput v-model="subdomainName" />
    </div>
    <div class="input-group">
      <label for="inputOwner">Owner address:</label>
      <input id="inputOwner" type="text" v-model="ownerAddress" />
    </div>
    <br />
    <button @click="registerSubdomain">Register Subdomain</button>
    <pre v-if="registrationResult">Registration Status: {{ registrationResult }}</pre>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch } from "vue";
import { ProviderRpcClient, Address } from "everscale-inpage-provider";
import { DOMAIN_ABI, ROOT_ABI, ROOT_ADDRESS } from "./../../helpers";

import EdInput from "./../shared/EdInput.vue";

export default defineComponent({
  name: "SubdomainRegister",
  components: {
    EdInput,
  },
  setup() {
    const domainName = ref("yourdomain");
    const domainAddress = ref("");
    const subdomainName = ref("sub.yourdomain");
    const registrationResult = ref("");
    const ownerAddress = ref("");

    watch(domainName, newValue => {
      subdomainName.value = `sub.${newValue}`;
    });

    return { domainName, domainAddress, subdomainName, ownerAddress, registrationResult };
  },
  methods: {
    async resolveDomain(domainName: string) {
      const provider = new ProviderRpcClient();
      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

      const certificateAddr = await rootContract.methods
        .resolve({ path: domainName, answerId: 42 })
        .call({ responsible: true });

      this.domainAddress = certificateAddr.certificate.toString();
    },
    async registerSubdomain() {
      const provider = new ProviderRpcClient();
      const { accountInteraction } = await provider.requestPermissions({
        permissions: ["basic", "accountInteraction"],
      });
      const senderAddress = accountInteraction?.address;

      await this.resolveDomain(`${this.domainName}.ever`);

      const domainContract = new provider.Contract(DOMAIN_ABI, new Address(this.domainAddress));

      await domainContract.methods
        .createSubdomain({
          name: this.subdomainName,
          owner: new Address(this.ownerAddress),
          renewable: true,
        })
        .send({
          from: senderAddress!,
          amount: "3e9",
          bounce: true,
        });

      this.registrationResult = "Subdomain Registration Sent";
    },
    updateSubdomainName(event: Event) {
      const target = event.target as HTMLInputElement;
      this.subdomainName = target.textContent!;
    },
  },
});
</script>

<style scoped>
.input-group {
  position: relative;
  display: flex;
}

#inputOwner {
  min-width: 20rem;
}

.domain-extension {
  position: absolute;
  right: 5px;
  top: 0;
  bottom: 0;
  padding: 10px;
  pointer-events: none;
}
</style>
