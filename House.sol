// contracts/House.sol
/// @title A contract with functions and state variables for a house creating solar energy
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SolarToken is ERC20 {

    // Declaring state variables
    uint public pvGeneration;
    uint public demand;
    string public postalCode;

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor(uint _postalCode) ERC20("Solar", "SLR") {                 
        postalCode = _postalCode;
        pvGeneration = 0;    
    } 

    // Set pv generation value
    function setPVGeneration(uint _pvGeneration) public
    {
        pvGeneration = _pvGeneration;
    }

    // Get pv generation value
    function getPVGeneration() public view returns (uint)
    {
        return pvGeneration;
    }

    // Set demand Value
    function setDemand(uint _demand) public
    {
        demand = _demand;
    }

    // Get demand value
    function getDemand() public view returns (uint)
    {
        return demand;
    }

    // check if PVGeneration is greater than demand
    function demandExceeded() private view returns (bool)
    {
        if (pvGeneration > demand)
        {
            return true;
        }
        else
        {
            return false;
        }
    }


}