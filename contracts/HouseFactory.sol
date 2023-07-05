//SPDX-License-Identifier: Unlicense
// contracts/HouseFactory.sol
/// @title
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./House.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract HouseFactory is Ownable{

    address public libraryAddress;
    event HouseCreated(address newHouse);
    address[] public clones;

    // Initializing the address that deploys the HouseFactory contract
    constructor(address _libraryAddress) public {
        libraryAddress = _libraryAddress;
    }

    function createHouse(int _latitude, int _longitude) external {
        address house = Clones.clone(libraryAddress); // creates a new House object with the createClone function from CloneFactory.sol
        House newHouse = House(house);
        newHouse.initialize(_latitude, _longitude);
        clones.push(house); // adds house to array of houses in the HouseFactory contract
        emit HouseCreated(house); // emits an event for visibility purposes
        console.log("House created with address: ", house);
    }

    function getAllHouses() external view returns (address[] memory) {
        return clones;
    }

    function makeTransfer(address houseWithSolar) public {

    }

    function addHouseToMap() internal {


    }

    function calculateDistanceBetweenHouses(House house1, House house2) internal {

    }
}