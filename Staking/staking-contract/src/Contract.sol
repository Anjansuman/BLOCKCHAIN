// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Ownable { 
    uint private totalStakedAmount;
    mapping(address => uint) balances;

    constructor() Ownable(msg.sender) {

    }

    function stake(uint _amount) public {
        balances[msg.sender] += _amount;
        totalStakedAmount += _amount;
    }

    function unStake(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough balance!");
        balances[msg.sender] -= _amount;
        totalStakedAmount -= _amount;
    }
}
