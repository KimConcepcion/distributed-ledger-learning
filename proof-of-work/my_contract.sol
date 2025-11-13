// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleToken {
    mapping(address => uint256) public balance;

    constructor() {
        balance[msg.sender] = 10000; // giv deployeren lidt at lege med
    }

    function transfer(address to, uint256 amount) public {
        require(balance[msg.sender] >= amount, "Not enough tokens");
        balance[msg.sender] -= amount;
        balance[to] += amount;
    }
}
