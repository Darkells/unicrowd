// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/UniCrowdFactory.sol";
import "../src/Crowdfunding.sol";

contract UniCrowdFactoryTest is Test {
    UniCrowdFactory public factory;
    address public owner = address(1);
    address public contributor = address(2);
    uint256 public goal = 10 ether;
    uint256 public duration = 7 days;

    event ProjectCreated(
        address indexed owner, address indexed projectAddress, string name, uint256 goal, uint256 duration
    );

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(contributor, 100 ether);
        factory = new UniCrowdFactory();
    }

    function testCreateProject() public {
        uint256 nonce = vm.getNonce(address(factory));
        console.log("Factory nonce:", nonce);
        vm.prank(owner);
        address expectedAddress = vm.computeCreateAddress(address(factory), nonce);
        console.log("Expected address:", expectedAddress);
        vm.expectEmit(true, true, false, true);

        emit ProjectCreated(owner, expectedAddress, "Test Project", goal, duration);
        address projectAddress = factory.createProject(goal, duration, "Test Project");
        console.log("Actual project address:", projectAddress);

        assertEq(projectAddress, expectedAddress, "Project address mismatch");

        address[] memory projects = factory.getProjects();
        assertEq(projects.length, 1, "Projects array length should be 1");
        assertEq(projects[0], projectAddress, "Project address mismatch");

        address[] memory ownerProjects = factory.getOwnerProjects(owner);
        assertEq(ownerProjects.length, 1, "Owner projects length should be 1");
        assertEq(ownerProjects[0], projectAddress, "Owner project address mismatch");

        Crowdfunding project = Crowdfunding(projectAddress);
        assertEq(project.owner(), owner, "Project owner mismatch");
        assertEq(project.goal(), goal, "Project goal mismatch");
        assertEq(
            keccak256(abi.encode(project.projectName())), keccak256(abi.encode("Test Project")), "Project name mismatch"
        );
    }

    function testMultipleProjects() public {
        vm.startPrank(owner);
        address project1 = factory.createProject(goal, duration, "Project 1");
        address project2 = factory.createProject(goal * 2, duration * 2, "Project 2");
        vm.stopPrank();

        address[] memory projects = factory.getProjects();
        assertEq(projects.length, 2, "Projects array length should be 2");
        assertEq(projects[0], project1, "Project 1 address mismatch");
        assertEq(projects[1], project2, "Project 2 address mismatch");

        address[] memory ownerProjects = factory.getOwnerProjects(owner);
        assertEq(ownerProjects.length, 2, "Owner projects length should be 2");
        assertEq(ownerProjects[0], project1, "Owner project 1 mismatch");
        assertEq(ownerProjects[1], project2, "Owner project 2 mismatch");
    }
}
