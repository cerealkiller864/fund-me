// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library Price {

    function getPrice() public view returns(uint256) {
        AggregatorV3Interface pricefeed;
        pricefeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e); // ETH/USD pricefeed for the Goerli testnet        
        (,int256 price,,,) = pricefeed.latestRoundData();
        return uint256(price) * 1e8;
    }

    function convert(uint256 amount) public view returns (uint256){
        return getPrice() * amount / 1e18;
    }
}