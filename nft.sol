// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/IERC721Receiver.sol";

contract MyToken is ERC721URIStorage, Ownable, ReentrancyGuard, IERC721Receiver {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public price = 10 ** 17; // 初期価格


    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {}


    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }


    function setPrice(uint256 newPrice) public onlyOwner {
        price = newPrice * (10 ** 17);
    }


    function onERC721Received(
        address /* operator */,
        address from,
        uint256 tokenId,
        bytes calldata /* data */
    ) external override returns (bytes4) {
        // このコントラクトでミントされたトークンIDのみをチェック
        require(tokenId <= _tokenIdCounter.current(), "Token was not minted here");
        // トークンの以前の所有者にpriceを返す
        payable(from).transfer(price);
        return this.onERC721Received.selector;
    }


    receive() external payable {}


    // コントラクトのMATIC残高を引き出す関数
    function withdraw() public onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "Contract balance is zero");
        payable(owner()).transfer(balance);
    }
}
