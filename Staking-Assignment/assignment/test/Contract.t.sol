// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/Orca.sol";

contract TestContract is Test {
    OrcaCoin orca;

    function setUp() public {
        orca = new OrcaCoin(address(this));
    }

    function testInitialize() public view {
        assert(orca.totalSupply() == 0);
    }

    function test_Revert_Condition() public {
        vm.prank(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        vm.expectRevert();
        orca.mint(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384, 10);
    }

    function testMint() public {
        orca.mint(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384, 10);
        assert(orca.balanceOf(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384) == 10);
    }

    function testChangeStakingContract() public {
        orca.updateStakingContract(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        assert(orca.accessContract() == 0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
    }

    function test_stakingContract_doesntMatch() public {
        vm.prank(0x24ce9869A0AAECAeA14761Ecfaaf72E24755E384);
        vm.expectRevert();
        orca.updateStakingContract(address(this));
    }
}
