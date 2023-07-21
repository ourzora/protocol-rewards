// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../src/ZoraRewards.sol";

import "./utils/MockNFTs.sol";

contract ZoraRewardsTest is Test {
    ZoraRewards internal zoraRewards;

    address internal alice;
    address internal bob;
    address internal creator;
    address internal mintReferral;
    address internal createReferral;
    address internal zora;

    MockERC721 internal mockERC721;
    MockERC1155 internal mockERC1155;

    function setUp() public {
        zoraRewards = new ZoraRewards();

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        creator = makeAddr("creator");
        mintReferral = makeAddr("mintReferral");
        createReferral = makeAddr("createReferral");
        zora = makeAddr("zora");

        mockERC721 = new MockERC721(creator, createReferral, address(zoraRewards), zora);
        mockERC1155 = new MockERC1155(creator, createReferral, address(zoraRewards), zora);

        vm.label(address(zoraRewards), "ZORA_REWARDS");
        vm.label(address(mockERC721), "MOCK_ERC721");
        vm.label(address(mockERC1155), "MOCK_ERC1155");
    }

    /// ERC721 ///

    function testValidateFreeMintTotalComputation(uint16 numTokens) public {
        uint256 expectedTotal = mockERC721.computeTotalReward(numTokens);

        (
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = mockERC721.computeFreeMintRewards(numTokens);

        uint256 actualTotal = creatorReward + mintReferralReward + createReferralReward + firstMinterReward + zoraReward;

        assertEq(expectedTotal, actualTotal);
    }

    function testValidatePaidMintTotalComputation(uint32 numTokens) public {
        uint256 expectedTotal = mockERC721.computeTotalReward(numTokens);

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) =
            mockERC721.computePaidMintRewards(numTokens);

        uint256 actualTotal = mintReferralReward + createReferralReward + firstMinterReward + zoraReward;

        assertEq(expectedTotal, actualTotal);
    }

    function test721FreeMintDeposit(uint16 numTokens) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);

        vm.deal(alice, totalReward);

        vm.prank(alice);
        mockERC721.mintWithRewards{ value: totalReward }(alice, numTokens, mintReferral);

        (
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = mockERC721.computeFreeMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), creatorReward + firstMinterReward);
        assertEq(zoraRewards.balanceOf(mintReferral), mintReferralReward);
        assertEq(zoraRewards.balanceOf(createReferral), createReferralReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward);
    }

    function test721PaidMintDeposit(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC721.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(alice, totalValue);

        vm.prank(alice);
        mockERC721.mintWithRewards{ value: totalValue }(alice, numTokens, mintReferral);

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) =
            mockERC721.computePaidMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), firstMinterReward);
        assertEq(zoraRewards.balanceOf(mintReferral), mintReferralReward);
        assertEq(zoraRewards.balanceOf(createReferral), createReferralReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward);
    }

    function test721FreeMintNullReferralRecipients(uint16 numTokens) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);

        mockERC721 = new MockERC721(creator, address(0), address(zoraRewards), zora);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);

        vm.deal(alice, totalReward);

        vm.prank(alice);
        mockERC721.mintWithRewards{ value: totalReward }(alice, numTokens, address(0));

        (
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = mockERC721.computeFreeMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), creatorReward + firstMinterReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward + mintReferralReward + createReferralReward);
    }

    function test721PaidMintNullReferralRecipient(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC721 = new MockERC721(creator, address(0), address(zoraRewards), zora);

        mockERC721.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(alice, totalValue);

        vm.prank(alice);
        mockERC721.mintWithRewards{ value: totalValue }(alice, numTokens, address(0));

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) =
            mockERC721.computePaidMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), firstMinterReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward + mintReferralReward + createReferralReward);
    }

    function testRevert721CreatorFundsRecipientNotSet(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        mockERC721 = new MockERC721(address(0), createReferral, address(zoraRewards), zora);

        uint256 totalValue = mockERC721.computeTotalReward(numTokens);

        vm.expectRevert(abi.encodeWithSignature("CREATOR_FUNDS_RECIPIENT_NOT_SET()"));
        mockERC721.mintWithRewards{ value: totalValue }(alice, numTokens, mintReferral);
    }

    function testRevert721FreeMintInvalidEth(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        vm.expectRevert(abi.encodeWithSignature("INVALID_ETH_AMOUNT()"));
        mockERC721.mintWithRewards(alice, numTokens, mintReferral);
    }

    function testRevert721PaidMintInvalidEth(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC721.setSalePrice(pricePerToken);

        vm.expectRevert(abi.encodeWithSignature("INVALID_ETH_AMOUNT()"));
        mockERC721.mintWithRewards(alice, numTokens, mintReferral);
    }

    /// ERC1155 ///

    function test1155FreeMintDeposit(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        uint256 totalReward = mockERC1155.computeTotalReward(numTokens);

        vm.deal(alice, totalReward);

        vm.prank(alice);
        mockERC1155.mintWithRewards{ value: totalReward }(alice, 0, numTokens, mintReferral);

        (
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = mockERC1155.computeFreeMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), creatorReward + firstMinterReward);
        assertEq(zoraRewards.balanceOf(mintReferral), mintReferralReward);
        assertEq(zoraRewards.balanceOf(createReferral), createReferralReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward);
    }

    function test1155PaidMintDeposit(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC1155.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC1155.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(alice, totalValue);

        vm.prank(alice);
        mockERC1155.mintWithRewards{ value: totalValue }(alice, 0, numTokens, mintReferral);

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) =
            mockERC1155.computePaidMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), firstMinterReward);
        assertEq(zoraRewards.balanceOf(mintReferral), mintReferralReward);
        assertEq(zoraRewards.balanceOf(createReferral), createReferralReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward);
    }

    function test1155FreeMintNullReferralRecipients(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        mockERC1155 = new MockERC1155(creator, address(0), address(zoraRewards), zora);

        uint256 totalReward = mockERC1155.computeTotalReward(numTokens);

        vm.deal(alice, totalReward);

        vm.prank(alice);
        mockERC1155.mintWithRewards{ value: totalReward }(alice, 0, numTokens, address(0));

        (
            uint256 creatorReward,
            uint256 mintReferralReward,
            uint256 createReferralReward,
            uint256 firstMinterReward,
            uint256 zoraReward
        ) = mockERC1155.computeFreeMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), creatorReward + firstMinterReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward + mintReferralReward + createReferralReward);
    }

    function test1155PaidMintNullReferralRecipient(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC1155 = new MockERC1155(creator, address(0), address(zoraRewards), zora);

        mockERC1155.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC1155.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(alice, totalValue);

        vm.prank(alice);
        mockERC1155.mintWithRewards{ value: totalValue }(alice, 0, numTokens, address(0));

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) =
            mockERC1155.computePaidMintRewards(numTokens);

        assertEq(zoraRewards.totalSupply(), totalReward);
        assertEq(zoraRewards.balanceOf(creator), firstMinterReward);
        assertEq(zoraRewards.balanceOf(zora), zoraReward + mintReferralReward + createReferralReward);
    }

    function testRevert1155FreeMintInvalidEth(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        vm.expectRevert(abi.encodeWithSignature("INVALID_ETH_AMOUNT()"));
        mockERC1155.mintWithRewards(alice, 0, numTokens, mintReferral);
    }

    function testRevert1155PaidMintInvalidEth(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC1155.setSalePrice(pricePerToken);

        vm.expectRevert(abi.encodeWithSignature("INVALID_ETH_AMOUNT()"));
        mockERC1155.mintWithRewards(alice, 0, numTokens, mintReferral);
    }

    function testRevert1155PaidMintInvalidEthRemaining(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC1155.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC1155.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(alice, totalValue);

        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSignature("MOCK_ERC1155_INVALID_REMAINING_VALUE()"));
        mockERC1155.mintWithRewards{ value: totalValue - 1 }(alice, 0, numTokens, mintReferral);
    }
}
