// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";

import {ProtocolRewards} from "../src/ProtocolRewards.sol";

contract DeployScript is Script {
    uint256 internal deployerPK;

    function setUp() public {
        deployerPK = vm.envUint("DEPLOYER_PK");
    }

    function run() public {
        vm.startBroadcast(deployerPK);

        ProtocolRewards protocolRewards = new ProtocolRewards();

        console2.log("PROTOCOL REWARDS DEPLOYED:");
        console2.logAddress(address(protocolRewards));

        vm.stopBroadcast();
    }
}
