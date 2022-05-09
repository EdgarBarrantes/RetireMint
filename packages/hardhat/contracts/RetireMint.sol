// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RetireMint is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    ERC721Burnable,
    Ownable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct retirement {
        uint256 liquid; // Ether (it'd be nice to be an ERC20).
        uint256 invested; // Ether to invest.
        uint256 time; // Years in seconds. 64 should be enought.
    }

    mapping(uint256 => retirement) retirements;

    // retirements[] retirementList;

    constructor() ERC721("RetireMint", "RETIRE") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://wizard.openzeppelin.com/";
    }

    function safeMint(
        address to,
        string memory uri,
        uint256 _time,
        uint8 _liquidPercentage // Ideal: About a years worth.
    ) public payable {
        require(_liquidPercentage <= 100);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        uint256 _liquid = (msg.value * _liquidPercentage) / 100; // Make this more robust?
        uint256 _invested = msg.value - _liquid;
        retirements[tokenId] = retirement(_liquid, _invested, _time);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Burn function is modified to return assets to user.
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        // Return the corresponding assets.
        uint256 liquidBalance = retirements[tokenId].liquid;
        // Instead of this, transfer the corresponding asset to the user.
        // uint256 investedBalance = retirements[tokenId].invested;
        // Calculate things for this, maybe give data?
        // uint256 timeLeft = retirements[tokenId].time;
        delete retirements[tokenId];
        bool success = payable(msg.sender).send(liquidBalance);
        // Send corresponding asset to the user.
        require(success);
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
