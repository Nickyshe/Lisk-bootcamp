// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract UserProfile {

    struct User {
        string name;
        uint256 age;
        string email;
        uint256 registeredAt;
    }

    // Mapping from address to user profile
    mapping(address => User) public users;
    // To know if an address has registered
    mapping(address => bool) public registered;

    // Register a new user
    function register(string memory _name, uint256 _age, string memory _email) public {
        require(!registered[msg.sender], "Already registered.");
        users[msg.sender] = User({
            name: _name,
            age: _age,
            email: _email,
            registeredAt: block.timestamp
        });
        registered[msg.sender] = true;
    }

    // Update existing user profile
    function updateProfile(string memory _name, uint256 _age, string memory _email) public {
        require(registered[msg.sender], "Not registered.");
        users[msg.sender].name = _name;
        users[msg.sender].age = _age;
        users[msg.sender].email = _email;
        
    }

    // Get your own profile details
    function getProfile() public view returns (string memory name, uint256 age, string memory email, uint256 registeredAt) {
        require(registered[msg.sender], "Not registered.");
        User storage user = users[msg.sender];
        return (user.name, user.age, user.email, user.registeredAt);
    }


}
