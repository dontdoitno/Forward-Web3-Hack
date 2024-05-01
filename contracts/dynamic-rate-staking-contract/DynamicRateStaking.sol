// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DynamicRateStaking is ReentrancyGuard {
    // ERC20 staking and reward tokens contract
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public immutable owner;

    // Interest rate and reward variables
    uint256 public immutable interestRate;
    uint256 public totalStakedAmount;

    // Struct to store staker information
    struct StakerInfo {
        uint256 stakedAmount;
        uint256 stakingStartTime;
        uint256 tokenSupply;
        uint256 reward;
    }

    // Mapping to store staker information
    mapping(address => StakerInfo) public stakerInfo;

    // Factors' weights
    uint256 public stakedAmountWeight;
    uint256 public stakingDurationWeight;
    uint256 public tokenSupplyWeight;

    // Events
    event TokensStaked(address indexed staker, uint256 amount);
    event TokensWithdrawn(address indexed staker, uint256 amount, uint256 reward);

    // Constructor to initialize the contract with staking and rewards tokens
    constructor(address _stakingToken, address _rewardToken, uint256 _interestRate, uint256 _stakedAmountWeight, uint256 _stakingDurationWeight, uint256 _tokenSupplyWeight) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardToken);
        interestRate = _interestRate;
        stakedAmountWeight = _stakedAmountWeight;
        stakingDurationWeight = _stakingDurationWeight;
        tokenSupplyWeight = _tokenSupplyWeight;
    }

    // Modifier to restrict access to only the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Function to stake tokens
    function stake(uint256 _amount) external payable nonReentrant {
        require(_amount > 0, "Amount must be greater than 0");
        require(msg.value == 0, "Function is not payable");
        require(stakingToken.allowance(msg.sender, address(this)) > _amount, "Insufficient allowance");

        StakerInfo storage info = stakerInfo[msg.sender];

        // Transfer tokens from sender to contract
        require(stakingToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        // Update staker information
        info.stakedAmount = info.stakedAmount + _amount;
        totalStakedAmount = totalStakedAmount + _amount;
        info.tokenSupply = rewardsToken.balanceOf(msg.sender);
        info.stakingStartTime = block.timestamp;

        emit TokensStaked(msg.sender, _amount);
    }

    // Function to withdraw staked tokens and rewards
    function withdraw() external nonReentrant payable {
        StakerInfo storage info = stakerInfo[msg.sender];

        require(info.stakedAmount > 0, "No tokens staked");

        // Calculate rewards based on staked amount, staking duration, token supply, and current interest rate
        uint256 stakingDuration = block.timestamp - info.stakingStartTime;
        uint256 reward = calculateReward(info.stakedAmount, stakingDuration, info.tokenSupply);

        // Update rewards
        info.reward += reward;

        // Transfer staked tokens and rewards to sender
        require(stakingToken.transfer(msg.sender, info.stakedAmount), "Staked token transfer failed");
        require(rewardsToken.transfer(msg.sender, reward), "Reward token transfer failed");

        // Reset staked amount and staking start time
        info.stakedAmount = 0;
        info.stakingStartTime = 0;

        emit TokensWithdrawn(msg.sender, info.stakedAmount, reward);
    }

    // Function to calculate reward based on factors and current interest rate
    function calculateReward(uint256 _stakedAmount, uint256 _stakingDuration, uint256 _tokenSupply) internal view returns (uint256) {
        uint256 weightedAverage = (_stakedAmount * stakedAmountWeight) + (_stakingDuration * stakingDurationWeight) + (_tokenSupply * tokenSupplyWeight);
        uint256 totalWeights = stakedAmountWeight + stakingDurationWeight + tokenSupplyWeight;
        uint256 calculatedInterestRate = (interestRate * weightedAverage) / (totalWeights * 100);
        return (_stakedAmount * calculatedInterestRate) / 100;
    }

    // Function to update factors' weights (onlyOwner)
    function updateWeights(uint256 _stakedAmountWeight, uint256 _stakingDurationWeight, uint256 _tokenSupplyWeight) external onlyOwner {
        // Update factors' weights
        stakedAmountWeight = _stakedAmountWeight;
        stakingDurationWeight = _stakingDurationWeight;
        tokenSupplyWeight = _tokenSupplyWeight;
    }
}
