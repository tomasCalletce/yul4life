// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;



contract StorageOffset {

    uint32 a0 = 4;
    uint96 public a = 2;
    uint128 public b = 3;

    function getSlot(uint256 _slot) external view returns (bytes32 _data){
        assembly {
            _data := sload(_slot)
        }
    }

    function getOffset() external pure returns (uint256 _offa,uint256 _offb){
        assembly {
            _offa := a.offset
            _offb := b.offset
        }
    }

    function readA() external view returns (uint96 _a){
        assembly{
            let _val := sload(0)
            let _shif := shr(32,_val)
            _a := and(0xffffffff,_shif)
        }
    }

    function readB() external view returns(uint128 _b){
        assembly{
            let _val := sload(b.slot)
            let _shif := shr(128,_val)
            _b := _shif
        }
    }

    function readAwithDIV() external view returns (uint96 _a){
        assembly{
            let _val := sload(0)
            let _shif := div(_val,0x100000000)
            _a := and(0xffffffff,_shif)
        }
    }

    function setA(uint96 _a) external  {
        assembly{
            let _val := sload(a.slot)
            let _clearA := and(0xffffffffffffffffffffffffffffffff000000000000000000000000ffffffff,_val)

            let _shif_a := shl(32,_a)
            sstore(0,or(_shif_a,_clearA))
        }
    }

    function setB(uint128 _b) external {
        assembly{
            let _val := sload(b.slot)
            let clearB := and(0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff,_val)
            let _shif_b := shl(128,_b)
            sstore(0,or(_shif_b,clearB))
        }
    }
 
}
