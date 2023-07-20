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
            _depositFreeMintRewards(numTokens, creator, mintReferral, createReferral);

            return 0;
        } else {
            _depositPaidMintRewards(numTokens, creator, mintReferral, createReferral);

            unchecked {
                return msgValue - totalReward;
            }
        }
    }
}
