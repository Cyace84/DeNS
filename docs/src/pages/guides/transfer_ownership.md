# Changing Ownership of a Domain or Subdomain

## Overview of Roles in DeNS

In DeNS, each Non-Fungible Token (NFT) representing a domain or subdomain contains two key roles:

1. **Owner**: This address owns the NFT. The owner can visualize the NFT in wallets, marketplaces, and applications. The NFT can also be used by the owner for authorization, proof in games, and other functionalities.

2. **Manager**: This address controls the NFT. The manager can burn the NFT or change the owner or the manager. It is the authority that governs the lifecycle of the NFT.

In most cases, the owner and manager addresses can be the same. However, when an NFT is put up for sale or subjected to specific logic like farming or custom use, the manager's address is typically the address of the smart contract executing that logic.

It is considered a good practice to set the new owner's address as the manager's address when the owner is changed. This ensures that the control of the NFT is transferred along with its ownership.

## Changing Ownership of a Domain or Subdomain

The `changeOwner` function allows the current manager of a domain or subdomain to change its ownership. The new owner's address is passed as an argument to the function. An empty array of callbacks is also passed. Callbacks are not mandatory and can be omitted if they're not needed.

```javascript
const domainContract = new provider.Contract(DOMAIN_ABI, domainAddress);

const changeOwnerTransaction = await domainContract.methods
  .changeOwner({ newOwner: newOwnerAddress, sendGasTo: currentManagerAddress, callbacks: [] })
  .send({ from: currentManagerAddress, amount: String(1e9), bounce: true });
```

<ChangeOwner />

## Changing Management of a Domain or Subdomain

The `changeManager` function allows the current manager of a domain or subdomain to transfer its management to another address. The new manager's address is passed as an argument to the function. An empty array of callbacks is also passed. Callbacks are not mandatory and can be omitted if they're not needed.

```javascript
const domainContract = new provider.Contract(DOMAIN_ABI, domainAddress);

const changeManagerTransaction = await domainContract.methods
  .changeManager({ newManager: newManagerAddress, sendGasTo: currentManagerAddress, callbacks: [] })
  .send({ from: currentManagerAddress, amount: String(1e9), bounce: true });
```

<ChangeManager />

## Transfer: Changing Both Ownership and Management

The `transfer` function allows the manager of a domain or subdomain to simultaneously transfer both ownership and management rights to another address. This is a powerful action that essentially combines the effects of `changeOwner` and `changeManager` functions. An empty array of callbacks is also passed. Callbacks are not mandatory and can be omitted if they're not needed.

```javascript
const domainContract = new provider.Contract(DOMAIN_ABI, domainAddress);

const transferTransaction = await domainContract.methods
  .transfer({ to: newAddress, sendGasTo: currentManagerAddress, callbacks: [] })
  .send({ from: currentManagerAddress, amount: String(1e9), bounce: true });
```

<Transfer />

::: info
Please remember, utilizing the `transfer` function implies giving full control over the domain or subdomain to the new address. Always ensure that you fully understand the consequences of these actions before proceeding.
:::

::: warning
In the context of a zero auction, the `transfer` function also handles the completion of the auction, including the return of tokens from the domain.
:::
