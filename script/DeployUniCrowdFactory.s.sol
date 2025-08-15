// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/UniCrowdFactory.sol";

contract DeployUniCrowdFactory is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        UniCrowdFactory factory = new UniCrowdFactory();

        vm.stopBroadcast();

        console.log("UniCrowdFactory deployed at:", address(factory));
        console.log("Deployer address:", deployer);
    }
}
