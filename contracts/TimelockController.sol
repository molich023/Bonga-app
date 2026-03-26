// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/OwnableUpgradeable.sol";

contract TimelockController is OwnableUpgradeable {
    uint256 public constant MIN_DELAY = 24 hours;
    mapping(bytes32 => bool) public queuedTransactions;

    function queueTransaction(
        address target,
        uint256 value,
        string memory functionSignature,
        bytes memory data,
        uint256 eta
    ) external onlyOwner {
        bytes32 txHash = keccak256(abi.encode(target, value, functionSignature, data, eta));
        require(!queuedTransactions[txHash], "Transaction already queued");
        require(eta >= block.timestamp + MIN_DELAY, "ETA too soon");
        queuedTransactions[txHash] = true;
    }

    function executeTransaction(
        address target,
        uint256 value,
        string memory functionSignature,
        bytes memory data,
        uint256 eta
    ) external payable {
        bytes32 txHash = keccak256(abi.encode(target, value, functionSignature, data, eta));
        require(queuedTransactions[txHash], "Transaction not queued");
        require(block.timestamp >= eta, "ETA not reached");
        queuedTransactions[txHash] = false;
        (bool success, ) = target.call{value: value}(abi.encodePacked(
            bytes4(keccak256(bytes(functionSignature))),
            data
        ));
        require(success, "Transaction failed");
    }
}
