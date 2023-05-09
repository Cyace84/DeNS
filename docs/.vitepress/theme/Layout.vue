<template>
  <div>
    <header>
      <SearchBox />
    </header>
    <main>
      <slot />
    </main>
    <footer></footer>
  </div>
</template>

<script>
import { SearchPlugin as SearchBox } from "vitepress-plugin-search";

export default {
  components: {
    SearchBox,
  },
};
</script>
