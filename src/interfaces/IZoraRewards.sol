// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

interface IZoraRewards {
    event RewardsAdded(bytes4 indexed rewardType, address recipient, uint256 amount);
    event RewardsAdded(
        bytes4 indexed rewardType, address recipient1, uint256 amount1, address recipient2, uint256 amount2
    );
    event RewardsAdded(
        bytes4 indexed rewardType,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3
    );
    event RewardsAdded(
        bytes4 indexed rewardType,
        address recipient1,
        uint256 amount1,
        address recipient2,
        uint256 amount2,
        address recipient3,
        uint256 amount3,
        address recipient4,
        uint256 amount4
    );
    event RewardsAdded(
        bytes4 indexed rewardType,
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

    error INVALID_DEPOSIT_AMOUNT();
    error INVALID_WITHDRWAL_AMOUNT();
    error INVALID_TOKEN_QUANTITY();
    error TRANSFER_FAILED();

    function deposit(bytes4 rewardType, address recipient, uint256 amount) external payable;
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
