<template>
  <div class="demo">
    <div class="input-group">
      <label for="domainToResolve">Domain to resolve:</label>
      <EdInput v-model="domainToResolve" @input="resolveDomain" />
    </div>
    <button @click="resolveDomain">Resolve Domain</button>
    <pre v-if="resolveResult">Domain Address: {{ resolveResult }}</pre>
    <pre v-if="targetAddress">Target Account address: {{ targetAddress }}</pre>
    <pre v-if="error">Domain not exist </pre>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { ProviderRpcClient } from "everscale-inpage-provider";
import { ROOT_ABI, ROOT_ADDRESS, DOMAIN_ABI } from "./../../helpers";
import EdInput from "../shared/EdInput.vue";

export default defineComponent({
  name: "DnsResolver",
  setup() {
    const domainToResolve = ref("username");
    const targetAddress = ref("");
    const resolveResult = ref("");
    const error = ref("");

    return { domainToResolve, targetAddress, resolveResult, error };
  },
  components: {
    EdInput,
  },
  methods: {
    async resolveDomain() {
      const provider = new ProviderRpcClient();
      await provider.requestPermissions({ permissions: ["basic", "accountInteraction"] });

      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

      const certificateAddr = await rootContract.methods
        .resolve({ path: this.domainToResolve + ".ever", answerId: 42 })
        .call({ responsible: true });

      this.resolveResult = JSON.stringify(certificateAddr?.certificate, null, 2);

      const domainContract = new provider.Contract(DOMAIN_ABI, certificateAddr.certificate);

      let result;
      try {
        result = await domainContract.methods.query({ key: 0, answerId: 1337 }).call({ responsible: true });
        this.error = "";
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
.input-group {
  position: relative;
  display: flex;
}
</style>
