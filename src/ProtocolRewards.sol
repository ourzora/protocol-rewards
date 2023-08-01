// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {EIP712} from "./lib/EIP712.sol";
import {IProtocolRewards} from "./interfaces/IProtocolRewards.sol";

contract ProtocolRewards is IProtocolRewards, EIP712 {
    bytes32 public constant WITHDRAW_TYPEHASH = keccak256("Withdraw(address owner,uint256 amount,uint256 nonce,uint256 deadline)");

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public nonces;

    constructor() payable EIP712("ProtocolRewards", "1") {}

    function totalSupply() external view returns (uint256) {
        return address(this).balance;
    }

    function deposit(address recipient, string calldata comment) external payable {
        if (recipient == address(0)) {
            revert ADDRESS_ZERO();
        }

        unchecked {
            balanceOf[recipient] += msg.value;
        }

        emit Deposit(msg.sender, recipient, msg.value, comment);
    }

    function depositBatch(address[] calldata recipients, uint256[] calldata amounts, string calldata comment) external payable {
        uint256 numRecipients = recipients.length;

        if (numRecipients != amounts.length) {
            revert ARRAY_LENGTH_MISMATCH();
        }

        uint256 expectedTotalValue;

        for (uint256 i; i < numRecipients; ) {
            expectedTotalValue += amounts[i];

            unchecked {
                ++i;
            }
        }

        if (msg.value != expectedTotalValue) {
            revert INVALID_DEPOSIT();
        }

        address currentRecipient;
        uint256 currentAmount;

        for (uint256 i; i < numRecipients; ) {
            currentRecipient = recipients[i];
            currentAmount = amounts[i];

            if (currentRecipient == address(0)) {
                revert ADDRESS_ZERO();
            }

            unchecked {
                balanceOf[currentRecipient] += currentAmount;
            }

            emit Deposit(msg.sender, currentRecipient, currentAmount, comment);

            unchecked {
                ++i;
            }
        }
    }

    function depositRewards(
        address creator,
        uint256 creatorReward,
        address mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address firstMinter,
        uint256 firstMinterReward,
        address zora,
        uint256 zoraReward
    ) external payable {
        if (msg.value != (creatorReward + mintReferralReward + createReferralReward + firstMinterReward + zoraReward)) {
            revert INVALID_DEPOSIT();
        }

        unchecked {
            if (creator != address(0)) {
                balanceOf[creator] += creatorReward;
            }
            if (mintReferral != address(0)) {
                balanceOf[mintReferral] += mintReferralReward;
            }
            if (createReferral != address(0)) {
                balanceOf[createReferral] += createReferralReward;
            }
            if (firstMinter != address(0)) {
                balanceOf[firstMinter] += firstMinterReward;
            }
            if (zora != address(0)) {
                balanceOf[zora] += zoraReward;
            }
        }

        emit RewardsDeposit(
            msg.sender,
            creator,
            creatorReward,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            firstMinter,
            firstMinterReward,
            zora,
            zoraReward
        );
    }

    function withdraw(uint256 amount) external {
        address owner = msg.sender;

        if (amount > balanceOf[owner]) {
            revert INVALID_WITHDRAW();
        }

        unchecked {
            balanceOf[owner] -= amount;
        }

        emit Withdraw(owner, amount);

        (bool success, ) = owner.call{value: amount}("");

        if (!success) {
            revert TRANSFER_FAILED();
        }
    }

    function withdrawWithSig(address owner, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        if (block.timestamp > deadline) {
            revert SIGNATURE_DEADLINE_EXPIRED();
        }

        bytes32 withdrawHash;

        unchecked {
            withdrawHash = keccak256(abi.encode(WITHDRAW_TYPEHASH, owner, amount, nonces[owner]++, deadline));
        }

        bytes32 digest = _hashTypedDataV4(withdrawHash);

        address recoveredAddress = ecrecover(digest, v, r, s);

        if (recoveredAddress == address(0) || recoveredAddress != owner) {
            revert INVALID_SIGNATURE();
        }

        if (amount > balanceOf[owner]) {
            revert INVALID_WITHDRAW();
        }

        unchecked {
            balanceOf[owner] -= amount;
        }

        emit Withdraw(owner, amount);

        (bool success, ) = owner.call{value: amount}("");

        if (!success) {
            revert TRANSFER_FAILED();
        }
    }
}
