// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract ArrAndMapping{

    struct Data{
        uint128 a;
        uint128 b;
    }
    mapping (uint => Data) public data;
    uint8[] public arr;
    mapping(uint => mapping(uint => uint)) public superData;


    constructor(){
        data[1] = Data(1,4);
        data[2] = Data(5,8);
        arr.push(9);
        arr.push(4);
        arr.push(2);
        superData[1][1] = 7;
    }
    
    function getAofIndex(uint _index) external view returns(uint _a){
        assembly{
            mstore(0,_index)
            let _loc := keccak256(0x0,0x40)
            let _val := sload(_loc)
            _a := and(0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff,_val)
        }
    }

    function getFromArr(uint _index) external view returns(uint _e){
        require(_index < arr.length);
        uint _slot = _index/32;
        uint _offset = _index%32;
        assembly{
            mstore(0x0,arr.slot)
            let _arrStart := keccak256(0x0,0x20)
            let _val := sload(add(_slot,_arrStart))
            let _shift := shr(mul(8,_offset),_val)
            _e := and(0x00000000000000000000000000000000000000000000000000000000000000ff,_shift)
        }
    }

    // the order matters make sure to keccak256(index,slot)
    function getFromSuperData(uint _0,uint _1) external view returns(uint _x){
        assembly{
            mstore(0x0,_0)
            mstore(0x20,superData.slot)
            let _sl := keccak256(0x00,0x40)
            mstore(0x0,_1)
            mstore(0x20,_sl)
            let _loc:= keccak256(0x00,0x40)
            _x := sload(_loc)
        }
    }



}
