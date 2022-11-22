// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract ERC20_YUL {

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

     constructor() {
        _name = "tomas calle";
        _symbol = "tc";
        _totalSupply = 4;
    }

    function transfer(address to, uint256 amount) external  returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function balanceOf(address account) external view returns (uint256 val) {
        assembly{
            mstore(0x00,account)
            let hash := keccak256(0x00,0x40)
            val := sload(hash)
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function totalSupply() external view returns (uint256) {
        assembly{
            mstore(0x00,sload(0x02))
            return(0x00,0x20)
        }
    }

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256 val) {
        assembly{
            mstore(0x00,owner)
            mstore(0x20,0x01)
            let h0 := keccak256(0x00,0x40)
            mstore(0x00,spender)
            mstore(0x20,h0)
            let h1 := keccak256(0x00,0x40)
            val := sload(h1)
        }
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(address from,address to,uint256 amount) internal {
        assembly{
            if iszero(and(from,to)) {
                revert(0,0)
            }
            let balance0 := getBal(from)  

            if iszero(or(gt(balance0,amount),eq(balance0,amount))) {
                revert(0,0)
            }
            mstore(0x00,from)
            let hash0 := keccak256(0x00,0x40)
            sstore(hash0,sub(balance0,amount))

            let balance1 := getBal(to)

            mstore(0x00,to)
            let hash1 := keccak256(0x00,0x40)
            sstore(hash1,add(balance1,amount))


            function getBal(account) -> bal{
                mstore(0x00,account)
                bal := sload(keccak256(0x00,0x40))
            }
        }
    }

    function _mint(address account, uint256 amount) internal  {
        assembly {
            if iszero(account) {
                revert(0,0)
            }

            let totalSup := sload(0x02)
            if lt(add(totalSup,amount),totalSup) {
                revert(0,0)
            }

            sstore(0x02,add(totalSup,amount))

            let accountBal := getBal(account)

            mstore(0x00,account)
            let hash := keccak256(0x00,0x40)
            sstore(hash,add(accountBal,amount))

            function getBal(acc) -> bal{
                mstore(0x00,acc)
                bal := sload(keccak256(0x00,0x40))
            }
        }
    }

    function _burn(address account, uint256 amount) internal {
        assembly {
            if iszero(account) {
                revert(0,0)
            }

            let accountBal := getBal(account)

            if lt(accountBal,amount) {
                revert(0,0)
            }

            mstore(0x00,account)
            let hash := keccak256(0x00,0x40)
            sstore(hash,sub(accountBal,amount))
            
            let totalSup := sload(0x02)
            sstore(0x02,sub(totalSup,amount))

            function getBal(acc) -> bal{
                mstore(0x00,acc)
                bal := sload(keccak256(0x00,0x40))
            }
        }
    }

    function _approve(address owner,address spender,uint256 amount) internal  {
        assembly {
            if iszero(and(owner,spender)) {
                revert(0,0)
            }

            mstore(0x00,owner)
            mstore(0x20,0x01)
            let h0 := keccak256(0x00,0x40)
            mstore(0x00,spender)
            mstore(0x20,h0)
            let h1 := keccak256(0x00,0x40)
            sstore(h1,amount)
        }
    }

    function _spendAllowance(address owner,address spender,uint256 amount) internal {
        uint256 currentAllowance = allowance(owner, spender);
        assembly{
            if iszero(eq(currentAllowance,0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)){
                if lt(currentAllowance,amount) {
                    revert(0,0)
                }
            }
        }
        _approve(owner, spender, currentAllowance - amount);
    }
}
