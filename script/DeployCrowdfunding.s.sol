// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Crowdfunding.sol";

contract DeployCrowdfunding is Script {
    function run() external {
        vm.startBroadcast();
        Crowdfunding crowdfunding = new Crowdfunding(10 ether, 7); // 目标10 ETH，7天
        vm.stopBroadcast();
    }
}