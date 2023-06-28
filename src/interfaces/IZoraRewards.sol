// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IZoraRewards {
    event ZoraRewardsDeposit(address indexed from, address recipient, uint256 amount, string comment);
    event ZoraRewardsBatchDeposit(address indexed from, address[] recipients, uint256[] amounts, string comment);
    event ZoraFreeMintRewardsDeposit(
        address indexed from,
        address indexed creator,
        uint256 creatorReward,
        address finder,
        uint256 finderReward,
        address lister,
        uint256 listerReward,
        address zora,
        uint256 zoraReward
    );
    event ZoraPaidMintRewardsDeposit(
        address indexed from,
        address finder,
        uint256 finderReward,
        address lister,
        uint256 listerReward,
        address zora,
        uint256 zoraReward
    );
    event ZoraRewardsWithdraw(address indexed from, address recipient, uint256 amount);

    error INVALID_DEPOSIT();
    error INVALID_WITHDRAW();
    error RECIPIENTS_AND_AMOUNTS_LENGTH_MISMATCH();
    error TRANSFER_FAILED();
    error SIGNATURE_DEADLINE_EXPIRED();
    error INVALID_SIGNER();

    function deposit(address recipient, string calldata comment) external payable;
    function depositBatch(address[] calldata recipients, uint256[] calldata rewards, string calldata comment)
        external
        payable;
    function depositFreeMintRewards(
        address creator,
        uint256 creatorReward,
        address finder,
        uint256 finderReward,
        address lister,
        uint256 listerReward,
        address zora,
        uint256 zoraReward
    ) external payable;
    function depositPaidMintRewards(
        address finder,
        uint256 finderReward,
        address lister,
        uint256 listerReward,
        address zora,
        uint256 zoraReward
    ) external payable;
}
