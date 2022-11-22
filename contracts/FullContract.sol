// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface CallDemo {
    function callGet2() external returns (bytes memory);
    function callGet99() external returns (uint);
}

contract FullContract {
    fallback(bytes calldata data) external returns (bytes memory){
        assembly {
            let fs := calldataload(0x00)
            mstore(0x00,fs)
            return(0x00,0x20)
        }
    }
}

contract FullContractHelper {
    CallDemo tar;
    constructor(address _target){
        tar = CallDemo(_target);
    }
    function get() external returns(bytes memory){
        bytes memory d = tar.callGet2();
        return d;
    }
}