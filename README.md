# Simple Mint Burn Token

## Introduction

This project implements a simple rewards mechanism that incentivizes participation from consumers and providers.

* Consumers send tokens to Providers through the `payService(amount, provider_address)` function
    * this represents Consumers paying for Providers' services
* These tokens are imediately burned, while the amount sent to the provider is recorded for forthcoming usage
* The total amount of tokens burned during the epoch is saved
* Once every epoch (1 day), Providers can call `claimRewards()` and earn a of the fixed amount of rewards
    * this portion the ratio of the tokens assigned to them and the total tokens burned during the epoch

## Setup

Try running some of the following tasks:

```shell
npx hardhat compile
npx hardhat test
```

Before proceeding with deployment, create a `.env` file with the variable `WALLET_PRIVATE_KEY={your_private_key_here}`.

```shell
npx hardhat run scripts/deploy.ts --network hardhat
```

## Deployment

For the version deployed on Base Sepolia Testnet, please search for address `0xD86A872Ff3A119C01282652724e2b63F5F89b29c` on [BaseScan](https://sepolia.basescan.org/).

Transaction details [here](https://sepolia.basescan.org/address/0x2352809c01e330a52a55bdf104b8ff6ad606d9ff).