//SPDX-License-Identifier: Unlicense
// contracts/House.sol
/// @title A contract with functions and state variables for a house creating solar energy
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "./Solar.sol";

contract House {

    // Declaring state variables
    uint public pvGeneration;
    uint public demand;
    string public postalCode;
    Solar public token;

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor(string memory _postalCode) {                 
        postalCode = _postalCode;
        pvGeneration = 0;
        console.log("Deployed House by '%s'", msg.sender);
    } 

    // Set pv generation value
    function setPVGeneration(uint _pvGeneration) public
    {
        pvGeneration = _pvGeneration;
        console.log("Set PV generated to ",pvGeneration);    
        checkIfDemandExceeded();
    }

    // Get pv generation value
    function getPVGeneration() public view returns (uint)
    {
        console.log("Get PV generated: ",pvGeneration); 
        return pvGeneration;
    }

    // Set demand Value
    function setDemand(uint _demand) public
    {
        demand = _demand;
        console.log("Set demand to ",demand); 
    }

    // Get demand value
    function getDemand() public view returns (uint)
    {
        return demand;
        console.log("Get demand: ",pvGeneration); 
    }

    // check if PVGeneration is greater than demand
    function checkIfDemandExceeded() internal
    {
        if (pvGeneration > demand)
        {
            token = new Solar(pvGeneration - demand, msg.sender);
            console.log("Solar token balance of account: ", token.balanceOf(msg.sender));
            console.log("From account: ", msg.sender);
            // makeTransfer(msg.sender); 
        }
    }

    function getTokenBalance() public view returns (uint)
    {
        return token.balanceOf(msg.sender);
    }
}