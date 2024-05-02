import { ethers } from 'hardhat';
import { Signer, Contract, ContractFactory } from 'ethers';
import { expect } from 'chai';

describe('DynamicRateStaking', function () {
  let owner: Signer;
  let addr1: Signer;
  let addr2: Signer;
  let DynamicRateStaking: ContractFactory;
  let dynamicRateStaking: Contract;
  let ethers = require('./node_modules/ethers')

  const stakingTokenAddress = ''; // Provide the staking token address
  const rewardTokenAddress = ''; // Provide the reward token address
  const interestRate = 10; // Set the interest rate
  const stakedAmountWeight = 1; // Set the staked amount weight
  const stakingDurationWeight = 1; // Set the staking duration weight
  const tokenSupplyWeight = 1; // Set the token supply weight

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    DynamicRateStaking = await ethers.getContractFactory('DynamicRateStaking');
    dynamicRateStaking = (await DynamicRateStaking.deploy(
      stakingTokenAddress,
      rewardTokenAddress,
      interestRate,
      stakedAmountWeight,
      stakingDurationWeight,
      tokenSupplyWeight
    )) as Contract;

    await dynamicRateStaking.deployed();
  });

  it('should stake tokens', async function () {
    const stakingAmount = ethers.utils.parseEther('10');
    await dynamicRateStaking.stake(stakingAmount);

    expect(await dynamicRateStaking.totalStakedAmount()).to.equal(stakingAmount);
  });

  it('should withdraw tokens', async function () {
    const stakingAmount = ethers.utils.parseEther('10');
    await dynamicRateStaking.stake(stakingAmount);

    expect(await dynamicRateStaking.totalStakedAmount()).to.equal(stakingAmount);

    const initialBalance = await ethers.provider.getBalance(await addr1.getAddress());
    await (dynamicRateStaking as any).withdraw(); // Cast to any to avoid TypeScript errors
    const finalBalance = await ethers.provider.getBalance(await addr1.getAddress());

    expect(finalBalance.gt(initialBalance)).to.be.true;
  });
});
