// contracts/BirdieBucksToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BirdieBucksToken is ERC20, Ownable {
    uint private _taxPercentage = 300;
    address public _taxAccount = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

    mapping(address => bool) public blacklist;
    mapping(address => bool) public whitelist;



    constructor() ERC20("BirdieBucks", "BIRDIE") {
        _mint(msg.sender, 1000_000_000 * (10 ** decimals()));
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        require(!blacklist[from], "IN_BLACK_LIST");
        uint256 taxAmount = 0;
        if (!whitelist[from]) {
            taxAmount = ((value * _taxPercentage) / 10000);
            super._transfer(from, _taxAccount, taxAmount);
        }

        super._transfer(from, to, value - taxAmount);
    }

    function addToBlackList(address account) public onlyOwner {
        require(!blacklist[account], "ALREADY_IN_BLACK_LIST");
        blacklist[account] = true;
    }

    function removeFromBlackList(address account) public onlyOwner {
        require(blacklist[account], "REMOVED_OR_NOT_FOUND_IN_BLACK_LIST");
        blacklist[account] = false;
    }

    function addToWhiteList(address account) public onlyOwner {
        require(!whitelist[account], "ALREADY_IN_WHITE_LIST");
        whitelist[account] = true;
    }

    function removeFromWhiteList(address account) public onlyOwner {
        require(whitelist[account], "REMOVED_OR_NOT_FOUND_IN_WHITE_LIST");
        whitelist[account] = false;
    }

    function updateTaxPercentage(uint256 amount) public onlyOwner {
        _taxPercentage = amount;
    }

    function taxPercentage() public view returns (uint256) {
        return _taxPercentage;
    }

    function taxAccount() public view returns (address) {
        return _taxAccount;
    }

    function updateTaxAccount(address account) public onlyOwner {
        _taxAccount = account;
    }
}

// owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// acc1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// acc2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// acc3 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
// taxAccount = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
