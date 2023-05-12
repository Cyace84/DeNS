# Resolving names

## Get a dns record for a specific domain

Now that you have a reference to the DeNS registry, you can resolve domain names and obtain DNS records:

```javascript
// Define the domain name to resolve
const domainToResolve = "username.ever";

// Define the root contract with ABI and address
const rootContract = new provider.Contract(ROOT_ABI, ROOT_ADDRESS);

// Call the resolve method to get the domain certificate address
const certificateAddr = await rootContract.methods
  .resolve({ path: domainToResolve, answerId: 42 })
  .call({ responsible: true });

const domainContract = new provider.Contract(DOMAIN_ABI, certificateAddr.certificate);

// Query the DNS record (key ID=0 to get the account address)
let result = await domainContract.methods.query({ key: 0, answerId: 1337 }).call({ responsible: true });

if (!result.value) {
  console.log("No Account address record found");
  return;
}

// Extract the Account address from the cell
const unpackedTargetAddress = await provider.unpackFromCell({
  structure: [{ name: "address", type: "address" }] as const,
  boc: result.value!,
  allowPartial: true,
});

const targetAddress = unpackedTargetAddress.data.address.toString();

console.log(`Target Account address: ${targetAddress}`);

```

<DnsResolver />
