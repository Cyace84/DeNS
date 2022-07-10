pragma ton-solidity >= 0.61.2;

import "../../enums/TransferBackReason.sol";
import "../../structures/DomainSetup.sol";


interface IOwner {

    function onMinted(uint256 id, address nft, address owner, address manager, address creator) external;
    function onBurt(uint256 id, address nft, address owner, address manager) external;
    function onCreateSubdomainError(string path, optional(TransferBackReason) reason) external;

    function onRenewed(string path, uint32 expireTime) external;
    function onUnreserved(string path, uint32 expireTime) external;

}
