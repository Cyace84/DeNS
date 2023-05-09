<!-- <template>
  <div>
    <div v-for="(item, index) in items" :key="index">
      <a :href="'#' + item.anchor">`++{{ item.name }}++`</a>
    </div>

    <div class="contract">
      <a :href="githubLink" target="_blank" rel="noopener noreferrer">
        <github-icon role="heading-link" />
      </a>

      <div class="hljs-theme-light nopadding">
        <pre>
          <code>import "@broxus-ton-tokens-contracts/{{__item_context.file.absolutePath}}";</code>
        </pre>
      </div>

      <div v-html="natspec.dev"></div>

      <contract-index v-if="modifiers.length" :modifiers="modifiers" />
      <contract-index v-if="hasFunctions" :functions="functions" />
      <contract-index v-if="hasEvents" :events="events" />

      <contract-item v-for="modifier in modifiers" :key="modifier.anchor" :item="modifier" item-kind="modifier" />
      <contract-item v-for="function in functions" :key="function.anchor" :item="function" item-kind="function" />
      <contract-item v-for="event in events" :key="event.anchor" :item="event" item-kind="event" />
    </div>
  </div>
</template>

<script lang="">

export default {
  props: {
    items: Array,
    __item_context: Object,
    natspec: Object,
    modifiers: Array,
    functions: Array,
    events: Array,
    anchor: String,
    name: String,
    hasFunctions: Boolean,
    hasEvents: Boolean,
  },
  computed: {
    githubLink() {
      return `https://github.com/broxus/tip3/${this.__item_context.file.absolutePath}`;
    },
  },
  components: {
    "github-icon": () => import(/* webpackChunkName: "github-icon" */ "@/components/github-icon.vue"),
    "contract-index": () => import(/* webpackChunkName: "contract-index" */ "@/components/contract-index.vue"),
    "contract-item": () => import(/* webpackChunkName: "contract-item" */ "@/components/contract-item.vue"),
  },
};
</script> -->
