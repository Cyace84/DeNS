# Registering a Subdomain

Once you have registered a domain, you may want to create subdomains under it. This could be useful for organizing different sections or categories of your project or business. Here's a guide on how to register a subdomain:

## Create a Subdomain

To create a subdomain, you need to call the `createSubdomain` method in the domain/subdomain contract where:

- `name` - this is the name of the subdomain you want to create.
- `owner` - this is the owner of the new subdomain.
- `renewable` - this is a flag that marks whether the owner of the subdomain can renew it at any time.

```javascript
const domainContract = new provider.Contract(DOMAIN_ABI, domainAddress);

const createSubdomainTransaction = await domainContract.methods
  .createSubdomain({
    name: "sub.yourdomain.ever",
    owner: yourAddress,
    renewable: true,
  })
  .send({ from: yourAddress, amount: "1e9", bounce: true });
```

<SubdomainRegistration />

::: info
**Check the result of the subdomain creation** - After calling the `createSubdomain` method, the `owner` will receive a callback.

- If the subdomain creation is successful, you will receive an `onMinted` callback.
- In case of an error, you will receive an `onCreateSubdomainError` callback with a `TransferBackReason.*` (where \* is the specific reason) reason.
  :::

## Mapping a Subdomain to an Address

Once you have registered a subdomain, you can associate it with a blockchain address. This makes it easier for others to interact with that address, since they can use your easy-to-remember subdomain name instead of a complex blockchain address.

To do this, you simply need to call the `setTarget` method on your subdomain contract, passing the target address as the parameter. Here is how you can do it:

```javascript
const subdomainContract = new provider.Contract(SUBDOMAIN_ABI, subdomainAddress);

const setTargetTransaction = await subdomainContract.methods
  .setTarget({ target: yourAddress })
  .send({ from: yourAddress, amount: "1e9", bounce: true });
```

<SetTarget />

::: info
**Understanding the `setTarget` method**

The `setTarget` method allows you to specify a target blockchain address for your subdomain. This means that whenever someone sends tokens to your subdomain (e.g., "sub.yourdomain.ever"), those tokens will be automatically forwarded to the target address.

This makes it easy for you to receive tokens at your subdomain, even if you change your underlying blockchain address. Simply update the target address using the `setTarget` method, and your subdomain will start forwarding incoming tokens to the new address.
:::
