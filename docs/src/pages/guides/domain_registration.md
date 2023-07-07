# Domain Registration

In the Everscale blockchain, you can bind your domain to your blockchain address and interact with the blockchain using short, user-friendly names instead of long, complex addresses.

Domain names can range in length from 4 to 126 characters. English letters, numbers, and hyphens are permissible characters.

Domains consisting of 12 or more characters can be purchased directly, without the need for an auction. Conversely, domain names shorter than 12 characters are acquired via an auction process.

The registration cost for domains varies depending on their length: 45 WEVER for 12-character domains, and 20 WEVER for domains with 13 or more characters.

Here's the starting auction prices for domains shorter than 12 characters:

| Domain length | Auction price |
| ------------- | ------------- |
| 4             | 4000 WEVER    |
| 5             | 2000 WEVER    |
| 6             | 1750 WEVER    |
| 7             | 1500 WEVER    |
| 8             | 750 WEVER     |
| 9             | 375 WEVER     |
| 10            | 180 WEVER     |
| 11            | 90 WEVER      |

After a user acquires a domain with 11 or fewer characters, other users have a week to initiate an auction. The auction lasts for 7 days, and the user who places the highest bid becomes the new owner of the domain.

The cost of renewing a domain is equal to the initial registration cost.

Registering a new domain in the Ever Name system is a straightforward process.

::: info
It's important to note that these rules and costs are specific to the Everscale blockchain, where WEVER, wrapped native coin a [TIP3 standard token](https://docs.everscale.network/standard/TIP-3), is used. If you deploy Ever Name contracts on another TVM blockchain, the settings, including the registration and auction prices, might be different and are configurable based on your requirements. Always ensure you're familiar with the specific configurations of the blockchain you're using.
:::

## Register a new domain

To register a new domain, you need to follow these steps:

1. **Get the price for the domain registration** - You can get the expected amount for registering a new domain by calling the `expectedRegisterAmount` method in the root contract. This will return the price in tokens for registering a new domain.

```javascript
const registrationPrice = await rootContract.methods
  .expectedRegisterAmount({
    name: "somedomain.ever",
    duration: 60 * 60 * 24 * 365 // 1 year,
    answerId: 22,
  })
  .call({ responsible: true });
```

<GetRegistrationPrice />

2. **Build the payload for the domain registration** - You need to build the payload for the domain registration by calling the `buildRegisterPayload` method in the root contract. This will return the payload which you will use to register a new domain.

```javascript
// Build the payload for the domain registration
const registrationPayload = await rootContract.methods
  .buildRegisterPayload({ path: "yourdomain.ever" /* other params if any */ })
  .call({ responsible: true });


const tokenWallet = new provider.Contract(TIP3_WALLET_ABI, tokenwalletAddress);

// Send tokens and payload to the root contract's TIP3 wallet
const transaction = await tokenWallet.methods
  .transfer({
    amount: registrationPrice.amount,
    recipient: rootContract.address,
    deployWalletValue: 0,
    remainingGasTo: senderAddress!,
    notify: true,
    payload: registrationPayload.payload,
  })
  .send({
    from: senderAddress!,
    amount: String(3e9),
    bounce: true,
  });
```

<DomainRegistration />

::: info
**Check the result of the domain registration** - After sending the tokens and the payload, you will receive a callback.

- If the domain registration is successful, you will receive an `onMinted` callback.
- If the domain already exists, you will receive your tokens back with a `TransferBackReason.ALREADY_EXIST` reason.
- In case of other errors, you will receive your tokens back with a `TransferBackReason.*` (where \* is the specific reason) reason.
  :::

## Mapping an Address to a Domain

Once you have registered a domain, you can associate it with a blockchain address. This makes it easier for others to interact with that address, since they can use your easy-to-remember domain name instead of a complex blockchain address.

To do this, you simply need to call the `setTarget` method on your domain contract, passing the target address as the parameter. Here is how you can do it:

```javascript
const domainContract = new provider.Contract(DOMAIN_ABI, domainAddress);

const setTargetTransaction = await domainContract.methods
  .setTarget({ target: yourAddress })
  .send({ from: yourAddress, amount: String(1e9), bounce: true });
```

<SetTarget />

::: info
**Understanding the `setTarget` method**

The `setTarget` method allows you to specify a target blockchain address for your domain. This means that whenever someone sends tokens to your domain (e.g., "yourdomain.ever"), those tokens will be automatically forwarded to the target address.

This makes it easy for you to receive tokens at your domain, even if you change your underlying blockchain address. Simply update the target address using the `setTarget` method, and your domain will start forwarding incoming tokens to the new address.
:::
