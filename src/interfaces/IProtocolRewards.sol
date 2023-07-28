// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IProtocolRewards {
    event Deposit(address indexed from, address indexed recipient, uint256 amount, string comment);
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

    error ADDRESS_ZERO();
    error ARRAY_LENGTH_MISMATCH();
    error INVALID_DEPOSIT();
    error INVALID_SIGNATURE();
    error INVALID_WITHDRAW();
    error SIGNATURE_DEADLINE_EXPIRED();
    error TRANSFER_FAILED();

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
    function depositTo(address recipient, string calldata comment) external payable;
    function depositToBatch(address[] calldata recipients, uint256[] calldata amounts, string calldata comment)
        external
        payable;
    function withdraw(uint256 amount) external;
    function withdrawWithSig(address owner, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
}
