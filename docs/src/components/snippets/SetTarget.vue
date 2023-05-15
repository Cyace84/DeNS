<template>
  <div class="demo">
    <div class="input-group">
      <label for="domainAddress">Domain Address:</label>
      <EdInput v-model="domainName" />
    </div>
    <div>
      <label for="targetAddress">Target Address:</label>
      <input id="targetAddress" type="text" v-model="targetAddress" />
    </div>
    <button @click="setTarget">Set Target Address</button>
    <pre v-if="transactionResult">Transaction Status: {{ transactionResult }}</pre>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { ProviderRpcClient, Address } from "everscale-inpage-provider";
import { DOMAIN_ABI, ROOT_ABI, ROOT_ADDRESS } from "./../../helpers";
import EdInput from "../shared/EdInput.vue";

export default defineComponent({
  name: "SetTarget",
  setup() {
    const domainName = ref("yourdomain");
    const targetAddress = ref("");
    const transactionResult = ref("");

    return { domainName, targetAddress, transactionResult };
  },
  components: {
    EdInput,
  },
  methods: {
    async setTarget() {
      const provider = new ProviderRpcClient();
      const { accountInteraction } = await provider.requestPermissions({
        permissions: ["basic", "accountInteraction"],
      });

      const senderAddress = accountInteraction?.address!;
      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

      const certificateAddr = await rootContract.methods
        .resolve({ path: this.domainName + ".ever", answerId: 42 })
        .call({ responsible: true });

      const domainContract = new provider.Contract(DOMAIN_ABI, certificateAddr.certificate);
      console.log(certificateAddr.certificate.toString());
      const setTargetTransaction = await provider.sendMessage({
        sender: senderAddress,
        recipient: certificateAddr.certificate,
        amount: String(1e9),
        bounce: true,
        payload: {
          abi: JSON.stringify(DOMAIN_ABI),
          method: "setTarget",
          params: {
            target: new Address(this.targetAddress),
          },
        },
      });
      // const setTargetTransaction = await domainContract.methods
      //   .setTarget({ target: new Address(this.targetAddress) })
      //   .send({ from: senderAddress, amount: String(1e9), bounce: true });

      this.transactionResult = JSON.stringify(setTargetTransaction, null, 2);
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
