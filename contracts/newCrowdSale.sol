// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract newCrowdSale is Ownable {
    uint256 public rate; // tokens per USDT
    IERC20 public token; // NWT tokens
    IERC20 public USDT; // USDT tokens

    event TokenPurchased(address indexed buyer,uint256 usdtAmount, uint256 tokensAmount);
    event RateChange(uint256 newRate);
    event USDTwithdraw(uint256 amount);
    event TokensWithdraw(uint256 totalUSDT);
    event UnsoldToken(uint256 nwtTokens);

    constructor(uint256 _rate, address _token, address _usdt) Ownable(msg.sender){
        require(_rate > 0, "Rate must be > 0");
        require(_token != address(0), "Invalid token address");
        token = IERC20(_token);
        USDT = IERC20(_usdt);
        rate = _rate;
    }
    
    function setRate(uint256 newRate) external onlyOwner {
        rate = newRate;
        emit RateChange(newRate);
    }

    function buyTokens(uint256 usdtAmount) external {
        require(usdtAmount > 0, "USDTAmount must be greater than zero");
        uint256 amount = usdtAmount * rate;
        require(token.balanceOf(address(this)) >= amount, "Insufficient tokens in contract");
        token.transfer(msg.sender, amount);
        USDT.transferFrom(msg.sender, address(this), usdtAmount);
        emit TokenPurchased(msg.sender, usdtAmount, amount);
    }

    function withdrawUSDT() external onlyOwner {
        uint256 totalUSDT = USDT.balanceOf(address(this));
        require(totalUSDT > 0, "Insufficient USDT");
        USDT.transfer(owner(), totalUSDT);
        emit USDTwithdraw(totalUSDT);
    }

    function withdrawUnsoldToken() external onlyOwner {
        uint256 unsoldToken = token.balanceOf(address(this));
        require(unsoldToken > 0, "No unsold tokens to withdraw");
        token.transfer(owner(), unsoldToken);
        emit UnsoldToken(unsoldToken);
    }
}
