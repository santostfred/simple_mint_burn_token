// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// how to correctly import ERC20.sol and Ownable.sol from OpenZeppelin?
// https://ethereum.stackexchange.com/questions/110677/how-to-correctly-import-erc20-sol-and-ownable-sol-from-openzeppelin

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SimpleMintBurnToken is ERC20, Ownable {

    uint256 private constant MAX_UINT256 = type(uint256).max;
    uint256 private constant INITIAL_SUPPLY = 1000000 * 10**18;

    // The proofOfBurnedTokens mapping replaces:
    // 1. the Consumer (msg.sender) sending tokens to the contract and burning them
    // 2. the contract sending Proofs of Burned Tokens to the Consumer
    // 3. the Provider receiving the Proofs of Burned Tokens
    // The Provider can then redeem the Proofs of Burned Tokens for a reward
    mapping(address => uint256) private proofOfBurnedTokens;
    uint256 private numTokensBurnedLastEpoch;
    uint256 private numTokensBurnedThisEpoch;

    uint256 private rewardAmount;

    uint256 private rewardInterval;

    uint256 private rewardStartTime;
    bool private lastEpochFinalized;

    constructor() ERC20("SimpleMintBurnToken", "SMBT") Ownable(msg.sender) {

        _mint(owner(), INITIAL_SUPPLY);

        rewardStartTime = block.timestamp;
        rewardInterval = 10 minutes;
        rewardAmount = 1000 * 10**18;
        lastEpochFinalized = false;

        numTokensBurnedLastEpoch = 0;
        numTokensBurnedThisEpoch = 0;
    }

    function payService(uint256 amount, address provider) public {
        // first the function checks whether the epoch can be finalized
        finalizeEpoch();

        // the Consumer can only pay for the service if they have enough tokens
        _burn(msg.sender, amount);
        // the burned tokens are added to the Provider's proofOfBurnedTokens
        proofOfBurnedTokens[provider] += amount;
        // the total number of tokens burned this epoch is updated
        numTokensBurnedThisEpoch += amount;
    }

    function claimRewards() public {
        // first the function checks whether the epoch can be finalized
        finalizeEpoch();

        // the Provider can only claim rewards if tokens were burned last epoch
        require(numTokensBurnedLastEpoch > 0, "No tokens burned last epoch");

        // the Provider can only claim rewards if they provided a service
        uint256 serviceProvided = proofOfBurnedTokens[msg.sender];
        // rewardCount is proportinal to the work performed by the Provider wrt the total work performed by all Providers
        uint256 rewardCount = serviceProvided / numTokensBurnedLastEpoch;
        // the reward is the rewardAmount multiplied by the rewardCount
        uint256 reward = rewardAmount * rewardCount;

        // the Provider receives the reward
        _mint(msg.sender, reward);

        // the Provider's proofOfBurnedTokens is reset to 0, as the Provider has already been rewarded
        proofOfBurnedTokens[msg.sender] = 0;

        emit ClaimReward(msg.sender, reward);
    }

    function finalizeEpoch() public {
        // the epoch can only be finalized once rewardInterval has passed since the last rewardStartTime
        if (block.timestamp >= rewardStartTime + rewardInterval) {
            // calculate the new rewardStartTime, taking into account a possible lack of activity in the last epoch
            uint256 i = 1;
            while (block.timestamp >= rewardStartTime + i * rewardInterval) {
                i++;
            }
            // rewardStartTime is updated
            rewardStartTime += i * rewardInterval;

            // the number of tokens burned last epoch is updated
            numTokensBurnedLastEpoch = numTokensBurnedThisEpoch;
            // the number of tokens burned this epoch is reset to 0
            numTokensBurnedThisEpoch = 0;
        }
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(owner(), amount);
        _transfer(owner(), to, amount);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        _transfer(from, owner(), amount);
        _burn(owner(), amount);
    }

    function getRewardAmount() public view returns (uint256) {
        return rewardAmount;
    }

    function getRewardInterval() public view returns (uint256) {
        return rewardInterval;
    }

    function getRewardStartTime() public view returns (uint256) {
        return rewardStartTime;
    }

    event ClaimReward(address indexed to, uint256 value);
}