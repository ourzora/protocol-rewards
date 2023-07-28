// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { MintRewards } from "../common/MintRewards.sol";

contract ERC1155RewardsStorage {
    mapping(uint256 => address) public createReferrals;
}

abstract contract ERC1155Rewards is MintRewards, ERC1155RewardsStorage {
    constructor(address _zoraRewards, address _zoraRewardRecipient)
        payable
        MintRewards(_zoraRewards, _zoraRewardRecipient)
    { }

    function updateCreateReferral(uint256 tokenId, address recipient) external {
        if (msg.sender != createReferrals[tokenId]) revert ONLY_CREATE_REFERRAL();

        _setCreateReferral(tokenId, recipient);
    }

    function _setCreateReferral(uint256 tokenId, address recipient) internal {
        createReferrals[tokenId] = recipient;
    }

    function _handleRewardsAndGetValueSent(
        uint256 msgValue,
        uint256 tokenId,
        uint256 numTokens,
        address creator,
        address mintReferral
    ) internal returns (uint256) {
        if (creator == address(0)) revert CREATOR_FUNDS_RECIPIENT_NOT_SET();

        address createReferral = createReferrals[tokenId];

        uint256 totalReward = computeTotalReward(numTokens);

        if (msgValue < totalReward) {
            revert INVALID_ETH_AMOUNT();
        } else if (msgValue == totalReward) {
            _depositFreeMintRewards(totalReward, numTokens, creator, mintReferral, createReferral);

            return 0;
        } else {
            _depositPaidMintRewards(totalReward, numTokens, creator, mintReferral, createReferral);

            unchecked {
                return msgValue - totalReward;
            }
        }
    }
}
