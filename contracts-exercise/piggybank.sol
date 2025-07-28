// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerablePiggyBank {
    address public owner;
    mapping(address => uint256) public balances;
    bool private locked;

    constructor() {
        owner = msg.sender;
    }

    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Reentrancy guard modifier
    modifier noReentrant() {
        require(!locked, "No reentrancy allowed!");
        locked = true;
        _;
        locked = false;
    }

    // Withdraw only your own balance, only owner allowed for demonstration
    function withdraw() public noReentrant {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");

        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    // Custom attack function to exploit the vulnerable version 
    function attack(address payable vulnerableContract) public payable {
        VulnerablePiggyBank victim = VulnerablePiggyBank(vulnerableContract);
        // Deposit some ether to victim contract to have a balance
        victim.deposit{value: msg.value}();
        // Start the attack by calling withdraw recursively
        victim.withdraw();
    }

    // Fallback to receive ether during attack reentrancy
    receive() external payable {
        VulnerablePiggyBank victim = VulnerablePiggyBank(payable(msg.sender));
        if (address(victim).balance >= 1 ether) {
            victim.withdraw(); // Reenter vulnerable contract
        }
    }
}
