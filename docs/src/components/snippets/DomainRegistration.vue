<template>
  <div class="demo">
    <div class="input-group">
      <label>Domain to register:</label>
      <EdInput v-model="domainName" />
    </div>
    <br />
    <button @click="registerDomain">Register Domain</button>
    <pre v-if="registrationResult">Registration Status: {{ registrationResult }}</pre>
  </div>
</template>
<script lang="ts">
import { defineComponent, ref } from "vue";
import { ProviderRpcClient, Address } from "everscale-inpage-provider";
import { ROOT_ABI, ROOT_ADDRESS, TIP3_WALLET_ABI, TIP3_ROOT_ABI, TIP3_ROOT_ADDRESS } from "./../../helpers";

import EdInput from "./../shared/EdInput.vue";

export default defineComponent({
  name: "DomainRegister",
  setup() {
    const domainName = ref("somedomain");
    const registrationResult = ref("");
    const duration = ref("1");

    return { domainName, registrationResult, duration };
  },
  components: {
    EdInput,
  },
  methods: {
    async registerDomain() {
      const provider = new ProviderRpcClient();
      const { accountInteraction } = await provider.requestPermissions({
        permissions: ["basic", "accountInteraction"],
      });
      const senderAddress = accountInteraction?.address;
      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

      const tokenRoot = new provider.Contract(TIP3_ROOT_ABI, TIP3_ROOT_ADDRESS);

      const { value0: twAddress } = await tokenRoot.methods
        .walletOf({
          answerId: 42,
          walletOwner: senderAddress!,
        })
        .call({ responsible: true });

      const tokenWallet = new provider.Contract(TIP3_WALLET_ABI, twAddress);

      // Get registration price
      const registrationPrice = await rootContract.methods
        .expectedRegisterAmount({
          name: this.domainName,
          duration: 60 * 60 * 24 * 365 * parseInt(this.duration),
          answerId: 22,
        })
        .call({ responsible: true });

      // Build registration payload
      const registrationPayload = await rootContract.methods
        .buildRegisterPayload({ name: this.domainName, answerId: 42 })
        .call({ responsible: true });

      await tokenWallet.methods
        .transfer({
          amount: registrationPrice.amount,
          recipient: rootContract.address,
          deployWalletValue: 0,
          remainingGasTo: senderAddress!,
          notify: true,
          payload: registrationPayload.payload,
        })
        .send({
          from: senderAddress!,
          amount: String(3 * 10 ** 9),
          bounce: true,
        });
    },
    updateDomainName(event: Event) {
      const target = event.target as HTMLInputElement;
      this.domainName = target.textContent!;
    },
  },
});
</script>
<style scoped>
.input-group {
  position: relative;
  display: flex;
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
