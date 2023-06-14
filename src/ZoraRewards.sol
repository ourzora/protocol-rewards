// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import { IZoraRewards } from "./interfaces/IZoraRewards.sol";

contract ZoraRewards is IZoraRewards, ERC20 {
    bytes4 public constant ZORA_FREE_MINT_REWARD_TYPE = bytes4(keccak256("ZORA_FREE_MINT_REWARD"));
    bytes4 public constant ZORA_PAID_MINT_REWARD_TYPE = bytes4(keccak256("ZORA_PAID_MINT_REWARD"));

    constructor(string memory tokenName, string memory tokenSymbol) payable ERC20(tokenName, tokenSymbol) { }

    function deposit(bytes4 rewardType, address recipient, uint256 amount) external payable {
        if (msg.value != amount) {
            revert INVALID_DEPOSIT_AMOUNT();
        }

        _mint(recipient, amount);

        emit RewardsAdded(rewardType, recipient, amount);
    }

    function deposit(bytes4 rewardType, address recipient1, uint256 amount1, address recipient2, uint256 amount2)
        external
        payable
    {
        if (msg.value != (amount1 + amount2)) {
            revert INVALID_DEPOSIT_AMOUNT();
        }

        _mint(recipient1, amount1);
        _mint(recipient2, amount2);

        emit RewardsAdded(rewardType, recipient1, amount1, recipient2, amount2);
    }

    function deposit(
        bytes4 rewardType,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3
    ) external payable {
        if (msg.value != (amount1 + amount2 + amount3)) {
            revert INVALID_DEPOSIT_AMOUNT();
        }

        _mint(recipient1, amount1);
        _mint(recipient2, amount2);
        _mint(recipient3, amount3);

        emit RewardsAdded(rewardType, recipient1, amount1, recipient2, amount2, recipient3, amount3);
    }

    function deposit(
        bytes4 rewardType,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3,
        address recipient4,
        uint256 amount4
    ) external payable {
        if (msg.value != (amount1 + amount2 + amount3 + amount4)) {
            revert INVALID_DEPOSIT_AMOUNT();
        }

        _mint(recipient1, amount1);
        _mint(recipient2, amount2);
        _mint(recipient3, amount3);
        _mint(recipient4, amount4);

        emit RewardsAdded(
            rewardType, recipient1, amount1, recipient2, amount2, recipient3, amount3, recipient4, amount4
        );
    }

    function deposit(
        bytes4 rewardType,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3,
        address recipient4,
        uint256 amount4,
        address recipient5,
        uint256 amount5
    ) external payable {
        if (msg.value != (amount1 + amount2 + amount3 + amount4 + amount5)) {
            revert INVALID_DEPOSIT_AMOUNT();
        }

        _mint(recipient1, amount1);
        _mint(recipient2, amount2);
        _mint(recipient3, amount3);
        _mint(recipient4, amount4);
        _mint(recipient5, amount5);

        emit RewardsAdded(
            rewardType,
            recipient1,
            amount1,
            recipient2,
            amount2,
            recipient3,
            amount3,
            recipient4,
            amount4,
            recipient5,
            amount5
        );
    }

    function withdraw(address recipient, uint256 amount) external {
        _burn(msg.sender, amount);

        (bool success,) = recipient.call{ value: amount }("");

        if (!success) {
            revert TRANSFER_FAILED();
        }
    }

    function approve(address, uint256) public pure override returns (bool) {
        return false;
    }

    function transfer(address, uint256) public pure override returns (bool) {
        return false;
    }

    function transferFrom(address, address, uint256) public pure override returns (bool) {
        return false;
    }

    function increaseAllowance(address, uint256) public pure override returns (bool) {
        return false;
    }

    function decreaseAllowance(address, uint256) public pure override returns (bool) {
        return false;
    }
}
