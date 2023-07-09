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
    uint public latitude;
    uint public longitude;
    Solar public token;
    address public libraryAddress;

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor(uint _latitude, uint _longitude) {                 
        latitude = _latitude;
        longitude = _longitude;
        pvGeneration = 0;
        console.log("Deployed House by '%s'", msg.sender);
    } 

    // Creating an initializer for HouseFactory to set coordinates of house and pv generated to 0
    function initialize(uint _latitude, uint _longitude) public {                 
        latitude = _latitude;
        longitude = _longitude;
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

    // Subtract from pv generation value
    function subtractFromPVGeneration(uint amount) public
    {
        pvGeneration = pvGeneration - amount;
    }

    // Subtract from pv generation value
    function addToPVGeneration(uint amount) public
    {
        pvGeneration = pvGeneration + amount;
    }

    // Get latitude
    function getLatitude() public view returns (uint)
    {
        console.logUint(latitude); 
        return latitude;
    }

    // Get longitude
    function getLongitude() public view returns (uint)
    {
        console.logUint(longitude); 
        return longitude;
    }

    // Set demand Value
    function setDemand(uint _demand) public
    {
        console.log("Set demand to ",_demand); 
        demand = _demand;
    }

    // Get demand value
    function getDemand() public view returns (uint)
    {
        console.log("Get demand: ",demand); 
        return demand;

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

    function booleanNeedPV() public view returns (bool){
        if (pvGeneration > demand){
            return false;
        }
        else{
            return true;
        }
    }

    function getSolarTokenBalance() public view returns (uint)
    {
        return token.balanceOf(msg.sender);
    }

    function getSolarToken() public view returns (Solar)
    {
        return token;
    }
}