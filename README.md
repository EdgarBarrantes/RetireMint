# RetireMint

Mint an NFT that will send you a constant stream of your assets while investing the rest.

Pass down this NFT to your loved ones and they'll recieve this stream.

## Main idea

Make it easier for people to secure an income without having to be preocupied about investment details.

## Technical details

Leverages:

- Open Zeppelin contracts
- Superfluid
- Uniswap
- WalletConnect + Coinbase (can be used with many wallets)

The general workflow is for people to mint an NFT by depositing assets into a contract.

They chose the amount they want to retire with and their monthly allowance (which they can always change).

A part of that capital will be liquid capital that will get transformed into a super token, which will then be streamed back to them, while the rest of the capital will be invested. In this case, we're using ETH, so as an strategy we're swapping that ETH for stETH through Uniswap.

The idea is in the future to support different ERC20 tokens and investment strategies that could be chosen according to the depositors preference (an ETH maximalist would like this MVP, but someone more interested in stables would like something DAI based, for example).

### This was built with scaffold-eth, therefore, in order to run:

> install and start your 👷‍ Hardhat chain:

```bash
cd scaffold-eth
yarn install
yarn chain
```

> in a second terminal window, start your 📱 frontend:

```bash
cd scaffold-eth
yarn start
```

> in a third terminal window, 🛰 deploy your contract:

```bash
cd scaffold-eth
yarn deploy
```

This is being done as part of [HackMoney](https://hackathon.money/).
