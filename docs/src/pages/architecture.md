---
outline: deep
---

## Architecture

The DeNS system is composed of three primary components: the registry, resolvers, and auction interfaces. This section provides an overview of each component and the methods they support.

### 1. Registry: Root Contract

The DeNS registry is managed by a single smart contract, `Root`, which keeps track of all top-level domains (TLDs). The `Root` contract handles the following tasks:

- Deploying new domain and subdomain certificates
- Managing the root domain

The `Root` contract offers the following methods:

1. Retrieve certificate address by full path
2. Create a new domain
3. Renew existing domains
4. Revoke domain through DAO voting
5. Reserve and unreserve domain via DAO voting
6. Execute any action through DAO voting
7. Activate or deactivate root contracts (admin only)

Additionally, the `Root` contract supports all TIP-4 collection methods.

### 2. Domain and Subdomain Interfaces

Domains within DeNS are managed through various interfaces and smart contracts, such as `Domain` and `Subdomain`.

#### 2.1. Domain Smart Contract

The `Domain` smart contract supports the following method:

1. Initiate auction for new domains

Additionally, the `Domain` contract supports all TIP-4 token (NFT) methods.

#### 2.2. Subdomain Smart Contract

The `Subdomain` smart contract offers the following methods:

1. Resolve domain
2. Query record(s)
3. Modify target or record
4. Create subdomain
5. Revoke subdomain rights (in development, not yet on GitHub)

In addition, the `Subdomain` contract supports all TIP-4 token (NFT) methods.

### 3. Auction Interfaces

The auction interfaces, although not detailed here, play a crucial role in the process of acquiring new domains within the DeNS system.
