// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;



contract VariableLenInCallData {

    function readCallData(uint,uint[] calldata,uint) external pure returns (uint,uint[2] memory,uint) {
        assembly {
            let fmp := mload(0x40)
            mstore(fmp,calldataload(0x04))
            let loc := add(0x04,calldataload(0x24))
            let len := calldataload(loc)

            loc := add(loc,0x20)
            fmp := add(fmp,0x20)
            
            for { let i := 0 } lt(i, len) { i := add(i,1) } {
                mstore(add(fmp,mul(i,0x20)),calldataload(add(loc,mul(i,0x20))))
            }

            mstore(add(fmp,mul(len,0x20)),calldataload(add(0x24,0x20)))

            return(sub(fmp,0x20),add(0x40,mul(len,0x20)))
        }
    }

}

contract Helper {
    function t1(uint n,uint[] calldata nums,uint n1) external {
   
    }
}