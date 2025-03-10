// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract { 
    uint public totalAmount;
    address orca;
    mapping(address => uint) stakedBalance;
    mapping(address => uint) unStakingTime;
    mapping(address => uint) orcaBalance;
    mapping(address => uint) stakingTime;

    event transfer(address indexed from, address indexed to, uint256 amount);

    constructor(address _orca) {
        orca = _orca;
        totalAmount = 0;
    }

    function stake() public payable {
        require(msg.value > 0, "Sending amount is 0!");

        // this means the sender has already staked some coins before
        if(stakedBalance[msg.sender] > 0) {
            increaseStaking();
            return;
        }

        // this means user staked for the first time
        stakedBalance[msg.sender] += msg.value;
        startStaking();
        emit transfer(msg.sender, orca, msg.value);
    }

    function startStaking() private {
        stakingTime[msg.sender] = block.timestamp;
    }

    function increaseStaking() private {
        // this will give the time difference from the last change add/sub done.
        uint timeDifference = block.timestamp - stakedBalance[msg.sender];
        // for every hour give the user 1 orca or to be more precise for every min give the user 1/60 orca coin.
        // and this should also see the ETH balance and give the orca coin accordingly.
        // add the balance to the orcaBalance[msg.sender] += calculatedBalance;
        // make the stakedBalance[msg.sender] = block.timestamp - left time (in secs or whatever);
    }

    function unStake(uint amount) public {
        require(amount > 0, "amount can't be 0!");
        require(stakedBalance[msg.sender] >= amount, "In-sufficient balance");
        uint TimeDiff = block.timestamp - unStakingTime[msg.sender];
        if(TimeDiff > 21 * 24 * 60 * 60) {
            // transfer the ETH
            orca.mint(msg.sender, amount);
            emit transfer(orca, msg.sender, amount);
            return;
        } else if(TimeDiff < 21 * 24 * 60 * 60) {
            // already a un-staking time is running
            return;
        }
        startUnStakingTime();
    }

    function startUnStakingTime() private {
        // write the logic for not increasing the balance for the unStaking time-period.
        unStakingTime[msg.sender] = block.timestamp;
    }

}
