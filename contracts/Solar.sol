//SPDX-License-Identifier: Unlicense
// contracts/House.sol
/// @title ERC20 contract
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Solar is ERC20 {

    // Creating a constructor to set pv generated
    constructor(uint amount, address owner) ERC20("Solar", "SLR") {
        // not adding anything in constructor because we want to set the number of solar tokens to 0                 
        console.log("Deployed Solar by '%s'", owner);
        _mint(owner, amount);
    }
}