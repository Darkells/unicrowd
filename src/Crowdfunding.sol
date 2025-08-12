// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard {
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public fundingClosed;
    string public projectName;
    mapping(address => uint256) public contributions;

    event Contribution(address indexed contributor, uint256 amount, string message);
    event Withdrawal(address indexed recipient, uint256 amount);
    event Refund(address indexed contributor, uint256 amount);

    constructor(address _owner, uint256 _goal, uint256 _duration, string memory _projectName) {
        require(_owner != address(0), "Invalid owner address");
        require(_goal > 0, "Goal must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        owner = _owner;
        goal = _goal;
        deadline = block.timestamp + _duration;
        projectName = _projectName;
        fundingClosed = false;
    }

    function contribute(string memory _message) external payable nonReentrant {
        require(!fundingClosed, "Crowdfunding is closed");
        require(block.timestamp < deadline, "Crowdfunding has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
        emit Contribution(msg.sender, msg.value, _message);

        if (totalRaised >= goal) {
            fundingClosed = true;
        }
    }

    function withdraw() external nonReentrant {
        require(msg.sender == owner, "Only owner can withdraw");
        require(fundingClosed || block.timestamp >= deadline, "Crowdfunding not yet closed");
        require(address(this).balance > 0, "No funds to withdraw");

        uint256 amount = address(this).balance;
        emit Withdrawal(msg.sender, amount);

        (bool sent,) = payable(owner).call{value: amount}("");
        require(sent, "Failed to withdraw funds");
    }

    function refund() external nonReentrant {
        require(fundingClosed || block.timestamp >= deadline, "Crowdfunding not yet closed");
        require(totalRaised < goal, "Crowdfunding succeeded, no refunds");
        require(contributions[msg.sender] > 0, "No contributions to refund");

        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        totalRaised -= amount;

        emit Refund(msg.sender, amount);

        (bool sent,) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to refund funds");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
