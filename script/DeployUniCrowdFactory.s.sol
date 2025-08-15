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
        
        // 输出部署信息供前端使用
        console.log("=== Deployment Info ===");
        console.log("Network: Anvil Local");
        console.log("Chain ID: 31337");
        console.log("Factory Address:", address(factory));
        console.log("Deployer:", deployer);
    }
}