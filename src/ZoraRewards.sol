// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

import "./interfaces/IZoraRewards.sol";

contract ZoraRewards is IZoraRewards, ERC20, ERC20Permit {
    bytes4 public constant ZORA_FREE_MINT_REWARD_TYPE = bytes4(keccak256("ZORA_FREE_MINT_REWARD"));
    bytes4 public constant ZORA_PAID_MINT_REWARD_TYPE = bytes4(keccak256("ZORA_PAID_MINT_REWARD"));

    bytes32 public constant WITHDRAW_TYPEHASH =
        keccak256("Withdraw(address owner,address recipient,uint256 amount,uint256 nonce,uint256 deadline)");

    constructor(string memory tokenName, string memory tokenSymbol)
        payable
        ERC20(tokenName, tokenSymbol)
        ERC20Permit(tokenName)
    { }

    function deposit(address recipient, string calldata comment) external payable {
        _mint(recipient, msg.value);

        emit ZoraRewardsMint(msg.sender, recipient, msg.value, comment);
    }

    function depositBatch(address[] calldata recipients, uint256[] calldata rewards, string calldata comment)
        external
        payable
    {
        uint256 numRecipients = recipients.length;

        if (numRecipients != rewards.length) {
            revert RECIPIENTS_AND_AMOUNTS_LENGTH_MISMATCH();
        }

        uint256 expectedTotalValue;

        for (uint256 i; i < numRecipients;) {
            expectedTotalValue += rewards[i];

            unchecked {
                ++i;
            }
        }

        if (msg.value != expectedTotalValue) {
            revert INVALID_DEPOSIT();
        }

        for (uint256 i; i < numRecipients;) {
            _mint(recipients[i], rewards[i]);

            unchecked {
                ++i;
            }

            emit ZoraRewardsMint(msg.sender, recipients[i], rewards[i], comment);
        }
    }

    function depositFreeMintRewards(
        address creator,
        uint256 creatorReward,
        address mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    ) external payable {
        if (msg.value != (creatorReward + mintReferralReward + createReferralReward + zoraReward)) {
            revert INVALID_DEPOSIT();
        }

        _mint(creator, creatorReward);
        _mint(mintReferral, mintReferralReward);
        _mint(createReferral, createReferralReward);
        _mint(zora, zoraReward);

        emit ZoraRewardsMint(
            ZORA_FREE_MINT_REWARD_TYPE,
            msg.sender,
            creator,
            creatorReward,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            zora,
            zoraReward
        );
    }

    function depositPaidMintRewards(
        address mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    ) external payable {
        if (msg.value != (mintReferralReward + createReferralReward + zoraReward)) {
            revert INVALID_DEPOSIT();
        }

        _mint(mintReferral, mintReferralReward);
        _mint(createReferral, createReferralReward);
        _mint(zora, zoraReward);

        emit ZoraRewardsMint(
            ZORA_PAID_MINT_REWARD_TYPE,
            msg.sender,
            address(0),
            0,
            mintReferral,
            mintReferralReward,
            createReferral,
            createReferralReward,
            zora,
            zoraReward
        );
    }

    function withdraw(address recipient, uint256 amount) external {
        _withdraw(msg.sender, recipient, amount);
    }

    function withdrawWithSig(
        address owner,
        address recipient,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        if (block.timestamp > deadline) revert SIGNATURE_DEADLINE_EXPIRED();

        bytes32 withdrawHash =
            keccak256(abi.encode(WITHDRAW_TYPEHASH, owner, recipient, amount, _useNonce(owner), deadline));

        bytes32 hash = _hashTypedDataV4(withdrawHash);

        address signer = ECDSA.recover(hash, v, r, s);

        if (signer != owner) revert INVALID_SIGNER();

        _withdraw(owner, recipient, amount);
    }

    function _withdraw(address owner, address recipient, uint256 amount) internal {
        _burn(owner, amount);

        (bool success,) = recipient.call{ value: amount }("");

        if (!success) {
            revert TRANSFER_FAILED();
        }

        emit ZoraRewardsBurn(owner, recipient, amount);
    }
}
