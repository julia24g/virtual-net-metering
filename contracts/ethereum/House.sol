//SPDX-License-Identifier: Unlicense
// contracts/House.sol
/// @title A contract with functions and state variables for a house creating solar energy
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;
import "truffle/Console.sol";

contract House {

    // Declaring state variables
    uint private pvGeneration = 0;
    uint private demand = 0;
    uint private latitude = 0;
    uint private longitude = 0;
    bool private needsPV = true; // F if need solar, T if don't need solar
    bool private canSell = false;

    // Creating a constructor to set postal code of house and pv generated to 0
    constructor(uint _latitude, uint _longitude) {       
        latitude = _latitude;
        longitude = _longitude;
    } 

    // Creating an initializer for HouseFactory to set coordinates of house and pv generated to 0
    function initialize(uint _latitude, uint _longitude) external {    
        latitude = _latitude;
        longitude = _longitude;
    } 

    // Set pv generation value
    function setPVGeneration(uint _pvGeneration) public
    {
        pvGeneration = _pvGeneration;
        if (pvGeneration > demand)
        {
            canSell = true;
            needsPV = false;
        }
        else if (pvGeneration == demand)
        {
            needsPV = false;
        }
    }

    // Get pv generation value
    function getPVGeneration() public view returns (uint)
    {
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
        demand = _demand;
    }

    // Get demand value
    function getDemand() public view returns (uint)
    {
        return demand;
    }

    function needPV() public view returns (bool)
    {
        return needsPV;
    }

    function setNeedPV(bool val) public
    {
        needsPV = val;
    }

    function canWeSell() public view returns (bool)
    {
        return canSell;
    }

    function setCanSell(bool val) public
    {
        canSell = val;
    }
}