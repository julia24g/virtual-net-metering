//SPDX-License-Identifier: Unlicense
// contracts/House.sol
/// @title A contract with functions and state variables for a house creating solar energy
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

contract House {

    // Declaring state variables
    uint private pvGeneration;
    uint private demand;
    uint public latitude;
    uint public longitude;
    uint public amountReceivedThisHour;
    uint public amountSentThisHour;

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor(uint _latitude, uint _longitude) {       
        latitude = _latitude;
        longitude = _longitude;
        amountSentThisHour = 0;
        amountReceivedThisHour = 0;
        demand = 0;
        pvGeneration = 0;
    } 

    // Creating an initializer for HouseFactory to set coordinates of house and pv generated to 0
    function initialize(uint _latitude, uint _longitude) external {    
        latitude = _latitude;
        longitude = _longitude;
        amountSentThisHour = 0;
        amountReceivedThisHour = 0;
        demand = 0;
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

    // Subtract from pv generation value
    function subtractFromPVGeneration(uint amount) public
    {
        pvGeneration -= amount;
    }

    // Add to pv generation value
    function addToPVGeneration(uint amount) public
    {
        pvGeneration += amount;
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
        demand = _demand;
    }

    // Get demand value
    function getDemand() public view returns (uint)
    {
        return demand;
    }

    function getAmountSet() public view returns (uint)
    {
        return amountSentThisHour;
    }

    function getAmountReceived() public view returns (uint)
    {
        return amountReceivedThisHour;
    }

    function setAmountSent(uint val) public{
        amountSentThisHour += 5 + val;
    }

    function setAmountReceived(uint val) public{
        amountReceivedThisHour += val;
    }

    function resetAmountSentAndAmountReceived() public{
        amountSentThisHour = 0;
        amountReceivedThisHour = 0;
    }
}