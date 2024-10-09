pragma solidity 0.8.4; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(uint256 amountOfTokens, uint256 amountOfETH);

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy tokens");
        uint256 tokensToBuy = msg.value * tokensPerEth;
        require(yourToken.balanceOf(address(this)) >= tokensToBuy, "Vendor has insufficient tokens");

        bool sent = yourToken.transfer(msg.sender, tokensToBuy);
        require(sent, "Token transfer failed");

        emit BuyTokens(msg.sender, msg.value, tokensToBuy);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH available for withdrawal");
        
        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send ETH");
    }

    function sellTokens(uint256 tokenAmountToSell) public {
        require(tokenAmountToSell > 0, "Specify an amount of tokens greater than zero");
        uint256 userBalance = yourToken.balanceOf(msg.sender);
        require(userBalance >= tokenAmountToSell, "You don't have enough tokens");

        uint256 amountOfETHToTransfer = tokenAmountToSell / tokensPerEth;
        uint256 ownerETHBalance = address(this).balance;
        require(ownerETHBalance >= amountOfETHToTransfer, "Vendor has insufficient ETH balance");

        bool sent = yourToken.transferFrom(msg.sender, address(this), tokenAmountToSell);
        require(sent, "Failed to transfer tokens from user to vendor");

        (sent, ) = msg.sender.call{value: amountOfETHToTransfer}("");
        require(sent, "Failed to send ETH to the user");

        emit SellTokens(tokenAmountToSell, amountOfETHToTransfer);
    }

    // Do not need to implement receiveTokens as tokens can be transferred directly to the contract

    // Do not need to implement transferOwnership as it's inherited from Ownable
}