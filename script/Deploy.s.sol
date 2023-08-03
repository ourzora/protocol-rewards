// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScriptBase.sol";

import {console2} from "forge-std/console2.sol";

import {ProtocolRewards} from "../src/ProtocolRewards.sol";

contract DeployScript is ScriptBase {

    function run() public {
        vm.startBroadcast(deployer);

        ProtocolRewards protocolRewards = new ProtocolRewards();

        bytes memory creationCode = type(ProtocolRewards).creationCode;

        bytes32 salt = bytes32(0x0);

        console2.log("creation code hash");
        console2.logBytes32(keccak256(creationCode));

        IMMUTABLE_CREATE2_FACTORY.safeCreate2(salt, creationCode);

        console2.log("PROTOCOL REWARDS DEPLOYED:");
        console2.logAddress(address(protocolRewards));

        vm.stopBroadcast();
    }
}
