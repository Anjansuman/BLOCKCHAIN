// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/StakingContract.sol";

contract StakingTestContract is Test {
    StakingContract c;

    function setUp() public {
        c = new StakingContract();
    }

    function testStake() public {
        uint value = 10 ether;
        c.stake{value: value}(value);
        assert(c.totalStaked() == value);
    }

    function testUnStake() public {
        uint value = 10 ether;
        vm.startPrank(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        vm.deal(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384, value);
        c.stake{value: value}(value);
        c.unstake(value);
        assert(c.totalStaked() == value / 2);
    }
}
