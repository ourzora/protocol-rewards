// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IMintRewards {
    event FreeMintRewards(
        address indexed creator,
        uint256 creatorReward,
        address indexed finder,
        uint256 finderReward,
        address indexed lister,
        uint256 listerReward,
        address zora,
        uint256 zoraReward
    );

    event PaidMintRewards(
        address indexed finder,
        uint256 finderReward,
        address indexed lister,
        uint256 listerReward,
        address zora,
        uint256 zoraReward
    );

    error INVALID_ADDRESS_ZERO();
    error INSUFFICIENT_ETH_FOR_REWARDS();
    error CREATOR_REWARD_TRANSFER_FAILED();
}
