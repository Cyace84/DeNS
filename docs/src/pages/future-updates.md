---
outline: deep
---

# Future Updates

In this section, we'll discuss the forthcoming enhancements and development roadmap for the Ever Name system.

::: warning Note
The following sections are currently under development and are not yet available on GitHub.
:::

## Domain Transfer Verification

### Challenge

Current domain contracts allow the owner to set any address as the target, which is subsequently displayed in the wallet. This can be misused by malicious individuals who set inappropriate or provocative domain names to harass users.

### Proposed Solution

We aim to introduce an intermediary action requiring confirmation of target assignment by the wallet.

### Contract Interaction Framework

To understand the proposed solution, we'll delve into the functioning of the `Certificate.sol` contract.

#### Variables

- `address public _target;` - The actual target value needed for interaction with other methods can be retrieved via the contract method `resolve()`.
- `address public _pendingTarget;` - The interim target value can be retrieved using the `pendingResolve()` method.

#### Methods

- `setTarget(address target)` - Accessible only by the owner and only for an active domain. If `target` matches the owner, the `_setTarget(target)` function is invoked. If `target` doesn't match the owner, the `_setPendingTarget(target)` function is triggered.
- `_setTarget(address target)` - A private method which modifies the `_target` variable to `target`.
- `_setPendingTarget(address target)` - A private method that changes the `_pendingTarget` variable to `target`.
- `approvePendingTarget()` - Accessible only by `_pendingTarget`. This method triggers `_setTarget(_pendingTarget)` and `_setPendingTarget(0:0...0)`.
- `rejectPendingTarget()` - Accessible only by `_pendingTarget`. This function invokes `_setPendingTarget(0:0...0)`.
- `rejectTarget()` - Accessible only by `_target`. This function calls `_setTarget(0:0...0)`.

#### Workflow Example

Alice, the owner of the domain `alice.friend`, wishes to have her domain displayed on Bob's account. Alice invokes the `setTarget(Bob)` method and asks Bob to confirm it. Bob triggers the `approvePendingTarget()` method on the domain, and it is now displayed as `alice.friend`. If Bob doesn't wish to confirm Alice's generosity, he invokes the `rejectPendingTarget()` method.

Upon confirmation, if Alice is ever implicated in money laundering via a crypto-casino, Bob can disassociate the `alice.friend` domain at any moment by triggering the `rejectTarget()` method.

## Bulk Domain Registration

### Challenge

The `Root.sol` contract currently only supports the registration of domains on an individual basis. Each domain requires a separate payload generation and token transfer.

### Proposed Solution

Our aim is to incorporate a feature allowing batch domain registration while retaining the option for individual registrations.

### Contract Interaction Framework

In this context, we'll explore the methods of the `Root.sol` contract.

#### Structures

- `struct NameSet` - Utilized for calculating the cost of registration.
  - `string name;` - The domain name.
  - `uint128 duration;` - The intended registration period.

#### Methods

- `buildRegisterBatchPayload(string[] names)` - `names` is an array of domains to be registered subsequently. The method operates similar to `buildRegisterPayload`.
- `expectedRegisterBatchAmount(NameSet[] name_sets)` - Essentially, it returns the number of tokens required for the registration of specified domains for the specified period.

### Workflow Example

Alice, having successfully laundered all her money via a crypto-casino, decides to purchase multiple appealing domains. After adding `telegram.venom`, `shop.venom

`, and `ever.venom` to her shopping cart, Alice generates the payload as follows:

```javascript
root.methods.buildRegisterBatchPayload({ names: ["telegram", "shop", "ever"] });
```

Next, Alice calculates the total cost as follows:

```javascript
root.methods.expectedRegisterBatchAmount({
  name_sets: [
    {
      name: "telegram",
      duration: 60 * 60 * 24 * 365,
    },
    {
      name: "shop",
      duration: 60 * 60 * 24 * 365,
    },
    {
      name: "ever",
      duration: 60 * 60 * 24 * 365,
    },
  ],
});
```

Lastly, Alice transfers the calculated amount of tokens with the generated payload to the `Root.sol` address.
