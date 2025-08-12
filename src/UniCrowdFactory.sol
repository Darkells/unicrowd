// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./Crowdfunding.sol";

contract UniCrowdFactory {
    address[] public crowdfundingProjects;
    mapping(address => address[]) public ownerProjects;

    event ProjectCreated(
        address indexed owner, address indexed projectAddress, string projectName, uint256 goal, uint256 duration
    );

    function createProject(uint256 _goal, uint256 _duration, string memory _projectName) external returns (address) {
        require(_goal > 0, "Goal must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        Crowdfunding newProject = new Crowdfunding(msg.sender, _goal, _duration, _projectName);
        crowdfundingProjects.push(address(newProject));
        ownerProjects[msg.sender].push(address(newProject));

        emit ProjectCreated(msg.sender, address(newProject), _projectName, _goal, _duration);

        return address(newProject);
    }

    function getProjects() external view returns (address[] memory) {
        return crowdfundingProjects;
    }

    function getOwnerProjects(address _owner) external view returns (address[] memory) {
        return ownerProjects[_owner];
    }
}
