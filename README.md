# Forward-Web3-Hack

## Business Idea
https://docs.google.com/document/d/1op5qrDxVVvUaUlHNGmWHjSJXIuA1kl7EZGyCGnTT7t0/edit?usp=sharing

## Smart Contracts
### Google Docs for review:
https://docs.google.com/document/d/1a2isPYo3SdKcWIv-rYu_XO3V2zKk-_gqbMeQzvr3WS0/edit

### File System of repository
In folder `contracts` there are two folders `fixed-rate-staking-contract` and `dynamic-rate-staking-contract`. In both of these folders there is a file with the smart contract code and a folder `...-flattened`, where the flattened version of the code is located. The folder `artifacts` is created automatically during compilation. Lately I'll add a `README.md` file in each folder. 

### Fixed Rate Staking
The `FixedRateStaking` contract facilitates a staking mechanism where users can lock up their tokens for a period and earn rewards based on the duration they keep their tokens staked. It's an implementation of a fixed staking model on the Ethereum blockchain.

For example, suppose a user stakes 100 tokens for 30 days. After the 30-day period, they would earn rewards based on the amount staked and the duration of their stake.

The contract also allows users to unstake their tokens at any time. However, when they unstake, they need to claim their accrued rewards.

The rewards calculation is based on a simple formula: the longer the duration of the stake and the larger the amount staked, the higher the rewards earned. This incentivizes users to keep their tokens staked for longer periods.

Developers can deploy this contract in their decentralized applications (dApps) to provide users with a staking mechanism and incentivize long-term token holding. Users benefit by earning rewards while supporting the network through staking their tokens.

### Dynamic Rate Staking
The dynamic rate staking mechanism in the `DynamicRateStaking` contract provides users with rewards based on the total amount of staked tokens across all users, the individual user's stake amount, and the duration of their stake. 

For instance, suppose there are multiple users staking tokens over various durations. The rewards for each user depend on the total amount of tokens staked by all users and the duration of their stakes relative to others.
