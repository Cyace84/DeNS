<script setup>
import DefaultTheme from "vitepress/theme";
import WalletControl from "./../../src/components/WalletControl.vue";

const { Layout } = DefaultTheme;
</script>

<template>
  <Layout>
    <template #nav-bar-content-after
      ><Suspense><WalletControl /></Suspense
    ></template>
  </Layout>
</template>
