import { defineConfig } from '@wagmi/cli'

export default defineConfig({
  out: 'dist/index.ts',
  contracts: [
    {
      name: 'ProtocolRewards',
      address: {
        5: '0x8Ca5e648C5dFEfcdDa06d627F4b490B719ccFD98',
        420: '0x421B6ad0CdD20bE3636F3511B6ae244d8F668dB1',
        999: '0xF62b0d56BA617F803DF1C464C519FF7D29451B2f',
        84531: '0xd34872BE0cdb6b09d45FCa067B07f04a1A9aE1aE',
      },
      abi: [
        {
          inputs: [],
          stateMutability: 'payable',
          type: 'constructor',
        },
        {
          inputs: [],
          name: 'ADDRESS_ZERO',
          type: 'error',
        },
        {
          inputs: [],
          name: 'ARRAY_LENGTH_MISMATCH',
          type: 'error',
        },
        {
          inputs: [],
          name: 'INVALID_DEPOSIT',
          type: 'error',
        },
        {
          inputs: [],
          name: 'INVALID_SIGNATURE',
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
            {
              indexed: false,
              internalType: 'string',
              name: 'comment',
              type: 'string',
            },
          ],
          name: 'Deposit',
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
              name: 'mintReferral',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'mintReferralReward',
              type: 'uint256',
            },
            {
              indexed: false,
              internalType: 'address',
              name: 'createReferral',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'createReferralReward',
              type: 'uint256',
            },
            {
              indexed: true,
              internalType: 'address',
              name: 'firstMinter',
              type: 'address',
            },
            {
              indexed: false,
              internalType: 'uint256',
              name: 'firstMinterReward',
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
          name: 'RewardsDeposit',
          type: 'event',
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
              internalType: 'uint256',
              name: 'amount',
              type: 'uint256',
            },
          ],
          name: 'Withdraw',
          type: 'event',
        },
        {
          inputs: [],
          name: 'WITHDRAW_TYPEHASH',
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
          inputs: [
            {
              internalType: 'address',
              name: '',
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
              name: 'amounts',
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
              name: 'mintReferral',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'mintReferralReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'createReferral',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'createReferralReward',
              type: 'uint256',
            },
            {
              internalType: 'address',
              name: 'firstMinter',
              type: 'address',
            },
            {
              internalType: 'uint256',
              name: 'firstMinterReward',
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
          name: 'depositRewards',
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
              name: '',
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
