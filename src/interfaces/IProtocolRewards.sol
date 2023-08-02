// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/// @title IProtocolRewards
/// @notice The interface for deposits & withdrawals of protocol rewards
interface IProtocolRewards {
    event RewardsDeposit(
        address indexed creator,
        address indexed createReferral,
        address indexed mintReferral,
        address firstMinter,
        address zora,
        address from,
        uint256 creatorReward,
        uint256 createReferralReward,
        uint256 mintReferralReward,
        uint256 firstMinterReward,
        uint256 zoraReward
    );
    event Deposit(address indexed from, address indexed to, uint256 amount, string comment);
    event Withdraw(address indexed from, address indexed to, uint256 amount);

    error ADDRESS_ZERO();
    error ARRAY_LENGTH_MISMATCH();
    error INVALID_DEPOSIT();
    error INVALID_SIGNATURE();
    error INVALID_WITHDRAW();
    error SIGNATURE_DEADLINE_EXPIRED();
    error TRANSFER_FAILED();

    function deposit(address to, string calldata comment) external payable;

    function depositBatch(address[] calldata recipients, uint256[] calldata amounts, string calldata comment) external payable;

    function depositRewards(
        address creator,
        uint256 creatorReward,
        address createReferral,
        uint256 createReferralReward,
        address mintReferral,
        uint256 mintReferralReward,
        address firstMinter,
        uint256 firstMinterReward,
        address zora,
        uint256 zoraReward
    ) external payable;

    function withdraw(address to, uint256 amount) external;

    function withdrawWithSig(address from, address to, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
}
