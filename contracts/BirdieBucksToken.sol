// contracts/BirdieBucksToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BirdieBucksToken is ERC20, Ownable {
    error MyError(string message);

    address[] public _blacklist;
    address[] public _whitelist;

    address private _taxAccount;

    mapping(address => uint256) public _taxBalances;

    constructor(address taxAcc) ERC20("BirdieBucks", "BIRDIE") {
        _taxAccount = taxAcc;
        _mint(msg.sender, 1000000000 * (10 ** decimals()));
    }

    function addTax(uint256 amount) internal {
        _taxBalances[_taxAccount] += amount;
    }

    function checkAccountInArray(
        address account,
        address[] memory arr
    ) internal pure returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == account) {
                return true;
            }
        }

        return false;
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        uint256 tax = 0;
        if (from != address(0) && to != block.coinbase) {}

        if (checkAccountInArray(from, _blacklist)) {
            revert MyError("The address is in backlist");
        }

        if (!checkAccountInArray(from, _whitelist)) {
            tax = ((value * 30) / 100);
            addTax(tax);
        }

        super._transfer(from, to, value - tax);
    }

    function addToBlackList(address account) public onlyOwner {
        _blacklist.push(account);
    }

    function addToWhiteList(address account) public onlyOwner {
        _whitelist.push(account);
    }

    function taxAccount() public view returns (address) {
        return _taxAccount;
    }

    function destroy() public onlyOwner {
        // selfdestruct(owner());
    }
}
