<template>
  <div class="demo">
    <div>
      <label for="domainToResolve">Domain to resolve:</label>
      <input id="domainToResolve" type="text" v-model="domainToResolve" />
    </div>
    <button @click="resolveDomain">Resolve Domain</button>
    <pre v-if="resolveResult">Domain Address: {{ resolveResult }}</pre>
    <pre v-if="targetAddress">Target Account address: {{ targetAddress }}</pre>
    <pre v-if="error">Domain not exist </pre>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { Address, ProviderRpcClient } from "everscale-inpage-provider";
import { ROOT_ABI, ROOT_ADDRESS, DOMAIN_ABI } from "./../../helpers";

export default defineComponent({
  name: "DnsResolver",
  setup() {
    const domainToResolve = ref("username.ever");
    const targetAddress = ref("");
    const resolveResult = ref("");
    const error = ref("");

    return { domainToResolve, targetAddress, resolveResult, error };
  },
  methods: {
    async resolveDomain() {
      const provider = new ProviderRpcClient();
      await provider.requestPermissions({ permissions: ["basic", "accountInteraction"] });

      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

      const certificateAddr = await rootContract.methods
        .resolve({ path: this.domainToResolve, answerId: 42 })
        .call({ responsible: true });

      this.resolveResult = JSON.stringify(certificateAddr?.certificate, null, 2);

      const domainContract = new provider.Contract(DOMAIN_ABI, certificateAddr.certificate);

      let result;
      try {
        result = await domainContract.methods.query({ key: 0, answerId: 1337 }).call({ responsible: true });
      } catch (e) {
        this.resolveResult = "";
        this.targetAddress = "";
        this.error = "Domain not exist";
        return;
      }

      if (!result.value) {
        this.targetAddress = JSON.stringify(result, null, 2);
        return;
      }

      const unpackedTargetAddress = await provider.unpackFromCell({
        structure: [{ name: "address", type: "address" }] as const,
        boc: result.value!,
        allowPartial: true,
      });
      this.targetAddress = unpackedTargetAddress.data.address.toString();
    },
  },
});
</script>

<style scoped>
.dns-resolver {
  margin-bottom: 1rem;
}
</style>
