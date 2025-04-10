// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

interface IOwnable {
    function owner() external view returns (address);
}

contract OrcaCoin is ERC20, Ownable {
    address private stakingContract;
    IOwnable public ownedBy;

    constructor(address _stakingContract) ERC20("OrcaCoin", "Orca") Ownable(msg.sender) {
        stakingContract = _stakingContract;
    }

    function mint(address account, uint256 value) public {
        require(msg.sender == stakingContract || ownedBy.owner() == msg.sender);
        _mint(account, value);
    }

    function updateStakingContract(address _stakingContract) public onlyOwner {
        stakingContract = _stakingContract;
    }

    function accessContract() public view returns(address) {
        return stakingContract;
    }

}