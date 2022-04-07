pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    // Our Token Contract | References the YourToken.sol
    YourToken public yourToken;

    // Our token price for ETH
    uint256 public constant tokensPerEth = 100;

    // Start of the event chain
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(
        address seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable returns (uint256 tokenAmount) {
        // We want to make sure the user is sending eth to pay for the token
        require(msg.value > 0, "Send some eth to buy this token!");

        uint256 amountToBuy = msg.value * tokensPerEth;

        // Check if the vendors contract has enough tokens for the transaction
        uint256 vendorBalance = yourToken.balanceOf(address(this)); // balanceOf expects an accounts address as a key.
        require(
            vendorBalance >= amountToBuy,
            "Vendor does not have enough tokens."
        );

        //Transfer token to the initiating contract
        bool sent = yourToken.transfer(msg.sender, amountToBuy);
        require(sent, "Failed to transfer token to user");

        // emit the event
        emit BuyTokens(msg.sender, msg.value, amountToBuy);

        return amountToBuy;
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        // the onlyOwner modifier checks if the owner is == to the msgSender

        // we grab the balance of the contract owner.
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "Owner's balance is too low to withdraw");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send the balance back to the user.");
    }

    // ToDo: create a sellTokens() function:
    function sellTokens(uint256 tokenAmountToSell) public {
        // Check that the requested amount of tokens is greater than 0
        require(tokenAmountToSell > 0, "Need an amount greater tahn zero");

        // check the users token balance
        uint256 userBalance = yourToken.balanceOf(msg.sender);
        require(
            userBalance >= tokenAmountToSell,
            "Your balance of tokens is too low"
        );

        // Check that the vendors balance is enough
        uint256 amountOfEthToTransfer = tokenAmountToSell / tokensPerEth;
        uint256 ownerEthBalance = address(this).balance;
        require(
            ownerEthBalance >= amountOfEthToTransfer,
            "Vendor does not have enough tokens to accept."
        );

        bool sent = yourToken.transferFrom(
            msg.sender,
            address(this),
            tokenAmountToSell
        );
        require(sent, "Failed to transfer tokens from user to vendor");

        (sent, ) = msg.sender.call{value: amountOfEthToTransfer}("");
        require(sent, "Failed to send eth to the user");
    }
}
