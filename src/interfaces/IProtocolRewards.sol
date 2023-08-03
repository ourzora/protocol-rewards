// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/// @title IProtocolRewards
/// @notice The interface for deposits & withdrawals for Protocol Rewards
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

    /// @notice Deposit Event
    /// @param from From user
    /// @param to To user (within contract)
    /// @param reason Optional bytes4 reason for indexing
    /// @param amount Amount of deposit
    /// @param comment Optional user comment
    event Deposit(address indexed from, address indexed to, bytes4 indexed reason, uint256 amount, string comment);

    /// @notice Withdraw Event
    /// @param from From user
    /// @param to To user (within contract)
    /// @param amount Amount of deposit
    event Withdraw(address indexed from, address indexed to, uint256 amount);

    /// @notice Cannot send to address zero
    error ADDRESS_ZERO();
    /// @notice Function argument array length mismatch
    error ARRAY_LENGTH_MISMATCH();
    /// @notice Invalid deposit
    error INVALID_DEPOSIT();
    /// @notice Invalid signature for deposit
    error INVALID_SIGNATURE();
    /// @notice Invalid withdraw
    error INVALID_WITHDRAW();
    /// @notice Signature for withdraw is too old and has expired
    error SIGNATURE_DEADLINE_EXPIRED();
    /// @notice Low-level ETH transfer has failed
    error TRANSFER_FAILED();

    function deposit(address to, bytes4 why, string calldata comment) external payable;

    function depositBatch(address[] calldata recipients, uint256[] calldata amounts, bytes4[] calldata why, string calldata comment) external payable;

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
