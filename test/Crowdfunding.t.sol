// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/Crowdfunding.sol";

contract CrowdfundingTest is Test {
    event Contribution(address indexed contributor, uint256 amount, string message);
    Crowdfunding public crowdfunding;
    address public owner = address(1);
    address public contributor = address(2);
    uint256 public goal = 10 ether;
    uint256 public duration = 7;

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(contributor, 100 ether);
        vm.prank(owner);
        crowdfunding = new Crowdfunding(goal, duration);
    }

    function testContribute() public {
        vm.prank(contributor);
        vm.expectEmit(true, true, false, true);
        emit Contribution(contributor, 1 ether, "Support UniCrowd!");
        crowdfunding.contribute{value: 1 ether}("Support UniCrowd!");
        assertEq(crowdfunding.totalRaised(), 1 ether);
    }
}