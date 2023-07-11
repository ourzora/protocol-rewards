// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IZoraRewards {
    event ZoraRewardsMint(
        bytes4 indexed rewardType,
        address from,
        address indexed creator,
        uint256 creatorReward,
        address indexed mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    );
    event ZoraRewardsMint(address indexed from, address indexed recipient, uint256 indexed reward, string comment);
    event ZoraRewardsBurn(address indexed from, address indexed recipient, uint256 amount);

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
        address mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    ) external payable;
    function depositPaidMintRewards(
        address mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    ) external payable;
}
