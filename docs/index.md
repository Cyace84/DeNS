# Introduction

The Decentralized Name Service (DeNS) is a distributed, open, and extensible naming system based on The Open Network Virtual Machine (TVM)-compatible blockchains, such as Everscale. DeNS's primary function is to map human-readable names like 'alice.ever' to machine-readable identifiers, including wallet addresses, IP or ADNL addresses, traditional domain names, and other DNS protocol records. DeNS also supports reverse resolution, enabling the association of metadata, such as canonical names or interface descriptions, with wallet addresses.

DeNS is designed as an analog to the Ethereum Name Service (ENS) on the Ethereum blockchain, providing similar functionality for TVM-compatible blockchains. DeNS domains are implemented as Non-Fungible Tokens (NFTs) using the [TIP-4 token standard](https://docs.everscale.network/standard/TIP-4), which allows the owner to manage records and create subdomains as child NFTs. This is a notable difference from ENS, which uses the Ethereum ERC-721 standard (NFT) for its domains based on a single registry smart contract token standard.

DeNS operates on a system of dot-separated hierarchical names called domains, with the owner of a domain having full control over subdomains. Top-level domains, like '.ever' and '.test', are managed by the `Root` smart contract, which deploys new domain and subdomain certificates and ensures seamless integration between various components and interfaces.

DeNS is deployed on TVM-compatible blockchains, such as Everscale. If you use a library or an end-user application, it will automatically detect the network you are interacting with and use the DeNS deployment on that network.

You can try DeNS out for yourself now by using the [DeNS Manager](https://evername.io/).

## Deployed Domains

Add the following section to provide information about the deployed domains:

| TLD  | Address                                                            |
| ---- | ------------------------------------------------------------------ |
| ever | 0:a7d0694c025b61e1a4a846f1cf88980a5df8adf737d17ac58e35bf172c9fca29 |

## Key Differences between DeNS (TVM) and ENS (EVM)

While DeNS is conceptually similar to ENS, there are some key differences in the implementation and smart contract interfaces due to the differences between TVM and EVM:

1. DeNS is built on top of TVM-compatible blockchains, such as Everscale, which feature a sharded architecture. This allows for higher scalability and efficiency compared to the Ethereum blockchain, which is the foundation for ENS. DeNS smart contracts are written in TON-Solidity, whereas ENS smart contracts are written in Solidity and run on EVM.

2. DeNS domains are implemented as NFTs using the TIP-4 token standard, with the owner having control over the symbolic name and the ability to bind records and create subdomains. This standard is designed to be fully distributed and implies separate storage for each NFT. In contrast, ENS uses the Ethereum ERC-721 standard (NFT) for its domains, which is based on a single registry smart contract token standard.

3. DeNS provides a more flexible way of binding various types of records, such as wallet addresses, IP or ADNL addresses, traditional domain names, and other DNS protocol records, whereas ENS is primarily focused on binding Ethereum addresses to human-readable names.

4. DeNS smart contracts have a different structure and interface compared to ENS smart contracts, but both provide methods for resolving domain names and obtaining related information.

5. DeNS has a more sophisticated domain lifecycle, with different statuses like `RESERVED`, `NEW`, `IN_ZERO_AUCTION`, `COMMON`, `EXPIRING`, `GRACE`, and `EXPIRED`. This allows for more granular control over domain management, auctions, and expiration.

6. Due to the sharded architecture of TVM-compatible blockchains, DeNS is designed to be fully distributed, which implies separate storage of each user's balance. The TIP-3 token standard used in DeNS allows for more efficient storage and management of token balances and helps to avoid the high maintenance costs associated with sharding the registry.

7. In DeNS, it is possible to revoke a domain through DAO, whereas in ENS, a domain cannot be taken away while the subscription (registration) is active.
