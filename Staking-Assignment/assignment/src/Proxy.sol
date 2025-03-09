// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Proxy is Ownable { 
    uint public totalAmount;
    mapping(address => uint) stakedBalance;
    mapping(address => uint) orcaBalance;
    address private implementation;

    constructor(address _implementation) Ownable(msg.sender) {
        implementation = _implementation;
    }

    function changeImplementation(address _implementation) public onlyOwner {
        implementation = _implementation;
    }

    fallback() external {
        ( bool success, ) = implementation.delegatecall(msg.data);

        require(success, "delegatecall failed!");
    }

}
