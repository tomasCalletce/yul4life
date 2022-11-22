// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract MemoryIntro{

    event disOneData(bytes32 m);
    event disTwoData(bytes32 n);

    struct Point{
        uint x;
        uint y;
    }

    function v2Hash() external pure returns (bytes32) {
        assembly {
            let fmp := mload(0x40)

            mstore(fmp,4)
            mstore(add(fmp,0x20),6)
            mstore(add(fmp,0x40),9)

            mstore(0x40,add(fmp,0x60))
            mstore(0x00,keccak256(fmp,0x60))
            return(0x00,0x20)
        }
    }

    function hashV1() external pure returns(bytes32){
        bytes memory toBeHashed = abi.encode(1,5,3,6);
        return keccak256(toBeHashed);
    }

    function checkCaller() external view {
        assembly {
           if iszero(eq(caller(),0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)){
               revert(0,0)
           }
        }
    }

    function retur() external pure returns(uint,uint) {
        assembly {
            mstore(0x00,3)
            mstore(0x20,5)
            return(0x00,0x40)
        }
    }

    function freeMP() external {
        bytes32 fmp;
        assembly {
            fmp := mload(0x40)
        }
        emit disOneData(fmp);
        Point memory p = Point({x:2,y:8});
        assembly {
            fmp := mload(0x40)
        }
        emit disOneData(fmp);
    }


    function araysINmemory() external {
        bytes32 fmp;
        assembly {
            fmp := mload(0x40)
        }
        emit disOneData(fmp);
        uint[2] memory p = [uint(4),uint(2)];
        assembly {
            fmp := mload(0x40)
        }
        emit disOneData(fmp);
    }

    function returnArr() external pure returns(uint[2] memory) {
        assembly {
            let fmp := mload(0x40)
            mstore(fmp,3)
            mstore(add(fmp,0x20),4)

            return(fmp,0x40)
        }
    }
}