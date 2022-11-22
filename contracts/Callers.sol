// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract Callers {

    //66e1d401
    function get21(address _a) external view returns(uint){
        assembly{
            mstore(0x00,0x67e0badb)

            let suc := staticcall(gas(),_a,28,32,0x00,0x20)
            if iszero(suc) {
                revert(0,0)
            }
            return(0x00,0x20)
        }
    }

    function callMult(address _a) external view returns(uint) {
        assembly{
            let fmp := mload(0x40)
            mstore(fmp,0x0e5fa6a8)
            mstore(add(fmp,0x20),5)
            mstore(add(fmp,0x40),3)

            let suc := staticcall(gas(),_a,add(fmp,28),add(fmp,0x60),0x00,0x20)

            if iszero(suc) {
                revert (0,0)
            }

            return(0x00,0x20)

        }
    }

    function callWithNotKnownReturn(uint _len,address _to) external view  returns(bytes memory){
        assembly {
            let fmp := mload(0x40)
            mstore(fmp,0x25ca5fe6)
            mstore(add(fmp,0x20),_len)

            let suc := staticcall(gas(),_to,add(fmp,28),add(fmp,0x40),0x00,0x00)
            if iszero(suc){
                revert(0,0)
            }

            returndatacopy(0,0,returndatasize())
            return(0,returndatasize())
        }
    }

    function sendETH(address _to) external payable {
        assembly {
            let suc := call(gas(),_to,selfbalance(),0,0,0,0)
            if iszero(suc){
                revert(0,0)
            }
        }
    }

}


contract Helper {

    function getNum() external pure returns(uint) {
        return 21;
    }

    function mult(uint8 n1,uint n2) external pure returns(uint){
        return n1*n2;
    }

    function getbytes(uint _num) external pure returns(bytes memory){
        bytes memory me = new bytes(_num);
        for(uint tt = 0;tt < _num;tt++){
            me[tt] = 0x01;
        }
        return me;
    }
}