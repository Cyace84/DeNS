pragma ever-solidity ^0.63.0;

import "../interfaces/IVault.sol";
import "../utils/Gas.sol";

import "@broxus/contracts/contracts/libraries/MsgFlag.sol";
import "tip3/contracts/interfaces/ITokenRoot.sol";
import "tip3/contracts/interfaces/ITokenWallet.sol";
import "tip3/contracts/interfaces/IAcceptTokensTransferCallback.sol";
import "tip3/contracts/interfaces/IBurnableTokenWallet.sol";


abstract contract Vault is IVault, IAcceptTokensTransferCallback {

    address public _token;
    address public _wallet;
    uint128 public _balance;

    modifier onlyToken() {
        require(msg.sender == _token && _token.value != 0, 69);
        _;
    }

    modifier onlyWallet() {
        require(msg.sender == _wallet && _wallet.value != 0, 69);
        _;
    }


    constructor(address token) internal {
        _token = token;
        ITokenRoot(token).deployWallet{
            value: 0,
            flag: MsgFlag.ALL_NOT_RESERVED,
            callback: onWalletDeployed
        }({
            owner: address(this),
            deployWalletValue: Gas.DEPLOY_WALLET_VALUE
        });
    }

    function onWalletDeployed(address wallet) public override onlyToken {
        _wallet = wallet;
    }

    function getToken() public view responsible override returns (address token) {
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} _token;
    }

    function getWallet() public view responsible override returns (address wallet) {
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} _wallet;
    }

    function getBalance() public view responsible override returns (uint128 balance) {
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} _balance;
    }


    function _transferTokens(uint128 amount, address recipient, TvmCell payload) internal {
        _balance -= amount;
        ITokenWallet(_wallet).transfer{
            value: 0,
            flag: MsgFlag.ALL_NOT_RESERVED,
            bounce: false
        }({
            amount: amount,
            recipient: recipient,
            deployWalletValue: 0,
            remainingGasTo: recipient,
            notify: true,
            payload: payload
        });
    }

    function _burnAll(address remainingGasTo) internal {
        _burn(_balance, remainingGasTo);
    }

    function _burn(uint128 amount, address remainingGasTo) internal {
        if (_balance == 0) {
            return;
        }
        _balance -= amount;
        TvmCell empty;
        IBurnableTokenWallet(_wallet).burn{
            value: 0,
            flag: MsgFlag.ALL_NOT_RESERVED,
            bounce: true
        }({
            amount: amount,
            remainingGasTo: remainingGasTo,
            callbackTo: address(0),
            payload: empty
        });
    }


    onBounce(TvmSlice body) external {
        uint32 functionId = body.decode(uint32);
        if (functionId == tvm.functionId(IBurnableTokenWallet.burn)) {
            // burn is forbidden
            uint128 amount = body.decode(uint128);
            _balance += amount;
        }
    }

}
