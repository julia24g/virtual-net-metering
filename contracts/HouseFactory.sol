//SPDX-License-Identifier: Unlicense
// contracts/HouseFactory.sol
/// @title
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./House.sol";
import "@optionality.io/clone-factory/contracts/CloneFactory.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract HouseFactory is Ownable, CloneFactory{

    using StructuredLinkedList for StructuredLinkedList.List;

    address public libraryAddress;
    event HouseCreated(House newHouse);
    House[] public clones;
    mapping(House => StructuredLinkedList.List list;) public myMap;

    



    // Initializing the address that deploys the HouseFactory contract
    function HouseFactory(address _libraryAddress) public {
        libraryAddress = _libraryAddress;
    }

    // If we want to change the owner of the HouseFactory contract, we can do so here
    function setLibraryAddress(address _libraryAddress) public onlyOwner {
        libraryAddress = _libraryAddress;
    }

    function createHouse(string _latitude, string _longitude) public {
        House house = House(createClone(libraryAddress)); // creates a new House object with the createClone function from House.sol
        house.initialize(_latitude, _longitude); // initializes the new house
        clones.push(house); // adds house to array of houses in the HouseFactory contract
        emit HouseCreated(clone); // emits an event for visibility purposes

    }

    function getAllHouses() external view returns (House[] memory) {
        return clones;
    }

    function makeTransfer(address houseWithSolar) public {

    }

    function addHouseToMap() internal {


    }

    function calculateDistanceBetweenHouses(House house1, House house2) internal {

    }

    function sortLinkedList() internal {

    }


}