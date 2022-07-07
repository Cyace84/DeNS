pragma ton-solidity >= 0.61.2;

import "@broxus/contracts/contracts/libraries/MsgFlag.sol";


abstract contract TransferUtils {
    uint16 constant _LOW_MSG_VALUE = 500;

    modifier minValue(uint128 value) {
        require(msg.value >= value, _LOW_MSG_VALUE);
        _;
    }

    modifier cashBack() {
        _reserve();
        _;
        msg.sender.transfer({value: 0, flag: MsgFlag.ALL_NOT_RESERVED, bounce: false});
    }

    function _reserve() internal view virtual {
        tvm.rawReserve(address(this).balance - msg.value, 2);
    }

}
