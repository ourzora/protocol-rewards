// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface IZoraRewards {
    event ZoraRewardsDeposit(bytes4 indexed rewardType, address indexed from, address recipient, uint256 amount);
    event ZoraRewardsDeposit(
        bytes4 indexed rewardType,
        address indexed from,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2
    );
    event ZoraRewardsDeposit(
        bytes4 indexed rewardType,
        address indexed from,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3
    );
    event ZoraRewardsDeposit(
        bytes4 indexed rewardType,
        address indexed from,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3,
        address recipient4,
        uint256 amount4
    );
    event ZoraRewardsDeposit(
        bytes4 indexed rewardType,
        address indexed from,
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
    );
    event ZoraRewardsWithdrawal(address indexed from, address recipient, uint256 amount);

    error INVALID_DEPOSIT_AMOUNT();
    error INVALID_WITHDRWAL_AMOUNT();
    error INVALID_TOKEN_QUANTITY();
    error TRANSFER_FAILED();

    function deposit(bytes4 rewardType, address recipient) external payable;
    function deposit(bytes4 rewardType, address recipient1, uint256 amount1, address recipient2, uint256 amount2)
        external
        payable;
    function deposit(
        bytes4 rewardType,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3
    ) external payable;
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
    ) external payable;
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
    ) external payable;

    function withdraw(address recipient, uint256 amount) external;
}
