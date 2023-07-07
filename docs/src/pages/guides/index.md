<!-- <script setup>
  import { ProviderRpcClient } from 'everscale-inpage-provider';
  import { ROOT_ABI, ROOT_ADDRESS } from "./../../helpers";
  import abi from "./../../../../build/Root.abi.json";
  const provider = new ProviderRpcClient({});
  const resolve = async () => {
    await provider.requestPermissions({
       permissions: ['basic', 'accountInteraction']
    });
    const contract = new provider.Contract(abi, ROOT_ADDRESS);
    const str = "huy.ever";
    const res = await contract.methods.resolve({path: str, answerId: 42}).call({responsible: true});
    console.log(res);
  };
</script>

<Suspense>
<div class="demo">
  <button @click="resolve">Request permissions</button>

</div>

</Suspense>

::: info
Please note that in order to interact with the sample contracts provided in the guide, it is necessary to use [Ever Wallet](https://everwallet.net) and the test network.
::: -->
