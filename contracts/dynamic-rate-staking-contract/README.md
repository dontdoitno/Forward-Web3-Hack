## Dynamic Rate Smart Contract 

The Dynamic Rate Staking smart contract is designed to facilitate token staking and reward distribution based on dynamically calculated interest rates. It allows users to stake ERC20 tokens and earn rewards based on factors such as staked amount, staking duration, and token supply.

### Usage

The Dynamic Rate Staking smart contract provides a decentralized mechanism for users to stake their tokens and earn rewards based on dynamically calculated interest rates. By staking tokens in the contract, users contribute to the network and are incentivized to hold their tokens for longer durations, leading to increased participation and stability within the ecosystem.

### Dynamic Rate

Dynamic rate staking employs the Weighted Average method, considering factors like total staked amount, staking duration, and token supply to adjust interest rates or rewards within DeFi protocols. This method calculates a weighted sum of factors, with each factor's weight determining its influence on the final rate. By incentivizing desirable behaviors and adapting to market conditions, dynamic rate staking promotes fairness and sustainability within the ecosystem. 
The math equation is

$$\frac{(X_{staked}\ \cdot \ \omega_1)+(X_{duration}\ \cdot \ \omega_2)+(X_{supply}\ \cdot \ \omega_3)}{\omega_1 + \omega_2 +\omega_3},$$

where $X_{staked}$ - total staked amount by user, $X_{duration}$ - staking duration and $X_{supply}$ - token supply. $omega_1, omega_2, and omega_3$ - weights of each factor set by deployer (can choose any combination of omega in their contract). It is recommended to set the omega values so that the sum of all selected omegas is equal to 100, 10 or 1. 

### Audition

`DynamicRateStaking.sol` was audited on `SolidityScan.com` and scored 86.21 points. 

<img width="724" alt="audition" src="https://github.com/dontdoitno/Forward-Web3-Hack/assets/109806789/89d13abf-838b-4d5c-ac36-441f17e30838">

### Tests

Will be add soon
