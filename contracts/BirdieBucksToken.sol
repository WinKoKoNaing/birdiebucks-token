// contracts/BirdieBucksToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BirdieBucksToken is ERC20, Ownable {
    uint256 private _taxPercentage = 300;
    address private _taxAccount = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

    mapping(address => bool) private _blacklist;
    mapping(address => bool) private _whitelist;

    event UpdatedPercentage(
        uint256 indexed oldNum,
        uint256 indexed newNum,
        address sender
    );

    constructor() ERC20("BirdieBucks", "BIRDIE") {
        _mint(msg.sender, 1000_000_000 * (10 ** decimals()));
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        require(!_blacklist[from], "IN_BLACK_LIST");
        uint256 taxAmount = 0;
        if (!_whitelist[from]) {
            taxAmount = ((value * _taxPercentage) / 10000);
            super._transfer(from, _taxAccount, taxAmount);
        }
        super._transfer(from, to, value - taxAmount);
    }

    function addToBlackList(address account) external onlyOwner {
        require(!_blacklist[account], "ALREADY_IN_BLACK_LIST");
        _blacklist[account] = true;
    }

    function removeFromBlackList(address account) external onlyOwner {
        require(_blacklist[account], "REMOVED_FROM_BLACK_LIST");
        _blacklist[account] = false;
    }

    function addToWhiteList(address account) external onlyOwner {
        require(!_whitelist[account], "ALREADY_IN_WHITE_LIST");
        _whitelist[account] = true;
    }

    function removeFromWhiteList(address account) external onlyOwner {
        require(_whitelist[account], "REMOVED_FROM_WHITE_LIST");
        _whitelist[account] = false;
    }

    function updateTaxPercentage(uint256 amount) external onlyOwner {
        emit UpdatedPercentage(_taxPercentage, amount, msg.sender);
        _taxPercentage = amount;
    }

    function taxPercentage() external view returns (uint256) {
        return _taxPercentage;
    }

    function taxAccount() external view returns (address) {
        return _taxAccount;
    }

    function updateTaxAccount(address account) external onlyOwner {
        require(account != address(0), "NOT_ALLOW_ZERO_ADDR");
        _taxAccount = account;
    }

    function blackList(address account) external view returns (bool) {
        return _blacklist[account];
    }

    function whiteList(address account) external view returns (bool) {
        return _whitelist[account];
    }
}

// owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// acc1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// acc2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// acc3 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
// taxAccount = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
