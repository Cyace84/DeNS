<template>
  <div class="demo">
    <div class="input-group">
      <label>Domain to register:</label>
      <div class="input-domain" contenteditable="true" @input="updateDomainName" data-post-fix=".ever">
        {{ domainName }}
      </div>
    </div>
    <br />
    <label for="duration">Duration:</label>
    <select id="duration" v-model="duration">
      <option value="1">1 year</option>
      <option value="2">2 years</option>
      <option value="3">3 years</option>
      <option value="4">4 years</option>
      <option value="5">5 years</option>
    </select>
    <br />
    <button @click="getPrice">Get Registration Price</button>
    <pre v-if="price">Registration Price: {{ price }} WEVER.</pre>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { ProviderRpcClient } from "everscale-inpage-provider";
import { ROOT_ABI, ROOT_ADDRESS } from "./../../helpers";

export default defineComponent({
  name: "GetPrice",
  setup() {
    const domainName = ref("somedomain");
    const duration = ref("1");
    const price = ref("");
    return { domainName, duration, price };
  },
  methods: {
    async getPrice() {
      const provider = new ProviderRpcClient();
      await provider.requestPermissions({ permissions: ["basic", "accountInteraction"] });

      const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);
      const registrationPrice = await rootContract.methods
        .expectedRegisterAmount({
          name: this.domainName,
          duration: 60 * 60 * 24 * 365 * parseInt(this.duration),
          answerId: 22,
        })
        .call({ responsible: true });

      this.price = (Number(registrationPrice.amount!) / 1e9).toString();
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

.input-domain {
  padding-right: 0px;
  border: 1px solid var(--vp-c-divider);
  border-radius: 4px;
  padding: 0.2em 0.6em;
  margin-bottom: 10px;
  min-width: 20rem;
  background: transparent;
  transition: background-color 0.5s;
}
.input-domain:not([type]):focus,
.input-domain textarea:focus,
.input-domain select:focus {
  outline: 1px solid blue;
}

.input-domain::after {
  content: attr(data-post-fix);
  pointer-events: none;
  color: rgba(255, 252, 252, 0.5);
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
