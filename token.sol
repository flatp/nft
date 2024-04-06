// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    uint256 public conversionRate; // Conversion rate for MATIC to Token

    constructor(uint256 _initialSupply, uint256 _conversionRate) ERC20("MyToken", "MTK") {
        _mint(msg.sender, _initialSupply);
        conversionRate = _conversionRate;
    }

    // Function to buy tokens with MATIC
    function buyTokens() public payable {
        uint256 tokensToBuy = msg.value * conversionRate;
        _mint(msg.sender, tokensToBuy);
    }

    // Function to sell tokens for MATIC
    function sellTokens(uint256 _tokenAmount) public {
        require(balanceOf(msg.sender) >= _tokenAmount, "Not enough tokens");
        uint256 maticToTransfer = _tokenAmount / conversionRate;
        payable(msg.sender).transfer(maticToTransfer);
        _burn(msg.sender, _tokenAmount);
    }

    // Function to set conversion rate
    function setConversionRate(uint256 _newRate) public {
        // Add onlyOwner modifier or similar access control for production
        conversionRate = _newRate;
    }

    // Function to withdraw MATIC (for owner)
    function withdrawMatic(uint256 _amount) public {
        // Add onlyOwner modifier or similar access control for production
        payable(msg.sender).transfer(_amount);
    }

    // Fallback function to handle receiving MATIC
    receive() external payable {
        buyTokens();
    }
}
