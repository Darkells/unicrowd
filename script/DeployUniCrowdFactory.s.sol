// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/UniCrowdFactory.sol";

contract DeployUniCrowdFactory is Script {
    function run() external {
        vm.startBroadcast();
        UniCrowdFactory factory = new UniCrowdFactory();
        vm.stopBroadcast();
        console.log("UniCrowdFactory deployed at:", address(factory));
    }
}
