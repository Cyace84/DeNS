---
outline: deep
---

## Interfaces

Implementing the following interfaces ensures that the corresponding smart contracts comply with the Ever Name system's requirements and standardize their core features:

### IRoot

The `IRoot` interface outlines the core functionalities required for the `Root` smart contract, including domain configuration management, domain name validation, price calculations, domain resolution, subdomain management, and administrative and upgradable tasks.

### IDomain

The `IDomain` interface outlines the essential functionalities required for the `Domain` smart contract, including domain configuration retrieval, domain status flag retrieval, zero auction handling, and domain renewal.

### ISubdomain

The `ISubdomain` interface defines the core methods and functionalities for subdomain management within the Ever Name system. Implemented by the `Subdomain` smart contract, the interface provides a standardized set of methods for interacting with and managing subdomain instances. Key methods include those for retrying subdomain deployment, obtaining duration configuration, and handling subdomain renewal and destruction.

### ICertificate

The `ICertificate` interface defines the core methods and functionalities for certificate management within the Ever Name system. Implemented by the `Domain` and `Subdomain` smart contracts, the interface provides a standardized set of methods for interacting with and managing certificates.
