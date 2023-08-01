// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {IProtocolRewards} from "../interfaces/IProtocolRewards.sol";

abstract contract RewardSplits {
    error CREATOR_FUNDS_RECIPIENT_NOT_SET();
    error INVALID_ADDRESS_ZERO();
    error INVALID_ETH_AMOUNT();
    error ONLY_CREATE_REFERRAL();

    uint256 internal constant TOTAL_REWARD_PER_MINT = 0.000777 ether;

    uint256 internal constant CREATOR_REWARD = 0.000333 ether;
    uint256 internal constant FIRST_MINTER_REWARD = 0.000111 ether;

    uint256 internal constant CREATE_REFERRAL_FREE_MINT_REWARD = 0.000111 ether;
    uint256 internal constant MINT_REFERRAL_FREE_MINT_REWARD = 0.000111 ether;
    uint256 internal constant ZORA_FREE_MINT_REWARD = 0.000111 ether;

    uint256 internal constant MINT_REFERRAL_PAID_MINT_REWARD = 0.000222 ether;
    uint256 internal constant CREATE_REFERRAL_PAID_MINT_REWARD = 0.000222 ether;
    uint256 internal constant ZORA_PAID_MINT_REWARD = 0.000222 ether;

    address internal immutable zoraRewardRecipient;
    IProtocolRewards internal immutable protocolRewards;

    constructor(address _protocolRewards, address _zoraRewardRecipient) payable {
        if (_protocolRewards == address(0) || _zoraRewardRecipient == address(0)) {
            revert INVALID_ADDRESS_ZERO();
        }

        protocolRewards = IProtocolRewards(_protocolRewards);
        zoraRewardRecipient = _zoraRewardRecipient;
    }

    function computeTotalReward(uint256 numTokens) public pure returns (uint256) {
        return numTokens * TOTAL_REWARD_PER_MINT;
    }

    function computeFreeMintRewards(
        uint256 numTokens
    ) public pure returns (uint256 creatorReward, uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) {
        creatorReward = numTokens * CREATOR_REWARD;
        mintReferralReward = numTokens * MINT_REFERRAL_FREE_MINT_REWARD;
        createReferralReward = numTokens * CREATE_REFERRAL_FREE_MINT_REWARD;
        firstMinterReward = numTokens * FIRST_MINTER_REWARD;
        zoraReward = numTokens * ZORA_FREE_MINT_REWARD;
    }

    function computePaidMintRewards(
        uint256 numTokens
    ) public pure returns (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) {
        mintReferralReward = numTokens * MINT_REFERRAL_PAID_MINT_REWARD;
        createReferralReward = numTokens * CREATE_REFERRAL_PAID_MINT_REWARD;
        firstMinterReward = numTokens * FIRST_MINTER_REWARD;
        zoraReward = numTokens * ZORA_PAID_MINT_REWARD;
    }

    function _depositFreeMintRewards(uint256 totalReward, uint256 numTokens, address creator, address mintReferral, address createReferral) internal {
        (
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = computeFreeMintRewards(numTokens);

        if (mintReferral == address(0)) {
            mintReferral = zoraRewardRecipient;
        }

        if (createReferral == address(0)) {
            createReferral = zoraRewardRecipient;
        }

        protocolRewards.depositRewards{value: totalReward}(
            creator,
            creatorReward,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            creator,
            firstMinterReward,
            zoraRewardRecipient,
            zoraReward
        );
    }

    function _depositPaidMintRewards(uint256 totalReward, uint256 numTokens, address creator, address mintReferral, address createReferral) internal {
        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = computePaidMintRewards(numTokens);

        if (mintReferral == address(0)) {
            mintReferral = zoraRewardRecipient;
        }

        if (createReferral == address(0)) {
            createReferral = zoraRewardRecipient;
        }

        protocolRewards.depositRewards{value: totalReward}(
            address(0),
            0,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            creator,
            firstMinterReward,
            zoraRewardRecipient,
            zoraReward
        );
    }
}
