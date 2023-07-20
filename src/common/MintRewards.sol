// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { IZoraRewards } from "../interfaces/IZoraRewards.sol";

abstract contract MintRewards {
    error INVALID_ADDRESS_ZERO();
    error CREATOR_FUNDS_RECIPIENT_NOT_SET();
    error INSUFFICIENT_ETH_FOR_REWARDS();

    uint256 internal constant TOTAL_REWARD_PER_MINT = 0.000999 ether;

    uint256 internal constant MINT_REFERRAL_FREE_MINT_REWARD = 0.000111 ether;
    uint256 internal constant CREATE_REFERRAL_FREE_MINT_REWARD = 0.000111 ether;
    uint256 internal constant MINT_REFERRAL_PAID_MINT_REWARD = 0.000333 ether;
    uint256 internal constant CREATE_REFERRAL_PAID_MINT_REWARD = 0.000333 ether;

    uint256 internal constant CREATOR_REWARD = 0.000444 ether;
    uint256 internal constant FIRST_MINTER_REWARD = 0.000111 ether;
    uint256 internal constant ZORA_REWARD = 0.000222 ether;

    address internal immutable ZORA_REWARD_RECIPIENT;
    IZoraRewards internal immutable ZORA_REWARDS;

    constructor(address _zoraRewards, address _zoraRewardRecipient) payable {
        if (_zoraRewards == address(0) || _zoraRewardRecipient == address(0)) {
            revert INVALID_ADDRESS_ZERO();
        }

        ZORA_REWARDS = IZoraRewards(_zoraRewards);
        ZORA_REWARD_RECIPIENT = _zoraRewardRecipient;
    }

    function computeTotalReward(uint256 numTokens) public pure returns (uint256) {
        return numTokens * TOTAL_REWARD_PER_MINT;
    }

    function computeFreeMintRewards(uint256 numTokens)
        public
        pure
        returns (
            uint256 totalReward,
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        )
    {
        totalReward = computeTotalReward(numTokens);
        creatorReward = numTokens * CREATOR_REWARD;
        mintReferralReward = numTokens * MINT_REFERRAL_FREE_MINT_REWARD;
        createReferralReward = numTokens * CREATE_REFERRAL_FREE_MINT_REWARD;
        firstMinterReward = numTokens * FIRST_MINTER_REWARD;
        zoraReward = numTokens * ZORA_REWARD;
    }

    function computePaidMintRewards(uint256 numTokens)
        public
        pure
        returns (
            uint256 totalReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        )
    {
        totalReward = computeTotalReward(numTokens);
        mintReferralReward = numTokens * MINT_REFERRAL_PAID_MINT_REWARD;
        createReferralReward = numTokens * CREATE_REFERRAL_PAID_MINT_REWARD;
        firstMinterReward = numTokens * FIRST_MINTER_REWARD;
        zoraReward = numTokens * ZORA_REWARD;
    }

    function _depositFreeMintRewards(uint256 numTokens, address creator, address mintReferral, address createReferral)
        internal
    {
        (
            uint256 totalReward,
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = computeFreeMintRewards(numTokens);

        if (mintReferral == address(0)) {
            mintReferral = ZORA_REWARD_RECIPIENT;
        }

        if (createReferral == address(0)) {
            createReferral = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.depositRewards{ value: totalReward }(
            creator,
            creatorReward,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            creator, //
            firstMinterReward,
            ZORA_REWARD_RECIPIENT,
            zoraReward
        );
    }

    function _depositPaidMintRewards(uint256 numTokens, address creator, address mintReferral, address createReferral)
        internal
    {
        (
            uint256 totalReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = computePaidMintRewards(numTokens);

        if (mintReferral == address(0)) {
            mintReferral = ZORA_REWARD_RECIPIENT;
        }

        if (createReferral == address(0)) {
            createReferral = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.depositRewards{ value: totalReward }(
            address(0),
            0,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            creator, //
            firstMinterReward,
            ZORA_REWARD_RECIPIENT,
            zoraReward
        );
    }
}
