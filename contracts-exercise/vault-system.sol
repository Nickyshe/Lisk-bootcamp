// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract VaultBase {
    mapping(address => uint256) internal balances;
    uint256 public totalBalance;

    event Deposit(address indexed user, uint256 amount, string message);
    event Withdrawal(address indexed user, uint256 amount, string message);

    function deposit() public virtual payable {

    }

    function withdraw(uint256 amount) public virtual {
        
    }
}

contract VaultManager is VaultBase {
    // Override deposit 
    function deposit() public override payable {
        require(msg.value > 0, "Cannot deposit 0 Ether");

        balances[msg.sender] += msg.value;
        totalBalance += msg.value;

        emit Deposit(msg.sender, msg.value, "Ether deposited successfully");
    }

    // Override withdraw
    function withdraw(uint256 amount) public override {
        require(amount > 0, "Withdraw amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        totalBalance -= amount;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        emit Withdrawal(msg.sender, amount, "Ether withdrawn successfully");
    }

   
}