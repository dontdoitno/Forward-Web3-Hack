# Forward-Web3-Hack

## Figma
https://www.figma.com/file/tBKlrdBMVJm8NsrkgipXEl/Staking?type=design&node-id=0%3A1&mode=design&t=Wx1hwEcOgnUgT5QQ-1

## Business Idea
https://docs.google.com/document/d/1op5qrDxVVvUaUlHNGmWHjSJXIuA1kl7EZGyCGnTT7t0/edit?usp=sharing

## Smart Contracts
### Google Docs for review:
https://docs.google.com/document/d/1a2isPYo3SdKcWIv-rYu_XO3V2zKk-_gqbMeQzvr3WS0/edit

### File System of repository
In folder `contracts` there is folder `dynamic-rate-staking-contract`. In the folder there is a file with the smart contract code and a folder `...-flattened`, where the flattened version of the code is located. Test for smart contract located in `test` folder

### Dynamic Rate Staking
The dynamic rate staking mechanism in the `DynamicRateStaking` contract provides users with rewards based on the total amount of staked tokens across all users, the individual user's stake amount, and the duration of their stake. 

For instance, suppose there are multiple users staking tokens over various durations. The rewards for each user depend on the total amount of tokens staked by all users and the duration of their stakes relative to others.
