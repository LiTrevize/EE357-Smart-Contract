pragma solidity ^0.4.0;

import "InsuredFunding.sol";


contract TradableFunding is InsuredFunding {
    struct Sale {
        uint256 amount;
        uint256 price;
    }
    mapping(address => Sale) public sales;

    constructor(
        string memory _name,
        uint256 _goal,
        uint256 _duration
    ) public InsuredFunding(_name, _goal, _duration) {}

    /**
     * You can sell your share (a portion of your support money)
     * with a different price
     */
    function postSale(uint256 amount, uint256 price) public closed {
        require(
            accounts[msg.sender] >= amount,
            "amount should not exceed your share."
        );
        require(sales[msg.sender].amount == 0, "You have posted sales");
        sales[msg.sender] = Sale(amount, price);
    }

    function cancelSale() public {
        delete sales[msg.sender];
    }

    function buyShare(address seller) public payable {
        require(sales[seller].amount > 0, "Invalid seller.");
        require(msg.value == sales[seller].price, "Insufficient money.");
        seller.transfer(sales[seller].price);
        addBacker(msg.sender, sales[seller].amount);
        accounts[seller] -= sales[seller].amount;
        if (accounts[seller] == 0) removeBacker(seller);
        delete sales[seller];
    }
}
