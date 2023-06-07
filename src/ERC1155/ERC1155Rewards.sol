// SPDX-License-Identifier: UNLICENSED
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
        address finder,
        address lister
    ) internal returns (uint256) {
        uint256 totalReward = numTokens * TOTAL_REWARD_PER_MINT;

        if (msgValue < totalReward) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        }

        if (msgValue == totalReward) {
            _handleFreeMintRewards(numTokens, creator, finder, lister);

            return 0;
        } else {
            _handlePaidMintRewards(numTokens, finder, lister);

            return msgValue - totalReward;
        }
    }

    function _handleFreeMintRewards(uint256 numTokens, address creator, address finder, address lister) private {
        (uint256 totalReward, uint256 creatorReward, uint256 zoraReward, uint256 finderReward, uint256 listerReward) =
            computeFreeMintRewards(numTokens);

        if (finder == address(0)) {
            finder = ZORA_REWARD_RECIPIENT;
        }

        if (lister == address(0)) {
            lister = ZORA_REWARD_RECIPIENT;
        }

        if (creator != address(0)) {
            totalReward -= creatorReward;

            ZORA_REWARDS.deposit{ value: totalReward }(
                ZORA_FREE_MINT_REWARD_TYPE,
                ZORA_REWARD_RECIPIENT,
                zoraReward,
                finder,
                finderReward,
                lister,
                listerReward
            );

            (bool success,) = creator.call{ value: creatorReward, gas: 5000 }(""); // TODO update hardcoded gas limit

            if (!success) {
                revert CREATOR_REWARD_TRANSFER_FAILED();
            }
        } else {
            ZORA_REWARDS.deposit{ value: totalReward }(
                ZORA_FREE_MINT_REWARD_TYPE,
                creator,
                creatorReward,
                ZORA_REWARD_RECIPIENT,
                zoraReward,
                finder,
                finderReward,
                lister,
                listerReward
            );
        }

        emit FreeMintRewards(
            creator, creatorReward, finder, finderReward, lister, listerReward, ZORA_REWARD_RECIPIENT, zoraReward
        );
    }

    function _handlePaidMintRewards(uint256 numTokens, address finder, address lister) private {
        (uint256 totalReward, uint256 zoraReward, uint256 finderReward, uint256 listerReward) =
            computePaidMintRewards(numTokens);

        if (finder == address(0)) {
            finder = ZORA_REWARD_RECIPIENT;
        }

        if (lister == address(0)) {
            lister = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.deposit{ value: totalReward }(
            ZORA_PAID_MINT_REWARD_TYPE, ZORA_REWARD_RECIPIENT, zoraReward, finder, finderReward, lister, listerReward
        );

        emit PaidMintRewards(finder, finderReward, lister, listerReward, ZORA_REWARD_RECIPIENT, zoraReward);
    }
}
