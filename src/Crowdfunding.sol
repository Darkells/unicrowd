// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard {
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public fundingClosed;

    event Contribution(address indexed contributor, uint256 amount, string message);

    constructor(uint256 _goal, uint256 _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
        fundingClosed = false;
    }

    function contribute(string memory _message) external payable nonReentrant {
        require(!fundingClosed, "Crowdfunding is closed");
        require(block.timestamp < deadline, "Crowdfunding has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        totalRaised += msg.value;
        emit Contribution(msg.sender, msg.value, _message);

        if (totalRaised >= goal) {
            fundingClosed = true;
        }
    }

    function withdraw() external nonReentrant {
        require(msg.sender == owner, "Only owner can withdraw");
        require(fundingClosed || block.timestamp >= deadline, "Crowdfunding not yet closed");

        uint256 amount = address(this).balance;
        (bool sent,) = payable(owner).call{value: amount}("");
        require(sent, "Failed to withdraw funds");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
