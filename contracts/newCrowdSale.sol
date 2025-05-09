// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract newCrowdSale is Ownable {
    uint256 public rate; // tokens per ether
    IERC20 public token; // NWT tokens

    event TokenPurchased(address indexed buyer, uint256 tokens);
    event RateChange(uint256 newRate);
    event ETHwithdraw(uint256 amount);
    event TokensWithdraw(uint256 totalETH);
    event UnsoldToken(uint256 nwtTokens);

    constructor(uint256 _rate, address _token) Ownable(msg.sender){
        require(_rate > 0, "Rate must be > 0");
        require(_token != address(0), "Invalid token address");
        token = IERC20(_token);
        rate = _rate;
    }

    receive() external payable {
        buyTokens();
    }

    function setRate(uint256 newRate) external onlyOwner {
        rate = newRate;
        emit RateChange(newRate);
    }

    function buyTokens() public payable {
        uint256 amount = msg.value * rate;
        require(token.balanceOf(address(this)) >= amount, "Insufficient tokens in contract");
        token.transfer(msg.sender, amount);
        emit TokenPurchased(msg.sender, amount);
    }

    function withdrawETH() external onlyOwner {
        uint256 totalETH = address(this).balance;
        require(totalETH > 0, "Insufficient ETH");
        payable(owner()).transfer(totalETH);
        emit ETHwithdraw(totalETH);
    }

    function withdrawUnsoldToken() external onlyOwner {
        uint256 unsoldToken = token.balanceOf(address(this));
        require(unsoldToken > 0, "No unsold tokens to withdraw");
        token.transfer(owner(), unsoldToken);
        emit UnsoldToken(unsoldToken);
    }
}
