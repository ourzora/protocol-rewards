// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { MintRewards } from "../common/MintRewards.sol";

abstract contract ERC1155Rewards is MintRewards {
    constructor(address _zoraRewards, address _zoraRewardRecipient)
        payable
        MintRewards(_zoraRewards, _zoraRewardRecipient)
    { }

    function _handleRewardsAndGetValueSent(
        uint256 msgValue,
        uint256 numTokens,
        address creator,
        address mintReferral,
        address createReferral
    ) internal returns (uint256) {
        if (creator == address(0)) revert CREATOR_FUNDS_RECIPIENT_NOT_SET();

        uint256 totalReward = computeTotalReward(numTokens);

        if (msgValue < totalReward) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        } else if (msgValue == totalReward) {
            _handleFreeMintRewards(numTokens, creator, mintReferral, createReferral);

            return 0;
        } else {
            _handlePaidMintRewards(numTokens, creator, mintReferral, createReferral);

            unchecked {
                return msgValue - totalReward;
            }
        }
    }

    function _handleFreeMintRewards(uint256 numTokens, address creator, address mintReferral, address createReferral)
        private
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

    function _handlePaidMintRewards(uint256 numTokens, address creator, address mintReferral, address createReferral)
        private
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
