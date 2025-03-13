// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/Orca.sol";
import "../src/StakingContract.sol";

contract TestContract is Test {
    OrcaCoin orca;
    StakingContract stakingContract;

    function setUp() public {
        orca = new OrcaCoin(address(this));
        stakingContract = new StakingContract(address(orca));
        orca.updateStakingContract(address(stakingContract));
    }

    // testing if at start the total balance is zero or not.
    function testInitialize() public view {
        assert(orca.totalSupply() == 0);
    }

    // testing if another user can mint it or not
    function test_Revert_Condition() public {
        vm.prank(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        vm.expectRevert();
        orca.mint(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384, 10);
    }

    // testing if the owner can mint Orca coins or not
    function testMint() public {
        vm.prank(address(stakingContract));
        orca.mint(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384, 10);
        assert(orca.balanceOf(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384) == 10);
    }

    // test for updating the staking Contract
    function testChangeStakingContract() public {
        orca.updateStakingContract(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        assert(orca.accessContract() == 0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
    }

    // test if other user can change the staking contract
    function test_stakingContract_doesntMatch() public {
        vm.prank(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        vm.expectRevert();
        orca.updateStakingContract(address(this));
    }

    // test if stake is working
    function testStake() public {
        uint value = 10 ether;
        stakingContract.stake{ value: value }();

        assert(stakingContract.totalAmount() == value);
    }

    // test for failing unStake with more value
    function test_Stake_ValueMismatch() public {
        uint value = 10 ether;
        stakingContract.stake{ value: value }();
        vm.expectRevert();
        stakingContract.unStake(value + 1 ether);
    }

    // test to show Rewards [Orca balance]
    function testShowRewards() public {
        uint value = 1 ether;
        stakingContract.stake{ value: value }();

        // this is increasing the time by 2 hours
        vm.warp(block.timestamp + (2 * 60 * 60));

        uint256 rewards = stakingContract.showRewards((address(this)));

        assert(rewards == 2 ether);
    }

    // test for checking false Rewards collection
    // function test_NoRewards_LessTime() public {
    //     uint value = 1 ether;
    //     stakingContract.stake{ value: value }();

    //     // passing time by 60 seconds
    //     vm.warp(block.timestamp + 60);

    //     // as 60 secs has only passed so the user should not get any rewards
    //     uint rewards = stakingContract.showRewards(address(this));

    //     vm.expectRevert();
    //     assert(rewards >= 1 ether);
    // }

    function testClaimRewards() public {
        uint value = 1 ether;
        stakingContract.stake{ value: value }();

        // passing 1 hour so that the rewards [Orca coin] get increased
        vm.warp(block.timestamp + (60 * 60));
        
        stakingContract.claimRewards(1000000000000000000);

        uint balance = stakingContract.getOrcaBalance(address(this));

        assert(balance == 1000000000000000000);
    }

}
