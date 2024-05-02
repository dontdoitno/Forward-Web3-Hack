// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/ReentrancyGuard.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: DynamicRateStaking.sol



pragma solidity ^0.8.24;



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
