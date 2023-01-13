// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

import "./Price.sol";


contract Fund
{
    using Price for uint256;

    uint256 public constant MINIMUM_USD = 50;
    address public immutable OWNER;
    address[] public funders;
    mapping(address=>uint256) public AddressToAmount; 
    
    constructor() {
        OWNER = msg.sender;
    }

    function fund() public payable {
        require(msg.value.convert() >= MINIMUM_USD, "Minimum amount not reached! Transaction has been reverted");
        funders.push(msg.sender);
        AddressToAmount[msg.sender] += msg.value;
    }

    function withdraw() public OnlyOwner {
        for (uint256 i=0; i<funders.length; i++) {
            AddressToAmount[funders[i]] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("Here is your fund withdrawal, please don't spend it on personal purposes");
        require(callSuccess, "Cannot withdraw fund");
    }

    modifier OnlyOwner {
        require(msg.sender == OWNER, "Only the owner of this funding is allowed to withdraw to funded money!");
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}