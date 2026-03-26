// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/OwnableUpgradeable.sol";

contract Gropesa is ERC20Upgradeable, ReentrancyGuard, OwnableUpgradeable {
    uint256 public stakingAPY = 500; // 5% APY
    uint256 public totalStaked;
    mapping(address => Stake) public stakes;

    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 lockDuration;
        bool isCompounding;
    }

    constructor() initializer {}

    function stake(uint256 amount, uint256 lockDurationDays) external nonReentrant {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(lockDurationDays == 30 || lockDurationDays == 90 || lockDurationDays == 180, "Invalid duration");

        _transfer(msg.sender, address(this), amount);
        stakes[msg.sender] = Stake({
            amount: amount,
            startTime: block.timestamp,
            lockDuration: lockDurationDays * 1 days,
            isCompounding: false
        });
        totalStaked += amount;
    }

    function unstake() external nonReentrant {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake");

        uint256 penalty = 0;
        if (block.timestamp < userStake.startTime + userStake.lockDuration) {
            penalty = (userStake.amount * 10) / 100; // 10% penalty
        }

        uint256 reward = calculateReward(msg.sender);
        _transfer(address(this), msg.sender, userStake.amount - penalty + reward);
        totalStaked -= (userStake.amount - penalty);
        delete stakes[msg.sender];
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        if (userStake.amount == 0) return 0;
        uint256 timeStaked = block.timestamp - userStake.startTime;
        return (userStake.amount * stakingAPY * timeStaked) / (365 days * 100 * userStake.lockDuration);
    }

    function setStakingAPY(uint256 newAPY) external onlyOwner {
        stakingAPY = newAPY;
    }
}
