// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IZoraRewards {
    event Deposit(address indexed from, address indexed recipient, uint256 indexed amount);
    event DepositCreatorRewards(
        address from,
        address indexed creator,
        uint256 creatorReward,
        address indexed mintReferral,
        uint256 mintReferralReward,
        address indexed createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    );
    event Withdraw(address indexed owner, uint256 indexed amount);

    error ADDRESS_ZERO();
    error ARRAY_LENGTH_MISMATCH();
    error INVALID_DEPOSIT();
    error INVALID_SIGNATURE();
    error INVALID_WITHDRAW();
    error SIGNATURE_DEADLINE_EXPIRED();
    error TRANSFER_FAILED();
}
