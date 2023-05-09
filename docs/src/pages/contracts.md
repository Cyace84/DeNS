---
outline: deep
---

## Smart Contracts

### Root

`Root` is an implementation of the [`IRoot`](./interfaces.md#iroot) interface, which is the central component of the DeNS system, managing the registry and keeping track of all top-level domains (TLDs). It inherits functionality from the `Collection`, `Vault`, `BaseMaster`, `IUpgradable`, and `RandomNonce` contracts. The `Root` contract is responsible for deploying new domain and subdomain certificates and managing the root domain. It offers various methods for retrieving certificate addresses by full path, creating new domains, renewing existing domains, and revoking domains through DAO voting. Additionally, it allows reserving and unreserving domains via DAO voting, executing any action through DAO voting, and activating or deactivating root contracts (admin only). The `Root` contract also supports all TIP-4 collection methods, making it a vital part of the DeNS system's overall functionality.

### Domain

`Domain` is an implementation of the [`IDomain`](./interfaces.md#idomain) interface, representing a domain within the DeNS system. This smart contract is responsible for domain management tasks such as registration, renewal, and zero auction. It extends the functionality provided by the `NFTCertificate` contract, maintaining domain status and configuration and providing essential functionalities for domain transfers and auctions.

### Subdomain

`Subdomain` is an implementation of the [`ISubdomain`](./interfaces.md#isubdomain) interface, representing a subdomain within the DeNS system. This smart contract is responsible for subdomain management tasks such as creation, renewal, and destruction. It extends the functionality provided by the `NFTCertificate` contract, maintaining subdomain status and configuration and providing essential functionalities for subdomain lifecycle management.

### RootDeployer

The `RootDeployer` smart contract deploys new instances of the `Root` smart contract within the DeNS system. It stores the contract code for various components, such as the platform, root domain, domain, subdomain, and index contracts, and provides functionalities for creating and deploying new root domain instances.

### Vault

`Vault` is an implementation of the [`IVault`](./interfaces.md#ivault) and `IAcceptTokensTransferCallback` interfaces, playing a vital role in the DeNS system by providing essential functionality for managing token operations such as token storage, transfers, and wallet management. The contract imports various utility contracts to ensure adherence to standardized function signatures and consistent interactions with other components of the DeNS system, enabling secure token management.

### NFTCertificate

The `NFTCertificate` abstract contract serves as a foundation for the DeNS system's certificate management. This contract extends the functionality provided by the `NFTBase4_3`, `JSONMetadataDynamicBase`, and `Certificate` contracts, offering key functionalities for ownership and management transfer, JSON metadata generation, interface support, and certificate lifecycle management.

### Collection

The `Collection` contract manages the collection of certificates within the DeNS system. It integrates various functionalities and provides additional functions and modifiers to handle events related to minting and burning NFTs. Furthermore, the contract ensures compatibility with TIP 4.1 and TIP6 standards, offering crucial functions for calculating certificate addresses and constructing state initialization data for new certificate contracts.

### Certificate

`Certificate` is an implementation of the [`ICertificate`](./interfaces.md#icertificate) interface, providing the foundation for domain and subdomain management within the DeNS system. This abstract contract offers key functionalities such as target and record management, subdomain creation and renewal, and up
