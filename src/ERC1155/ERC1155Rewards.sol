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
        address finder,
        address lister
    ) internal returns (uint256) {
        uint256 totalReward = computeTotalReward(numTokens);

        if (msgValue < totalReward) {
            revert INSUFFICIENT_ETH_FOR_REWARDS();
        } else if (msgValue == totalReward) {
            _handleFreeMintRewards(numTokens, creator, finder, lister);

            return 0;
        } else {
            _handlePaidMintRewards(numTokens, finder, lister);

            unchecked {
                return msgValue - totalReward;
            }
        }
    }

    function _handleFreeMintRewards(uint256 numTokens, address creator, address finder, address lister) private {
        (uint256 totalReward, uint256 creatorReward, uint256 finderReward, uint256 listerReward, uint256 zoraReward) =
            computeFreeMintRewards(numTokens);

        if (finder == address(0)) {
            finder = ZORA_REWARD_RECIPIENT;
        }

        if (lister == address(0)) {
            lister = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.depositFreeMintRewards{ value: totalReward }(
            creator, creatorReward, finder, finderReward, lister, listerReward, ZORA_REWARD_RECIPIENT, zoraReward
        );
    }

    function _handlePaidMintRewards(uint256 numTokens, address finder, address lister) private {
        (uint256 totalReward, uint256 finderReward, uint256 listerReward, uint256 zoraReward) =
            computePaidMintRewards(numTokens);

        if (finder == address(0)) {
            finder = ZORA_REWARD_RECIPIENT;
        }

        if (lister == address(0)) {
            lister = ZORA_REWARD_RECIPIENT;
        }

        ZORA_REWARDS.depositPaidMintRewards{ value: totalReward }(
            finder, finderReward, lister, listerReward, ZORA_REWARD_RECIPIENT, zoraReward
        );
    }
}
