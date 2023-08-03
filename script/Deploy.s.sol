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

        bytes32 salt = bytes32(0x0000000000000000000000000000000000000000849829cbf6881b00e4855576);
        // expected address: 0x77777770Ab38441aDA292bB340BBd6502e8E5808

        console2.log("creation code hash");
        bytes32 creationCodeHash = keccak256(creationCode);
        console2.logBytes32(creationCodeHash);

        // Assert to ensure bytecode has not changed
        assert(bytes32(0x55a411dda88b4f914a7ff1734681ea86b6c1438c7f9506e02ad6f687861564bb) == creationCodeHash);

        // Sanity check for address
        assert(IMMUTABLE_CREATE2_FACTORY.findCreate2Address(salt, creationCode) == address(0x77777777d5141a9F017CA8F2A42A0e6925bee18A));

        address result = IMMUTABLE_CREATE2_FACTORY.safeCreate2(salt, creationCode);

        console2.log("PROTOCOL REWARDS DEPLOYED:");
        console2.logAddress(address(result));

        vm.stopBroadcast();
    }
}
