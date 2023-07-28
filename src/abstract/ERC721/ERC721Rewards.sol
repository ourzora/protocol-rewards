// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { RewardSplits } from "../RewardSplits.sol";

contract ERC721RewardsStorage {
    address public createReferral;
}

abstract contract ERC721Rewards is RewardSplits {
    constructor(address _protocolRewards, address _zoraRewardRecipient)
        payable
        RewardSplits(_protocolRewards, _zoraRewardRecipient)
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

        uint256 totalReward = computeTotalReward(numTokens);

        if (salePrice == 0) {
            if (msgValue != totalReward) revert INVALID_ETH_AMOUNT();

            _depositFreeMintRewards(totalReward, numTokens, creator, mintReferral, createReferral);
        } else {
            uint256 totalSale = numTokens * salePrice;

            if (msgValue != (totalReward + totalSale)) revert INVALID_ETH_AMOUNT();

            _depositPaidMintRewards(totalReward, numTokens, creator, mintReferral, createReferral);
        }
    }
}
