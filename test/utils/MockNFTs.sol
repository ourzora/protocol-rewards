// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import { ERC721Rewards } from "../../src/ERC721/ERC721Rewards.sol";
import { ERC1155Rewards } from "../../src/ERC1155/ERC1155Rewards.sol";

contract MockERC721 is ERC721, ERC721Rewards {
    uint256 public salePrice;
    uint256 public currentTokenId;

    constructor(address _creator, address _zoraRewards, address _zoraRewardRecipient)
        ERC721("Mock ERC721", "MOCK")
        ERC721Rewards(_zoraRewards, _zoraRewardRecipient)
    { }

    function setSalePrice(uint256 _salePrice) external {
        salePrice = _salePrice;
    }

    function mintWithRewards(
        address to,
        uint256 numTokens,
        address creator,
        address mintReferral,
        address createReferral
    ) external payable {
        _handleRewards(msg.value, numTokens, salePrice, creator, mintReferral, createReferral);

        for (uint256 i; i < numTokens; ++i) {
            _mint(to, currentTokenId++);
        }
    }
}

contract MockERC1155 is ERC1155, ERC1155Rewards {
    error MOCK_ERC1155_INVALID_REMAINING_VALUE();

    uint256 public salePrice;

    constructor(address _creator, address _zoraRewards, address _zoraRewardRecipient)
        ERC1155("Mock ERC1155 URI")
        ERC1155Rewards(_zoraRewards, _zoraRewardRecipient)
    { }

    function setSalePrice(uint256 _salePrice) external {
        salePrice = _salePrice;
    }

    function mintWithRewards(
        address to,
        uint256 tokenId,
        uint256 numTokens,
        address creator,
        address mintReferral,
        address createReferral
    ) external payable {
        uint256 remainingValue =
            _handleRewardsAndGetValueSent(msg.value, numTokens, creator, mintReferral, createReferral);

        uint256 expectedRemainingValue = salePrice * numTokens;

        if (remainingValue != expectedRemainingValue) revert MOCK_ERC1155_INVALID_REMAINING_VALUE();

        _mint(to, tokenId, numTokens, "");
    }
}
