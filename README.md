# Zora Protocol Rewards

Zora is about bringing creativity onchain. Protocol Rewards is our latest offering for creators and developers to earn from their contributions to our growing ecosystem. 

This repository features:
- The `ERC721Rewards` and `ERC1155Rewards` abstract smart contracts which handle reward computation and routing for Zora [ERC-721](https://github.com/ourzora/zora-drops-contracts) and [ERC-1155](https://github.com/ourzora/zora-1155-contracts) NFT mints
- The `ProtocolRewards` singleton smart contract used to deposit and withdraw rewards

Documentation is available at [docs.zora.co](https://docs.zora.co).

## Deployed Addresses

`ProtocolRewards` v1.1 is deterministically deployed at 0x7777777F279eba3d3Ad8F4E708545291A6fDBA8B.

Current Supported Chains:
- Zora Mainnet
- Zora Goerli
- Ethereum Mainnet
- Ethereum Goerli
- OP Mainnet
- OP Goerli
- Base Mainnet
- Base Goerli

## Install

To interact with the `ProtocolRewards` contract:
```sh
yarn add @zoralabs/protocol-rewards
```

To interact with Zora NFT contracts:
```sh
yarn add @zoralabs/nft-drop-contracts @zoralabs/zora-1155-contracts
```

## Bug Bounty
- 5 ETH for any critical bugs that could result in loss of funds.
- Rewards will be given for smaller bugs or ideas.
- Send your bug reports to security@zora.co for a member of our security team to further investigate.
