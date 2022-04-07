pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    // erc20 constructor expects a '_name' & _symbol
    constructor() ERC20("Gold", "GLD") {
        // erc20's mint method expects an address, and an amount
        _mint(msg.sender, 1000 * 10**18);

        /**
        Relevant ERC20 methods:

    1.  balanceOf() expects an address
        -Which returns the balance of an account-

    2.  transfer() expects an address "to" which will be the address you want to transfer "to", expects an amount
        -calls the solidity transfer method that sends the amount to the specified address-
        actual transfer() function looks like this,
        _transfer(owner, to, amount) owner is set as the _msgSender()
         */
    }
}
