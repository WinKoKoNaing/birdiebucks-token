// contracts/BirdieBucksToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error BirdieBucks__NotOwner();
error BirdieBucks_Error(string message);

contract BirdieBucksToken is ERC20, Ownable {
    // address private owner;
    uint private _taxPercentage = 300;
    mapping(address => bool) public _blacklist;
    mapping(address => bool) public _whitelist;

    address private _taxAccount = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

    constructor() ERC20("BirdieBucks", "BIRDIE") {
        // owner = msg.sender;
        _mint(msg.sender, 1000_000_000 * (10 ** decimals()));
    }

    // check address using map
    function contains(
        address _wallet,
        mapping(address => bool) storage arr
    ) internal view returns (bool) {
        return arr[_wallet];
    }

    // remove address using loop
    function remove(
        address _wallet,
        mapping(address => bool) storage arr
    ) internal {
        delete arr[_wallet];
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        uint256 taxAmount = 0;

        if (contains(from, _blacklist)) {
            revert BirdieBucks_Error("The address is in backlist");
        }

        if (!contains(from, _whitelist)) {
            taxAmount = ((value * _taxPercentage) / 10000);
            super._transfer(from, _taxAccount, taxAmount);
        }

        super._transfer(from, to, value - taxAmount);
    }

    function addToBlackList(address account) public onlyOwner {
        if (contains(account, _blacklist)) {
            revert BirdieBucks_Error("The address is already in backlist");
        }
        _blacklist[account] = true;
    }

    function removeFromBlackList(address account) public onlyOwner {
        remove(account, _blacklist);
    }

    function addToWhiteList(address account) public onlyOwner {
        if (contains(account, _whitelist)) {
            revert BirdieBucks_Error("The address is already in whitelist");
        }
        _whitelist[account] = true;
    }

    function removeFromWhiteList(address account) public onlyOwner {
        remove(account, _whitelist);
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

    // function getOwner() public view returns (address) {
    //     return owner;
    // }

    // modifier onlyOwner() {
    //     // require(msg.sender == i_owner);
    //     if (msg.sender != owner) revert BirdieBucks__NotOwner();
    //     _;
    // }
}

// owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// acc1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// acc2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
// acc3 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
// taxAccount = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
