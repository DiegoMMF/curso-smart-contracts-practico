// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Achievement is ERC721("Achievements","ACH"), Ownable {

    uint lastTokenId;

    function emitir(address destino) public onlyOwner returns(uint) {
        uint tokenId = lastTokenId;
        lastTokenId++;
        _safeMint(destino, tokenId);
        return tokenId;
    }

    constructor() {
        _mint(msg.sender, 1);
    }

}