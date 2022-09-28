// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Test {
    
    address private owner;
    uint private balance;

    // store addresses and number of images they submitted
    // TODO: associate addresses with nfts
    mapping(address => uint) private users;

    // store addresses of all accounts (used for indexing map)
    address[] private addresses;

    constructor() {
        balance = 0;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // only owner can add tokens to contract
    function deposit() public payable onlyOwner {
        balance += msg.value;
    }

    function getContractBalance() public view returns(uint) {
        return balance;
    }

    // add address with number of images submitted to contract
    function addUser(uint16 numberOfImages) public {
        users[msg.sender] = numberOfImages;
        addresses.push(msg.sender);
    }

    function getUsers() public view returns(address[] memory) {
        return addresses;
    }

    // only owner can pay someone
    function pay(uint _amount) public onlyOwner {
        require(_amount * 1 ether <= balance, "too much ether");
        (bool sent, ) = msg.sender.call{value: _amount * 1 ether}(""); // bytes memory data
        require(sent, "Failed to send Ether");
        balance -= _amount * 1 ether;
    }

    // pay everyone equal amount
    function payAll() public onlyOwner {
        // devide balance between all users
        uint avg_val = balance / addresses.length;

        // loop through all users and pay according to number of pictures they submitted
        for (uint i = 0; i < addresses.length; i++) {
            uint numberOfPictures = users[addresses[i]];
            (bool sent, ) = addresses[i].call{value: avg_val * numberOfPictures}("");
            require(sent, "Failed to send Ether");
            // reset counter
            users[addresses[i]] = 0;
            balance -= numberOfPictures * avg_val;
        }
    }
}