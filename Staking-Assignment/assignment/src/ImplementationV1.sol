// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract ImplementationV1 { 
    uint public totalAmount;
    mapping(address => uint) stakedBalance;
    mapping(address => uint) orcaBalance;
    mapping(address => uint) stakingTime;

    constructor() {
        totalAmount = 0;
    }

    function stake() public payable {
        require(msg.value > 0, "Sending amount is 0!");

        // this means the sender has already staked some coins before
        if(stakedBalance[msg.sender] > 0) {
            
        }

        stakedBalance[msg.sender] += msg.value;
        startStaking();
    }

    function startStaking() private {
        stakingTime[msg.sender] = block.timestamp;
    }

}
