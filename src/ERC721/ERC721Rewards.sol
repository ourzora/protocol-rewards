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
        address finder,
        address origin
    ) internal {
        if (salePrice == 0) {
            _handleFreeMintRewards(msgValue, numTokens, creator, finder, origin);
        } else {
            _handlePaidMintRewards(msgValue, numTokens, salePrice, finder, origin);
        }
    }

    function _handleFreeMintRewards(
        uint256 msgValue,
        uint256 numTokens,
        address creator,
        address finder,
        address origin
    ) private {
        (uint256 totalReward, uint256 creatorReward, uint256 finderReward, uint256 originReward, uint256 zoraReward) =
            computeFreeMintRewards(numTokens);

        if (msgValue != totalReward) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        }

        if (finder == address(0)) {
            finder = ZORA_REWARD_RECIPIENT;
        }

        if (origin == address(0)) {
            origin = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.depositFreeCreatorRewards{ value: totalReward }(
            creator, creatorReward, finder, finderReward, origin, originReward, ZORA_REWARD_RECIPIENT, zoraReward
        );
    }

    function _handlePaidMintRewards(
        uint256 msgValue,
        uint256 numTokens,
        uint256 salePrice,
        address finder,
        address origin
    ) private {
        (uint256 totalReward, uint256 finderReward, uint256 originReward, uint256 zoraReward) =
            computePaidMintRewards(numTokens);

        uint256 totalSales = salePrice * numTokens;

        if (msgValue != (totalSales + totalReward)) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        }

        if (finder == address(0)) {
            finder = ZORA_REWARD_RECIPIENT;
        }

        if (origin == address(0)) {
            origin = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.depositPaidCreatorRewards{ value: totalReward }(
            finder, finderReward, origin, originReward, ZORA_REWARD_RECIPIENT, zoraReward
        );
    }
}
