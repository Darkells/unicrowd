// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard {
    struct Project {
        address owner;
        uint256 goal;
        uint256 deadline;
        uint256 totalRaised;
        bool fundingClosed;
        bytes32 metaDataHash;
    }

    Project public project;
    mapping(address => uint256) public contributions;

    event Contribution(address indexed contributor, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    event Refund(address indexed contributor, uint256 amount);

    constructor(address _owner, uint256 _goal, uint256 _duration, bytes32 _metaDataHash) {
        require(_owner != address(0), "Invalid owner address");
        require(_goal > 0, "Goal must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        project = Project({
            owner: _owner,
            goal: _goal,
            deadline: block.timestamp + _duration,
            totalRaised: 0,
            fundingClosed: false,
            metaDataHash: _metaDataHash
        });
    }

    function contribute() external payable nonReentrant {
        require(!project.fundingClosed, "Crowdfunding is closed");
        require(block.timestamp < project.deadline, "Crowdfunding has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        project.totalRaised += msg.value;
        emit Contribution(msg.sender, msg.value);

        if (project.totalRaised >= project.goal) {
            project.fundingClosed = true;
        }
    }

    function withdraw() external nonReentrant {
        require(msg.sender == project.owner, "Only owner can withdraw");
        require(project.fundingClosed || block.timestamp >= project.deadline, "Crowdfunding not yet closed");
        require(address(this).balance > 0, "No funds to withdraw");

        uint256 amount = address(this).balance;
        emit Withdrawal(msg.sender, amount);

        (bool sent,) = payable(project.owner).call{value: amount}("");
        require(sent, "Failed to withdraw funds");
    }

    function refund() external nonReentrant {
        require(project.fundingClosed || block.timestamp >= project.deadline, "Crowdfunding not yet closed");
        require(project.totalRaised < project.goal, "Crowdfunding succeeded, no refunds");
        require(contributions[msg.sender] > 0, "No contributions to refund");

        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        project.totalRaised -= amount;

        emit Refund(msg.sender, amount);

        (bool sent,) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to refund funds");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Getter functions for backward compatibility
    function owner() external view returns (address) {
        return project.owner;
    }

    function goal() external view returns (uint256) {
        return project.goal;
    }

    function deadline() external view returns (uint256) {
        return project.deadline;
    }

    function totalRaised() external view returns (uint256) {
        return project.totalRaised;
    }

    function fundingClosed() external view returns (bool) {
        return project.fundingClosed;
    }

    function metaDataHash() external view returns (bytes32) {
        return project.metaDataHash;
    }
}
