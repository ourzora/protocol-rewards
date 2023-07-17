// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IZoraRewards {
    event Deposit(address indexed from, address indexed recipient, uint256 indexed amount);
    event RewardsDeposit(
        address from,
        address indexed creator,
        uint256 creatorReward,
        address indexed mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address indexed firstMinter,
        uint256 firstMinterReward,
        address zora,
        uint256 zoraReward
    );
    event Withdraw(address indexed owner, uint256 indexed amount);

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
    ) external payable;

    error ADDRESS_ZERO();
    error ARRAY_LENGTH_MISMATCH();
    error INVALID_DEPOSIT();
    error INVALID_SIGNATURE();
    error INVALID_WITHDRAW();
    error SIGNATURE_DEADLINE_EXPIRED();
    error TRANSFER_FAILED();
}
