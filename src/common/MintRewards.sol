// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { IMintRewards } from "../interfaces/IMintRewards.sol";
import { IZoraRewards } from "../interfaces/IZoraRewards.sol";

abstract contract MintRewards is IMintRewards {
    bytes4 public constant ZORA_FREE_MINT_REWARD_TYPE = bytes4(keccak256("ZORA_FREE_MINT_REWARD"));
    bytes4 public constant ZORA_PAID_MINT_REWARD_TYPE = bytes4(keccak256("ZORA_PAID_MINT_REWARD"));

    uint256 internal constant TOTAL_REWARD_PER_MINT = 0.000999 ether;

    uint256 internal constant CREATOR_REWARD_FREE_MINT = 0.000555 ether;
    uint256 internal constant FINDER_REWARD_FREE_MINT = 0.000111 ether;
    uint256 internal constant LISTER_REWARD_FREE_MINT = 0.000111 ether;
    uint256 internal constant ZORA_REWARD_FREE_MINT = 0.000222 ether;

    uint256 internal constant FINDER_REWARD_PAID_MINT = 0.000333 ether;
    uint256 internal constant LISTER_REWARD_PAID_MINT = 0.000333 ether;
    uint256 internal constant ZORA_REWARD_PAID_MINT = 0.000333 ether;

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

    function computeTotalValue(uint256 numTokens, uint256 salePrice) public pure returns (uint256) {
        uint256 totalReward = computeTotalReward(numTokens);
        uint256 totalSale = numTokens * salePrice;
        return totalReward + totalSale;
    }

    function computeFreeMintRewards(uint256 numTokens)
        public
        pure
        returns (
            uint256 totalReward,
            uint256 creatorReward,
            uint256 zoraReward,
            uint256 finderReward,
            uint256 listerReward
        )
    {
        totalReward = computeTotalReward(numTokens);
        creatorReward = numTokens * CREATOR_REWARD_FREE_MINT;
        zoraReward = numTokens * ZORA_REWARD_FREE_MINT;
        finderReward = numTokens * FINDER_REWARD_FREE_MINT;
        listerReward = numTokens * LISTER_REWARD_FREE_MINT;
    }

    function computePaidMintRewards(uint256 numTokens)
        public
        pure
        returns (uint256 totalReward, uint256 zoraReward, uint256 finderReward, uint256 listerReward)
    {
        totalReward = computeTotalReward(numTokens);
        zoraReward = numTokens * ZORA_REWARD_PAID_MINT;
        finderReward = numTokens * FINDER_REWARD_PAID_MINT;
        listerReward = numTokens * LISTER_REWARD_PAID_MINT;
    }
}
