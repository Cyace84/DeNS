# Working with DeNS

Before you can begin interacting with DeNS, you will need to obtain a reference to the DeNS registry. This guide provides example code for using the TypeScript-based API with the [everscale-inpage-provider](https://www.npmjs.com/package/everscale-inpage-provider).

::: info
The example code provided below assumes that it is being run inside a DApp browser, such as Chrome with the [Ever Wallet](https://everwallet.net) extension installed, which exposes the `provider` object.

Read more about the `provider` object in the [everscale-inpage-provider documentation](https://docs.broxus.com/).
:::

First, make sure to install the `everscale-inpage-provider` package:

```bash
npm install everscale-inpage-provider
```

Then, you can set up the `provider` and obtain a reference to the DeNS registry:

```javascript
import { ProviderRpcClient } from "everscale-inpage-provider";

// Instantiate the Everscale provider
const provider = new ProviderRpcClient();

// Make sure the provider is initialized.
await provider.ensureInitialized();

// Request permissions from the user to execute API methods using the provider.
await provider.requestPermissions({ permissions: ["basic", "accountInteraction"] });

// Obtain the root contract address for the '.ever' TLD
const tld = "ever";
const rootContractAddress = "0:a7d0694c025b61e1a4a846f1cf88980a5df8adf737d17ac58e35bf172c9fca29";

// Initialize the DeNS root contract
const rootContract = new provider.Contract(rootContractAddress, RootABI);
```
