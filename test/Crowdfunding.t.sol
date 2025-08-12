// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/Crowdfunding.sol";

contract CrowdfundingTest is Test {
    Crowdfunding public crowdfunding;
    address public owner = address(1);
    address public contributor = address(2);
    uint256 public goal = 10 ether;
    uint256 public duration = 7 days;

    event Contribution(address indexed contributor, uint256 amount, string message);

    event Withdrawal(address indexed recipient, uint256 amount);

    event Refund(address indexed contributor, uint256 amount);

    function setUp() public {
        vm.deal(owner, 100 ether);
        vm.deal(contributor, 100 ether);
        vm.prank(owner);
        crowdfunding = new Crowdfunding(owner, goal, duration, "Test Project");
    }

    function testContribute() public {
        vm.prank(contributor);
        vm.expectEmit(true, true, false, true);
        emit Contribution(contributor, 1 ether, "Support Test Project!");
        crowdfunding.contribute{value: 1 ether}("Support Test Project!");
        assertEq(crowdfunding.totalRaised(), 1 ether);
        assertEq(crowdfunding.getBalance(), 1 ether);
        assertEq(crowdfunding.contributions(contributor), 1 ether);
    }

    function testWithdrawSuccess() public {
        vm.prank(contributor);
        crowdfunding.contribute{value: goal}("Support Test Project!");
        assertTrue(crowdfunding.fundingClosed());

        uint256 ownerBalanceBefore = owner.balance;
        vm.prank(owner);
        vm.expectEmit(true, true, false, true);
        emit Withdrawal(owner, goal);
        crowdfunding.withdraw();

        assertEq(crowdfunding.getBalance(), 0);
        assertEq(owner.balance, ownerBalanceBefore + goal);
    }

    function test_RevertWhen_NonOwnerWithdraws() public {
        vm.prank(contributor);
        crowdfunding.contribute{value: 1 ether}("Support Test Project!");

        vm.prank(contributor);
        vm.expectRevert("Only owner can withdraw");
        crowdfunding.withdraw();
    }

    function test_RevertWhen_WithdrawBeforeClosed() public {
        vm.prank(contributor);
        crowdfunding.contribute{value: 1 ether}("Support Test Project!");

        vm.prank(owner);
        vm.expectRevert("Crowdfunding not yet closed");
        crowdfunding.withdraw();
    }

    function testRefundSuccess() public {
        vm.prank(contributor);
        crowdfunding.contribute{value: 1 ether}("Support Test Project!");
        assertEq(crowdfunding.contributions(contributor), 1 ether);

        vm.warp(block.timestamp + duration + 1); // Past deadline
        assertTrue(crowdfunding.totalRaised() < goal);

        uint256 contributorBalanceBefore = contributor.balance;
        vm.prank(contributor);
        vm.expectEmit(true, true, false, true);
        emit Refund(contributor, 1 ether);
        crowdfunding.refund();

        assertEq(crowdfunding.contributions(contributor), 0);
        assertEq(crowdfunding.getBalance(), 0);
        assertEq(contributor.balance, contributorBalanceBefore + 1 ether);
    }

    function test_RevertWhen_RefundAfterSuccess() public {
        vm.prank(contributor);
        crowdfunding.contribute{value: goal}("Support Test Project!");
        assertTrue(crowdfunding.fundingClosed(), "Funding should be closed");
        assertEq(crowdfunding.totalRaised(), goal, "Total raised should equal goal");

        vm.warp(block.timestamp + duration + 1); // Past deadline

        vm.prank(contributor);
        vm.expectRevert("Crowdfunding succeeded, no refunds");
        crowdfunding.refund();
    }

    function testMultipleContributors() public {
        address contributor2 = address(3);
        vm.deal(contributor2, 100 ether);
        vm.prank(contributor);
        crowdfunding.contribute{value: 1 ether}("Support 1");
        vm.prank(contributor2);
        crowdfunding.contribute{value: 2 ether}("Support 2");
        assertEq(crowdfunding.totalRaised(), 3 ether);
    }
}
