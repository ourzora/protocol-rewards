// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ScriptBase.sol";

import {console2} from "forge-std/console2.sol";

import {ProtocolRewards} from "../src/ProtocolRewards.sol";

contract DeployScript is ScriptBase {
    function run() public {
        vm.startBroadcast(deployer);

        // ProtocolRewards protocolRewards = new ProtocolRewards();

        bytes memory creationCode = type(ProtocolRewards).creationCode;

        bytes32 salt = bytes32(0x0000000000000000000000000000000000000000fb7140769db7a400af50b6d6);

        console2.log("creation code hash");
        bytes32 creationCodeHash = keccak256(creationCode);
        console2.logBytes32(creationCodeHash);

        // Assert to ensure bytecode has not changed
        assert(bytes32(0x8a7c66f57af581632f3382bbedad1947c9d00b95709daefeb2b64a913f9c0f52) == creationCodeHash);

        // Sanity check for address
        assert(IMMUTABLE_CREATE2_FACTORY.findCreate2Address(salt, creationCode) == address(0x7777777A456fF23D9b6851184472c08FBDa73e32));

        address result = IMMUTABLE_CREATE2_FACTORY.safeCreate2(salt, creationCode);

        console2.log("PROTOCOL REWARDS DEPLOYED:");
        console2.logAddress(address(result));

        vm.stopBroadcast();
    }
}
