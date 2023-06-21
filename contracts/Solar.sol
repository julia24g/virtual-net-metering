// contracts/House.sol
/// @title A contract with functions and state variables for a house creating solar energy
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Solar is ERC20 {

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor() public ERC20("Solar", "SLR") {
        // not adding anything in constructor because we want to set the number of solar tokens to 0                 
    }

}