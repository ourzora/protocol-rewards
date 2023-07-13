// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

import "./interfaces/IZoraRewards.sol";

contract ZoraRewards is IZoraRewards, EIP712 {
    bytes32 public constant WITHDRAW_TYPEHASH =
        keccak256("Withdraw(address owner,uint256 amount,uint256 nonce,uint256 deadline)");

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public nonces;

    constructor() payable EIP712("ZoraRewards", "1") { }

    function totalSupply() external view returns (uint256) {
        return address(this).balance;
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.sender, msg.value);
    }

    function depositTo(address recipient) external payable {
        if (recipient == address(0)) revert ADDRESS_ZERO();

        balanceOf[recipient] += msg.value;

        emit Deposit(msg.sender, recipient, msg.value);
    }

    function depositToBatch(address[] calldata recipients, uint256[] calldata amounts) external payable {
        uint256 numRecipients = recipients.length;

        if (numRecipients != amounts.length) revert ARRAY_LENGTH_MISMATCH();

        uint256 expectedTotalValue;

        for (uint256 i; i < numRecipients;) {
            expectedTotalValue += amounts[i];

            unchecked {
                ++i;
            }
        }

        if (msg.value != expectedTotalValue) revert INVALID_DEPOSIT();

        for (uint256 i; i < numRecipients;) {
            if (recipients[i] == address(0)) revert ADDRESS_ZERO();

            balanceOf[recipients[i]] += amounts[i];

            emit Deposit(msg.sender, recipients[i], amounts[i]);

            unchecked {
                ++i;
            }
        }
    }

    function depositFreeCreatorRewards(
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

        if (creator != address(0)) balanceOf[creator] += creatorReward;
        if (mintReferral != address(0)) balanceOf[mintReferral] += mintReferralReward;
        if (createReferral != address(0)) balanceOf[createReferral] += createReferralReward;
        if (zora != address(0)) balanceOf[zora] += zoraReward;

        emit DepositCreatorRewards(
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

    function depositPaidCreatorRewards(
        address mintReferral,
        uint256 mintReferralReward,
        address createReferral,
        uint256 createReferralReward,
        address zora,
        uint256 zoraReward
    ) external payable {
        if (msg.value != (mintReferralReward + createReferralReward + zoraReward)) revert INVALID_DEPOSIT();

        if (mintReferral != address(0)) balanceOf[mintReferral] += mintReferralReward;
        if (createReferral != address(0)) balanceOf[createReferral] += createReferralReward;
        if (zora != address(0)) balanceOf[zora] += zoraReward;

        emit DepositCreatorRewards(
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

    function withdraw(uint256 amount) external {
        if (amount > balanceOf[msg.sender]) revert INVALID_WITHDRAW();

        balanceOf[msg.sender] -= amount;

        // TODO update gas limit
        (bool success,) = msg.sender.call{ value: amount, gas: 50_000 }("");

        if (!success) revert TRANSFER_FAILED();

        emit Withdraw(msg.sender, amount);
    }

    function withdrawWithSig(address owner, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        if (block.timestamp > deadline) revert SIGNATURE_DEADLINE_EXPIRED();

        bytes32 withdrawHash = keccak256(abi.encode(WITHDRAW_TYPEHASH, owner, amount, nonces[owner]++, deadline));

        bytes32 digest = _hashTypedDataV4(withdrawHash);

        address recoveredAddress = ecrecover(digest, v, r, s);

        if (recoveredAddress == address(0) || recoveredAddress != owner) revert INVALID_SIGNATURE();

        if (amount > balanceOf[owner]) revert INVALID_WITHDRAW();

        balanceOf[owner] -= amount;

        // TODO update gas limit
        (bool success,) = owner.call{ value: amount, gas: 50_000 }("");

        if (!success) revert TRANSFER_FAILED();

        emit Withdraw(owner, amount);
    }

    receive() external payable {
        deposit();
    }
}
