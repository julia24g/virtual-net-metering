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
        addHouseToMap(house);
        console.log("New house added to hash map");
    }

    function getAllHouses() external view returns (address[] memory) {
        return clones;
    }

    function makeTransfer(address houseWithSolar) public {
    
    }

    function addHouseToMap(address houseAddress) public {
        // add house with empty array to mapping
        address[] memory emptyArray;
        closestHouses[houseAddress] = emptyArray;

        // for each house, we need to make an array of houses
        for (uint i = 0; i < clones.length; i++){
            // we need to remove the current house from the array
            address[] memory houseArray = createHouseArrayMinusCurrentHouse(clones[i], clones.length);
            // need to sort array based on distance from house we are selecting to the rest of the houses
            address[] memory sortedArray = insertionSort(houseArray, clones[i]);
            closestHouses[clones[i]] = sortedArray; // add new sorted array to hashmap for particular house address
        }
    }

    function insertionSort(address[] memory houseArray, address curHouse) public view returns (address[] memory){
        uint size = houseArray.length;
        for (uint i = 1; i < size; i++){
            address key = houseArray[i];
            uint j = i - 1;

            uint distanceFromKeyToHouse = calculateDistanceBetweenHouses(House(key).getLatitude(), House(curHouse).getLatitude(), House(key).getLongitude(), House(curHouse).getLongitude());
            while (j >= 0 && distanceFromKeyToHouse < calculateDistanceBetweenHouses(House(houseArray[j]).getLatitude(), House(curHouse).getLatitude(), House(houseArray[j]).getLongitude(), House(curHouse).getLongitude())){
                houseArray[j + 1] = houseArray[j];
                --j;
            }
            houseArray[j + 1] = key;
        }
        return houseArray;
    }

    function createHouseArrayMinusCurrentHouse(address houseAddress, uint clonesSize) public view returns (address[] memory){
        address[] memory houseArray = new address[](clonesSize - 1);
        uint counter = 0;
        for (uint i = 0; i < clonesSize; i++){
            if (clones[i] != houseAddress){
                houseArray[counter] = clones[i];
            }
            counter++;
        }
        return houseArray;
    }

    function calculateDistanceBetweenHouses(uint latitude1, uint latitude2, uint longitude1, uint longitude2) public pure returns (uint){
        uint x = SafeMath.sub(latitude1, latitude2);
        uint y = SafeMath.sub(longitude1, longitude2);
        uint xPlusYSquared = SafeMath.add(SafeMath.mul(x, x), SafeMath.mul(y, y));
        return sqrt(xPlusYSquared);
    }

    function sqrt(uint y) public pure returns (uint z) {
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