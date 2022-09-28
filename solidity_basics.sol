// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract TestContract{

    bool public bool_type = true; 
    int private int_type = 47;
    uint internal uint_type = 3;
    string string_type = "Petar";
    uint16 private balance;
    address public owner;

    constructor() {
        balance = 0;
        owner = msg.sender;
    }

    // function name(params) public/private/internal/external pure/view returns(types) {}

    function errors(int _num) public pure {
        // assert : If condition is false revert state changes (Uses up gas) 
        // require : If condition is false provides option to return message (Refunds Gas)
        // revert : Only sends back a message if condition in if statement calls it
        require(_num != 0, "2nd Number can't be Zero");
        assert(_num > 0);
        if(_num < 0){
            revert("2nd Number Must be Greater than 0");
        }
    }

    function Random(uint _max) public view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp)));
        return rand % _max;
    }

    string str1 = "Hello";
    function combineString(string memory _str1, string memory _str2) public pure returns (string memory){
        return string(abi.encodePacked(_str1, " ", _str2));
    }

    uint[] arr1;
    uint[10] arr2;
    uint [] public numList = [1,2,3,4,5];

    function addToArray(uint num) public {
        arr1.push(num);
    }

    function removeFromArray() public {
        arr1.pop();
    }

    struct Customer {
        string name;
        string custAddress;
        uint age;
    }

    Customer[] public customers;

    function addCust(string memory n, string memory ca, uint a) public {
        customers.push(Customer(n, ca, a));
    }

    function getCust(uint _index) public view returns (string memory n, string memory ca, uint a){
        Customer storage cust = customers[_index];
        return (cust.name, cust.custAddress, cust.age);
    }

    mapping(string => string) public myMap;
    mapping(address => mapping(uint => Customer)) public myCusts;

    function addMyCusts(uint custID, string memory n, string memory ca, uint a) public {
        myCusts[msg.sender][custID] = Customer(n, ca, a);
    }

    function timeUnits() public pure {
        assert(1 seconds == 1);
        assert(1 minutes == 60 seconds);
        assert(1 hours == 60 minutes);
        assert(1 days == 24 hours);
        assert(1 weeks == 7 days);
    }

    enum shirtSize{SMALL, MEDIUM, LARGE}
    shirtSize custSize;
    // Set a default size and mark it as constant
    shirtSize constant defaultSize = shirtSize.MEDIUM;
    function pickShirtSmall() public {
        custSize = shirtSize.SMALL;
    }
}

contract MyLedger {
    mapping(address => uint) public balances;

    function changeBalance(uint newBal) public {
        // msg.sender is the sender of the message
        balances[msg.sender] = newBal;
    }

    function getBalance() public view returns (uint){
        return balances[msg.sender];
    }
}

contract Owner {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Purchase is Owner {
    mapping (address => bool) purchasers;
    uint price;
    constructor(uint _price) {
        price = _price;
    }

    function purchase() public payable {
        purchasers[msg.sender] = true;
    }

    function setPrice(uint _price) public onlyOwner {
        price = _price;
    }
}