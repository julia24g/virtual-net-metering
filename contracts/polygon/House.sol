//SPDX-License-Identifier: Unlicense
// contracts/House.sol
/// @title A contract with functions and state variables for a house creating solar energy
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;
import "./Solar.sol";

contract House {

    // Declaring state variables
    uint private pvGeneration;
    uint private demand;
    uint private latitude;
    uint private longitude;
    bool private state; // F if need solar, T if don't need solar
    Solar private token;

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor(uint _latitude, uint _longitude) {                 
        latitude = _latitude;
        longitude = _longitude;
        state = false;
    } 

    // Creating an initializer for HouseFactory to set coordinates of house and pv generated to 0
    function initialize(uint _latitude, uint _longitude) external {                 
        latitude = _latitude;
        longitude = _longitude;
        state = false;
        console.log("Deployed House by '%s'", msg.sender);
    } 

    // Set pv generation value
    function setPVGeneration(uint _pvGeneration) public
    {
        pvGeneration = _pvGeneration;
        console.log("Set PV generated to ",pvGeneration);    
        if (pvGeneration > demand)
        {
            token = new Solar(pvGeneration - demand, msg.sender);
            state = true;
        }
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

    // Add to pv generation value
    function addToPVGeneration(uint amount) public
    {
        pvGeneration = pvGeneration + amount;
    }

    // Get latitude
    function getLatitude() public view returns (uint)
    {
        return latitude;
    }

    // Get longitude
    function getLongitude() public view returns (uint)
    {
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
        console.log("Get demand: ", demand); 
        return demand;

    }

    function getState() public view returns (bool)
    {
        console.log("Get state: ", state);
        return state;
    }

    function changeState() public
    {
        state = true;
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