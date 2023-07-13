// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";

import { ZoraRewards } from "../src/ZoraRewards.sol";

contract DeployScript is Script {
    uint256 internal deployerPK;

    function setUp() public {
        deployerPK = vm.envUint("DEPLOYER_PK");
    }

    function run() public {
        vm.startBroadcast(deployerPK);

        ZoraRewards zoraRewards = new ZoraRewards();

        console2.log("ZORA REWARDS DEPLOYED:");
        console2.logAddress(address(zoraRewards));

        vm.stopBroadcast();
    }
}
