// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "../ProtocolRewardsTest.sol";

contract ERC721RewardsTest is ProtocolRewardsTest {
    MockERC721 internal mockERC721;

    function setUp() public override {
        super.setUp();

        mockERC721 = new MockERC721(creator, createReferral, address(protocolRewards), zora);

        vm.label(address(mockERC721), "MOCK_ERC721");
    }

    function testValidateFreeMintTotalComputation(uint16 numTokens) public {
        uint256 expectedTotal = mockERC721.computeTotalReward(numTokens);

        (uint256 creatorReward, uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = mockERC721
            .computeFreeMintRewards(numTokens);

        uint256 actualTotal = creatorReward + mintReferralReward + createReferralReward + firstMinterReward + zoraReward;

        assertEq(expectedTotal, actualTotal);
    }

    function testValidatePaidMintTotalComputation(uint32 numTokens) public {
        uint256 expectedTotal = mockERC721.computeTotalReward(numTokens);

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = mockERC721.computePaidMintRewards(
            numTokens
        );

        uint256 actualTotal = mintReferralReward + createReferralReward + firstMinterReward + zoraReward;

        assertEq(expectedTotal, actualTotal);
    }

    function test721FreeMintDeposit(uint16 numTokens) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);

        vm.deal(collector, totalReward);

        vm.prank(collector);
        mockERC721.mintWithRewards{value: totalReward}(collector, numTokens, mintReferral);

        (uint256 creatorReward, uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = mockERC721
            .computeFreeMintRewards(numTokens);

        assertEq(protocolRewards.totalSupply(), totalReward);
        assertEq(protocolRewards.balanceOf(creator), creatorReward + firstMinterReward);
        assertEq(protocolRewards.balanceOf(mintReferral), mintReferralReward);
        assertEq(protocolRewards.balanceOf(createReferral), createReferralReward);
        assertEq(protocolRewards.balanceOf(zora), zoraReward);
    }

    function test721PaidMintDeposit(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC721.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(collector, totalValue);

        vm.prank(collector);
        mockERC721.mintWithRewards{value: totalValue}(collector, numTokens, mintReferral);

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = mockERC721.computePaidMintRewards(
            numTokens
        );

        assertEq(protocolRewards.totalSupply(), totalReward);
        assertEq(protocolRewards.balanceOf(creator), firstMinterReward);
        assertEq(protocolRewards.balanceOf(mintReferral), mintReferralReward);
        assertEq(protocolRewards.balanceOf(createReferral), createReferralReward);
        assertEq(protocolRewards.balanceOf(zora), zoraReward);
    }

    function test721FreeMintNullReferralRecipients(uint16 numTokens) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);

        mockERC721 = new MockERC721(creator, address(0), address(protocolRewards), zora);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);

        vm.deal(collector, totalReward);

        vm.prank(collector);
        mockERC721.mintWithRewards{value: totalReward}(collector, numTokens, address(0));

        (uint256 creatorReward, uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = mockERC721
            .computeFreeMintRewards(numTokens);

        assertEq(protocolRewards.totalSupply(), totalReward);
        assertEq(protocolRewards.balanceOf(creator), creatorReward + firstMinterReward);
        assertEq(protocolRewards.balanceOf(zora), zoraReward + mintReferralReward + createReferralReward);
    }

    function test721PaidMintNullReferralRecipient(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0 && numTokens < 10_000);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC721 = new MockERC721(creator, address(0), address(protocolRewards), zora);

        mockERC721.setSalePrice(pricePerToken);

        uint256 totalReward = mockERC721.computeTotalReward(numTokens);
        uint256 totalSale = numTokens * pricePerToken;
        uint256 totalValue = totalReward + totalSale;

        vm.deal(collector, totalValue);

        vm.prank(collector);
        mockERC721.mintWithRewards{value: totalValue}(collector, numTokens, address(0));

        (uint256 mintReferralReward, uint256 createReferralReward, uint256 firstMinterReward, uint256 zoraReward) = mockERC721.computePaidMintRewards(
            numTokens
        );

        assertEq(protocolRewards.totalSupply(), totalReward);
        assertEq(protocolRewards.balanceOf(creator), firstMinterReward);
        assertEq(protocolRewards.balanceOf(zora), zoraReward + mintReferralReward + createReferralReward);
    }

    function testRevert721CreatorFundsRecipientNotSet(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        mockERC721 = new MockERC721(address(0), createReferral, address(protocolRewards), zora);

        uint256 totalValue = mockERC721.computeTotalReward(numTokens);

        vm.expectRevert(abi.encodeWithSignature("CREATOR_FUNDS_RECIPIENT_NOT_SET()"));
        mockERC721.mintWithRewards{value: totalValue}(collector, numTokens, mintReferral);
    }

    function testRevert721FreeMintInvalidEth(uint16 numTokens) public {
        vm.assume(numTokens > 0);

        vm.expectRevert(abi.encodeWithSignature("INVALID_ETH_AMOUNT()"));
        mockERC721.mintWithRewards(collector, numTokens, mintReferral);
    }

    function testRevert721PaidMintInvalidEth(uint16 numTokens, uint256 pricePerToken) public {
        vm.assume(numTokens > 0);
        vm.assume(pricePerToken > 0 && pricePerToken < 100 ether);

        mockERC721.setSalePrice(pricePerToken);

        vm.expectRevert(abi.encodeWithSignature("INVALID_ETH_AMOUNT()"));
        mockERC721.mintWithRewards(collector, numTokens, mintReferral);
    }
}
