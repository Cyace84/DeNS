pragma ton-solidity >= 0.61.2;


contract Platform {

    address static _root;
    uint8 static _platformType;
    TvmCell static _initialData;


    constructor(TvmCell code, TvmCell params) public functionID(0x4A2E4FD6) {
        require(msg.sender == _root, 69);
        TvmCell data = abi.encode(_root, tvm.code(), _initialData, params);
        tvm.setcode(code);
        tvm.setCurrentCode(code);
        onCodeUpgrade(data);
    }

    function onCodeUpgrade(TvmCell data) private {}

}
