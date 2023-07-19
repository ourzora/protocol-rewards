// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { MintRewards } from "../common/MintRewards.sol";

abstract contract ERC721Rewards is MintRewards {
    constructor(address _zoraRewards, address _zoraRewardRecipient)
        payable
        MintRewards(_zoraRewards, _zoraRewardRecipient)
    { }

    function _handleRewards(
        uint256 msgValue,
        uint256 numTokens,
        uint256 salePrice,
        address creator,
        address mintReferral,
        address createReferral
    ) internal {
        if (creator == address(0)) revert CREATOR_FUNDS_RECIPIENT_NOT_SET();

        if (salePrice == 0) {
            _handleFreeMintRewards(msgValue, numTokens, creator, mintReferral, createReferral);
        } else {
            _handlePaidMintRewards(msgValue, numTokens, salePrice, creator, mintReferral, createReferral);
        }
    }

    function _handleFreeMintRewards(
        uint256 msgValue,
        uint256 numTokens,
        address creator,
        address mintReferral,
        address createReferral
    ) private {
        (
            uint256 totalReward,
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = computeFreeMintRewards(numTokens);

        if (msgValue != totalReward) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        }

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

    function _handlePaidMintRewards(
        uint256 msgValue,
        uint256 numTokens,
        uint256 salePrice,
        address creator,
        address mintReferral,
        address createReferral
    ) private {
        (
            uint256 totalReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = computePaidMintRewards(numTokens);

        uint256 totalSales = salePrice * numTokens;

        if (msgValue != (totalSales + totalReward)) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        }

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
