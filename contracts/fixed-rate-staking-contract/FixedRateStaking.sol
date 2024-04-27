// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FixedStaking is ERC20 {

    mapping(address => uint256) public staked;
    // Mapping to keep track of the amount staked by each address.

    mapping(address => uint256) private stakedFromTS;
    // Mapping to store the timestamp when tokens were staked by each address.

    constructor() ERC20("Fixed Staking", "FIX") {
        _mint(msg.sender, 1000000000000000000);
    }

    function stake(uint256 amount) external {
        // Function to stake tokens.
        require(amount > 0, "amount is <= 0");
        // Requires the staked amount to be greater than zero.
        require(balanceOf(msg.sender) >= amount, "balance is <= amount");
        // Requires the sender to have enough tokens to stake.
        _transfer(msg.sender, address(this), amount);
        // Transfers the specified amount of tokens from the sender to the contract.
        if (staked[msg.sender] > 0) {
            claim();
            // If the sender has previously staked tokens, calls the claim function to calculate and mint rewards.
        }
        stakedFromTS[msg.sender] = block.timestamp;
        // Records the timestamp when the tokens were staked.
        staked[msg.sender] += amount;
        // Increments the total staked amount for the sender.
    }

    function unstake(uint256 amount) external {
        // Function to unstake tokens
        require(amount > 0, "amount is <= 0");
        // Requires the unstaked amount to be greater than zero
        require(staked[msg.sender] >= amount, "amount is > staked");
        // Requires the sender to have enough tokens staked
        claim();
        // Calls the claim function to calculate and mint rewards
        staked[msg.sender] -= amount;
        // Decrements the total staked amount for the sender
        _transfer(address(this), msg.sender, amount);
        // Transfers the unstaked tokens back to the sender
    }

    function claim() public {
        // Function to claim rewards.
        require(staked[msg.sender] > 0, "staked is <= 0");
        // Requires the sender to have staked tokens
        uint256 secondsStaked = block.timestamp - stakedFromTS[msg.sender];
        // Calculates the duration for which tokens have been staked
        uint256 rewards = staked[msg.sender] * secondsStaked / 3.154e7;
        // Calculates the rewards based on the staked amount and duration
        // 3.154e7 is a number of seconds in a year
        _mint(msg.sender, rewards);
        // Mints the calculated rewards and assigns them to the sender
        stakedFromTS[msg.sender] = block.timestamp;
        // Updates the timestamp of when tokens were last staked by the sender
    }
}
