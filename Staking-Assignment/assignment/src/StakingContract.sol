// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface IOrcaCoin {
    function mint(address account, uint256 amount) external;
}

contract StakingContract { 
    uint public totalAmount;
    address private  orca;
    mapping(address => uint) stakedBalance;
    mapping(address => uint) unStakingTime;
    mapping(address => uint) public orcaBalance;
    mapping(address => uint) stakingTime;
    mapping(address => uint) unStakingBalance;

    IOrcaCoin public orcaCoin;

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
        totalAmount += msg.value;
    }

    function increaseStaking() private {
        updateOrcaBalance();

        // increase the stakedBalance
        stakedBalance[msg.sender] += msg.value;
        totalAmount += msg.value;
        
        // make the stakingTime[msg.sender] = block.timestamp - left time (in secs or whatever);
        // but this is not correct completely as this will increase time even for the new staked balance.
        // so, fresh start the time;
        stakingTime[msg.sender] = block.timestamp;

        emit transfer(msg.sender, orca, msg.value);
    }

    function unStake(uint amount) public {
        require(amount > 0, "amount can't be 0!");
        require(stakedBalance[msg.sender] >= amount, "In-sufficient balance");
        uint TimeDiff = block.timestamp - unStakingTime[msg.sender];
        if(TimeDiff > 21 * 24 * 60 * 60) {
            // transfer the ETH
            // orca.mint(msg.sender, amount);
            unStakingBalance[msg.sender] = 0;
            unStakingTime[msg.sender] = 0;
            totalAmount -= amount;
            emit transfer(orca, msg.sender, amount);
            return;
        
        // I have written the logic so that if a unStaking time is running user can't unstake another amount or inc/dec the prev amount, improve it as required
        } else if(unStakingTime[msg.sender] != 0) {
            // return! because a un-staking is already running
            return;
        } else {
            // if no un-staking time, start one
            startUnStakingTime(amount);
        }
        
    }

    function startUnStakingTime(uint256 amount) private {
        // logic for not increasing the balance for the unStaking time-period.
        // stakedBalance[msg.sender] -= amount;
        decreaseStakingAmount(amount);
        unStakingBalance[msg.sender] += amount;
        unStakingTime[msg.sender] = block.timestamp;
    }

    function decreaseStakingAmount(uint256 amount) private {
        updateOrcaBalance();

        // decrease the staked balance
        stakedBalance[msg.sender] -= amount;

        // fresh start the time
        stakingTime[msg.sender] = block.timestamp;

    }

    // this will show the rewards [Orca Coins] collected
    function showRewards(address _address) public returns(uint) {
        updateOrcaBalance();
        return orcaBalance[_address];
    }

    // this is to withdraw the rewards [Orca coins] for staking our native token
    function claimRewards(uint256 amount) public {
        require(amount > 0, "Enter an amount!");
        updateOrcaBalance();
        require(orcaBalance[msg.sender] >= amount, "In-sufficient balance!");
        
        orcaBalance[msg.sender] -= amount;
        // mint new Orca coins and transfer them to the user
        orcaCoin.mint(msg.sender, amount);
        emit transfer(orca, msg.sender, amount);
    }

    function updateOrcaBalance() private {
        // this will give the time difference from the last change add/sub done.
        uint timeDifference = block.timestamp - stakingTime[msg.sender];
        // for every hour give the user 1 orca or to be more precise for every min give the user 1/60 orca coin.
        // and this should also see the ETH balance and give the orca coin accordingly.
        uint calHours = timeDifference / (60 * 60);
        // uint leftTime = timeDifference % (60 * 60);

        // calculate the orca balance for the past staked balance
        uint pastBalance = calHours * stakedBalance[msg.sender];
        orcaBalance[msg.sender] += pastBalance;
    }

    function getOrcaBalance(address _address) public view returns(uint) {
        return orcaBalance[_address];
    }

}
