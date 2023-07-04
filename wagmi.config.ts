import { defineConfig } from '@wagmi/cli'

export default defineConfig({
  out: 'dist/index.ts',
  contracts: [
    {
      name: 'ZoraRewards',
      address: {
        5: '0x421B6ad0CdD20bE3636F3511B6ae244d8F668dB1',
        999: '0x421B6ad0CdD20bE3636F3511B6ae244d8F668dB1',
      },
      abi: [
        {
          inputs: [
            {
              internalType: 'string',
              name: 'tokenName',
              type: 'string',
            },
            {
              internalType: 'string',
              name: 'tokenSymbol',
              type: 'string',
            },
          ],
          stateMutability: 'payable',
          type: 'constructor',
        },
        {
          inputs: [],
          name: 'INVALID_DEPOSIT',
          type: 'error',
        },
        {
          inputs: [],
          name: 'INVALID_SIGNER',
          type: 'error',
        },
        {
          inputs: [],
          name: 'INVALID_WITHDRAW',
          type: 'error',
        },
        {
          inputs: [],
          name: 'InvalidShortString',
          type: 'error',
        },
        {
          inputs: [],
          name: 'RECIPIENTS_AND_AMOUNTS_LENGTH_MISMATCH',
          type: 'error',
        },
        {
          inputs: [],
          name: 'SIGNATURE_DEADLINE_EXPIRED',
          type: 'error',
        },
        {
          inputs: [
            {
              internalType: 'string',
              name: 'str',
              type: 'string',
            },
          ],
          name: 'StringTooLong',
          type: 'error',
        },
        {
          inputs: [],
          name: 'TRANSFER_FAILED',
          type: 'error',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: true,
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'spender',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'value',
              type: 'uint256',
            },
          ],
          name: 'Approval',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [],
          name: 'EIP712DomainChanged',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: true,
              internalType: 'address',
              name: 'from',
              type: 'address',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'to',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'value',
              type: 'uint256',
            },
          ],
          name: 'Transfer',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: true,
              internalType: 'address',
              name: 'from',
              type: 'address',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'recipient',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
          ],
          name: 'ZoraRewardsBurn',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: true,
              internalType: 'bytes4',
              name: 'rewardType',
              type: 'bytes4',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'from',
              type: 'address',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'creator',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'creatorReward',
              type: 'uint256',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'finder',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'finderReward',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'origin',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'originReward',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'zora',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'zoraReward',
              type: 'uint256',
            },
          ],
          name: 'ZoraRewardsMint',
          type: 'event',
        },
        {
          anonymous: false,
          inputs: [
            {
              indexed: true,
              internalType: 'address',
              name: 'from',
              type: 'address',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'recipient',
              type: 'address',
            },
            {
              indexed: true,
              internalType: 'uint256',
              name: 'reward',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'string',
              name: 'comment',
              type: 'string',
            },
          ],
          name: 'ZoraRewardsMint',
          type: 'event',
        },
        {
          inputs: [],
          name: 'DOMAIN_SEPARATOR',
          outputs: [
            {
              internalType: 'bytes32',
              name: '',
              type: 'bytes32',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'ZORA_FREE_MINT_REWARD_TYPE',
          outputs: [
            {
              internalType: 'bytes4',
              name: '',
              type: 'bytes4',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'ZORA_PAID_MINT_REWARD_TYPE',
          outputs: [
            {
              internalType: 'bytes4',
              name: '',
              type: 'bytes4',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'address',
              name: 'spender',
              type: 'address',
            },
          ],
          name: 'allowance',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'spender',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
          ],
          name: 'approve',
          outputs: [
            {
              internalType: 'bool',
              name: '',
              type: 'bool',
            },
          ],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'account',
              type: 'address',
            },
          ],
          name: 'balanceOf',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'decimals',
          outputs: [
            {
              internalType: 'uint8',
              name: '',
              type: 'uint8',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'spender',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'subtractedValue',
              type: 'uint256',
            },
          ],
          name: 'decreaseAllowance',
          outputs: [
            {
              internalType: 'bool',
              name: '',
              type: 'bool',
            },
          ],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'recipient',
              type: 'address',
            },
            {
              internalType: 'string',
              name: 'comment',
              type: 'string',
            },
          ],
          name: 'deposit',
          outputs: [],
          stateMutability: 'payable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address[]',
              name: 'recipients',
              type: 'address[]',
            },
            {
              internalType: 'uint256[]',
              name: 'rewards',
              type: 'uint256[]',
            },
            {
              internalType: 'string',
              name: 'comment',
              type: 'string',
            },
          ],
          name: 'depositBatch',
          outputs: [],
          stateMutability: 'payable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'creator',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'creatorReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'finder',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'finderReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'origin',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'originReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'zora',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'zoraReward',
              type: 'uint256',
            },
          ],
          name: 'depositFreeMintRewards',
          outputs: [],
          stateMutability: 'payable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'finder',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'finderReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'origin',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'originReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'zora',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'zoraReward',
              type: 'uint256',
            },
          ],
          name: 'depositPaidMintRewards',
          outputs: [],
          stateMutability: 'payable',
          type: 'function',
        },
        {
          inputs: [],
          name: 'eip712Domain',
          outputs: [
            {
              internalType: 'bytes1',
              name: 'fields',
              type: 'bytes1',
            },
            {
              internalType: 'string',
              name: 'name',
              type: 'string',
            },
            {
              internalType: 'string',
              name: 'version',
              type: 'string',
            },
            {
              internalType: 'uint256',
              name: 'chainId',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'verifyingContract',
              type: 'address',
            },
            {
              internalType: 'bytes32',
              name: 'salt',
              type: 'bytes32',
            },
            {
              internalType: 'uint256[]',
              name: 'extensions',
              type: 'uint256[]',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'spender',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'addedValue',
              type: 'uint256',
            },
          ],
          name: 'increaseAllowance',
          outputs: [
            {
              internalType: 'bool',
              name: '',
              type: 'bool',
            },
          ],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [],
          name: 'name',
          outputs: [
            {
              internalType: 'string',
              name: '',
              type: 'string',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
          ],
          name: 'nonces',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'address',
              name: 'spender',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'value',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'deadline',
              type: 'uint256',
            },
            {
              internalType: 'uint8',
              name: 'v',
              type: 'uint8',
            },
            {
              internalType: 'bytes32',
              name: 'r',
              type: 'bytes32',
            },
            {
              internalType: 'bytes32',
              name: 's',
              type: 'bytes32',
            },
          ],
          name: 'permit',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [],
          name: 'symbol',
          outputs: [
            {
              internalType: 'string',
              name: '',
              type: 'string',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [],
          name: 'totalSupply',
          outputs: [
            {
              internalType: 'uint256',
              name: '',
              type: 'uint256',
            },
          ],
          stateMutability: 'view',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'to',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
          ],
          name: 'transfer',
          outputs: [
            {
              internalType: 'bool',
              name: '',
              type: 'bool',
            },
          ],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'from',
              type: 'address',
            },
            {
              internalType: 'address',
              name: 'to',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
          ],
          name: 'transferFrom',
          outputs: [
            {
              internalType: 'bool',
              name: '',
              type: 'bool',
            },
          ],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'recipient',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
          ],
          name: 'withdraw',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
        {
          inputs: [
            {
              internalType: 'address',
              name: 'owner',
              type: 'address',
            },
            {
              internalType: 'address',
              name: 'recipient',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
            {
              internalType: 'uint256',
              name: 'deadline',
              type: 'uint256',
            },
            {
              internalType: 'uint8',
              name: 'v',
              type: 'uint8',
            },
            {
              internalType: 'bytes32',
              name: 'r',
              type: 'bytes32',
            },
            {
              internalType: 'bytes32',
              name: 's',
              type: 'bytes32',
            },
          ],
          name: 'withdrawWithSig',
          outputs: [],
          stateMutability: 'nonpayable',
          type: 'function',
        },
      ],
    },
  ],
  plugins: [],
})
