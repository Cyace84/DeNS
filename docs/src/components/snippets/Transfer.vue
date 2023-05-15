<template>
  <div class="demo">
    <div class="input-group">
      <label for="domainName">Domain Name:</label>
      <EdInput v-model="domainName" @input="resolveDomain" />
    </div>
    <div>
      <label for="newAddress">New Address:</label>
      <input id="newAddress" type="text" v-model="newAddress" />
    </div>
    <button @click="transferDomain">Transfer Domain</button>
    <pre v-if="transactionResult">Transaction Status: {{ transactionResult }}</pre>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { Address, ProviderRpcClient } from "everscale-inpage-provider";
import { DOMAIN_ABI, ROOT_ABI, ROOT_ADDRESS } from "./../../helpers";
import EdInput from "../shared/EdInput.vue";

export default defineComponent({
  name: "TransferDomain",
  setup() {
    const domainName = ref("");
    const domainAddress = ref("");
    const newAddress = ref("");
    const transactionResult = ref("");

    return { domainName, domainAddress, newAddress, transactionResult };
  },
  components: {
    EdInput,
  },
  methods: {
    async resolveDomain() {
      const provider = new ProviderRpcClient();
      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

      const certificateAddr = await rootContract.methods
        .resolve({ path: this.domainName + ".ever", answerId: 42 })
        .call({ responsible: true });

      this.domainAddress = certificateAddr.certificate.toString();
    },
    async transferDomain() {
      if (!this.domainAddress) {
        this.transactionResult = "Please enter a valid domain name.";
        return;
      }

      const provider = new ProviderRpcClient();
      const { accountInteraction } = await provider.requestPermissions({
        permissions: ["basic", "accountInteraction"],
      });

      const sender = accountInteraction?.address!;
      const domainContract = new provider.Contract(DOMAIN_ABI, new Address(this.domainAddress));

      const transferTransaction = await domainContract.methods
        .transfer({ to: new Address(this.newAddress), sendGasTo: sender, callbacks: [] })
        .send({ from: sender, amount: String(1e9), bounce: true });

      this.transactionResult = JSON.stringify(transferTransaction, null, 2);
    },
  },
});
</script>

<style scoped>
.demo {
  margin-bottom: 1rem;
}
.input-group {
  position: relative;
  display: flex;
}
</style>
