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
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HouseFactory is Ownable{

    address public libraryAddress;
    event HouseCreated(address newHouse);
    address[] public clones;
    mapping(address => address[]) public closestHouses;

    // Initializing the address that deploys the HouseFactory contract
    constructor(address _libraryAddress) {
        libraryAddress = _libraryAddress;
    }

    function createHouse(uint _latitude, uint _longitude) external {
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

    function addHouseToMap(address houseAddress) internal {
        // add house with empty array to mapping
        address[] memory emptyArray;
        closestHouses[houseAddress] = emptyArray;

        // for each house, we need to make an array of houses
        for (uint i = 0; i < clones.length; i++){
            address[] memory houseArray;

            closestHouses[clones[i]] = houseArray;
        }

    }

    function calculateDistanceBetweenHouses(uint latitude1, uint latitude2, uint longitude1, uint longitude2) internal pure returns (uint){
        uint x = SafeMath.sub(latitude1, latitude2);
        uint y = SafeMath.sub(longitude1, longitude2);
        uint xPlusYSquared = SafeMath.add(SafeMath.mul(x, x), SafeMath.mul(y, y));
        return sqrt(xPlusYSquared);
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } 
        else if (y != 0) {
            z = 1;
        }
    }
}