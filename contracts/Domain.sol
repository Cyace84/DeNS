pragma ton-solidity >= 0.61.2;

pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "./interfaces/IDomain.sol";
import "./interfaces/outer/IOwner.sol";
import "./abstract/NFTCertificate.sol";
import "./structures/Configs.sol";
import "./structures/DomainSetup.sol";
import "./utils/Constants.sol";
import "./utils/Converter.sol";


contract Domain is NFTCertificate, IDomain {

    event ZeroAuctionStarted();
    event ZeroAuctionFinished();
    event Prolonged(uint32 time, uint32 duration, uint32 newExpireTime);


    DomainConfig public _config;
    uint128 public _defaultPrice;
    uint128 public _auctionPrice;

    bool public _inZeroAuction;
    bool public _needZeroAuction;
    bool public _reserved;


    // todo platform
    // 0x3F61459C is Platform constructor functionID
    function onDeployRetry(TvmCell code, TvmCell params) public functionID(0x4A2E4FD6) onlyRoot {
        (/*string path*/, uint16 version, DomainConfig config, DomainSetup setup, /*TvmCell indexCode*/)
            = abi.decode(params, (string, uint16, DomainConfig, DomainSetup, TvmCell));
        if (_status() == CertificateStatus.EXPIRED) {
            if (version != _version) {
                _upgrade(version, code, config);
            }
            _init(params);
        } else {
            if (setup.reserved) {
                _root.transfer({value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false});
            } else {
                IRoot(_root).onDomainDeployRetry{
                    value: 0,
                    flag: MsgFlag.REMAINING_GAS,
                    bounce: false
                }(_path, setup.amount, setup.owner);
            }
        }
    }

    function _init(TvmCell params) internal override {
        DomainSetup setup;
        (_path, _version, _config, setup, _indexCode) =
            abi.decode(params, (string, uint16, DomainConfig, DomainSetup, TvmCell));
        (_owner, _defaultPrice, _needZeroAuction, _reserved, _expireTime, /*amount*/) = setup.unpack();
        _auctionPrice = _defaultPrice;
        _initTime = now;
        _initNFT(_owner, _owner, _indexCode);
    }


    function getConfig() public responsible returns (DomainConfig config) {
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} _config;
    }

    function getPrices() public responsible returns (uint128 defaultPrice, uint128 auctionPrice) {
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} (_defaultPrice, _auctionPrice);
    }

    function getFlags() public responsible returns (bool inZeroAuction, bool needZeroAuction, bool reserved) {
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} (_inZeroAuction, _needZeroAuction, _reserved);
    }


    function startZeroAuction() public onStatus(CertificateStatus.NEW) minValue(Gas.START_ZERO_AUCTION_VALUE) {
        // todo

        emit ZeroAuctionStarted();
        _inZeroAuction = true;
    }

    function zeroAuctionFinished() public onStatus(CertificateStatus.IN_ZERO_AUCTION) {
        // todo
//        require(msg.sender == _auction, 69);

        emit ZeroAuctionFinished();
//        _auction = address.makeAddrNone();
        _inZeroAuction = false;
        _needZeroAuction = true;
//        _auctionPrice = auctionPrice;
    }

    // duration - time for prolonging from now
    function expectedProlongAmount(uint32 duration) public responsible returns (uint128 amount) {
        CertificateStatus status = _status();
        if (duration > _config.maxDuration || now + duration <= _expireTime || status == CertificateStatus.RESERVED) {
            return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} 0;
        }
        uint32 increase = now + duration - _expireTime;
        uint128 price = _calcProlongPrice(status);
        return {value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false} Converter.toAmount(increase, price);
    }

    function prolong(uint128 amount, address sender) public override onlyRoot {
        CertificateStatus status = _status();
        if (sender != _owner || now + _config.maxDuration <= _expireTime || status == CertificateStatus.RESERVED) {
            // wrong sender OR already prolonged for max period OR reserved
            IRoot(_root).onProlongReturn{
                value: 0,
                flag: MsgFlag.REMAINING_GAS,
                bounce: false
            }(_path, amount, sender);
            return;
        }

        _reserve();  // todo move up in case of using target balance
        uint128 price = _calcProlongPrice(status);
        uint32 maxIncrease = now + _config.maxDuration - _expireTime;
        uint128 maxAmount = Converter.toAmount(maxIncrease, price);
        uint128 returnAmount = (maxAmount < amount) ? (amount - maxAmount) : 0;
        amount = math.max(amount, maxAmount);

        uint32 duration = Converter.toDuration(amount, price);
        _expireTime += duration;
        emit Prolonged(now, duration, _expireTime);

        if (returnAmount > 0) {
            IRoot(_root).onProlongReturn{
                value: 0,
                flag: MsgFlag.ALL_NOT_RESERVED,
                bounce: false
            }(_path, returnAmount, sender);
        } else {
            _owner.transfer({value: 0, flag: MsgFlag.ALL_NOT_RESERVED, bounce: false});
        }
    }

    function unreserve(address owner, uint128 price, uint32 expireTime, bool needZeroAuction) public onlyRoot {
        _updateIndexes(_owner, owner, _owner);
        _owner = owner;
        _defaultPrice = _auctionPrice = price;
        _needZeroAuction = needZeroAuction;
        _reserved = false;
        _initTime = now;
        _expireTime = expireTime;
        IOwner(_owner).onUnresevre{
            value: 0,
            flag: MsgFlag.REMAINING_GAS,
            bounce: false
        }(_path, expireTime);
    }


    function _status() internal view override returns (CertificateStatus) {
        int64 passed = int64(now) - _initTime;
        int64 left = int64(_expireTime) - now;
        if (_reserved) {
            return CertificateStatus.RESERVED;
        } else if (_inZeroAuction) {
            return CertificateStatus.IN_ZERO_AUCTION;
        } else if (passed < _config.startZeroAuctionTimeRange && !_needZeroAuction) {
            return CertificateStatus.NEW;
        } else if (left < -_config.graceTimeRange) {
            return CertificateStatus.EXPIRED;
        } else if (left < 0) {
            return CertificateStatus.GRACE;
        } else if (left < _config.expiringTimeRange) {
            return CertificateStatus.EXPIRING;
        } else {
            return CertificateStatus.COMMON;
        }
    }

    function _calcProlongPrice(CertificateStatus status) private view inline returns (uint128) {
        uint128 price = _auctionPrice;  // todo _defaultPrice VS _auctionPrice
        if (status == CertificateStatus.GRACE) {
            price += math.muldiv( _config.graceFinePercent, price, Constants.PERCENT_DENOMINATOR);
        } else if (status == CertificateStatus.EXPIRED) {
           price += math.muldiv( _config.expiredFinePercent, price, Constants.PERCENT_DENOMINATOR);
        }
        return price;
    }


    function requestUpgrade() public override minValue(Gas.REQUEST_UPGRADE_DOMAIN_VALUE) {
        IRoot(_root).requestDomainUpgrade{
            value: 0,
            flag: MsgFlag.REMAINING_GAS,
            bounce: false
        }(_path, _version);
    }

    function acceptUpgrade(uint16 version, TvmCell code, DomainConfig config) public onlyRoot {
        if (version == _version) {
            _owner.transfer({value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false});
            return;
        }
        _upgrade(version, code, config);
    }

    function _upgrade(uint16 version, TvmCell code, DomainConfig config) private {
        emit CodeUpgraded(_version, version);
        _version = version;
        _config = config;
        TvmCell data = abi.encode("xxx");  // todo values
        tvm.setcode(code);
        tvm.setCurrentCode(code);
        onCodeUpgrade(data);
    }


    onBounce(TvmSlice body) external {
        uint32 functionId = body.decode(uint32);
        if (functionId == tvm.functionId(prolongSubdomain)) {
            // subdomain not exists minted
            _owner.transfer({value: 0, flag: MsgFlag.REMAINING_GAS, bounce: false});
        }
    }

}
