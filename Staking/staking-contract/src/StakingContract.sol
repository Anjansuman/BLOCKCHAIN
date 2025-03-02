// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Ownable { 
    uint private totalStakedAmount;
    mapping(address => uint) balances;

    constructor() Ownable(msg.sender) {

    }

    function totalStaked() public view returns(uint) {
        return totalStakedAmount;
    }

    function stake(uint _amount) public payable {
        require(msg.value == _amount);
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        totalStakedAmount += msg.value;
    }

    function unstake(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough balance!");
        payable(address(msg.sender)).transfer(_amount / 2);
        balances[msg.sender] -= _amount;
        totalStakedAmount -= _amount;
    }
}
