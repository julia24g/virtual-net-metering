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
    address[] public clones; // this array is in storage
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
    }

    function getAllHouses() external view returns (address[] memory) {
        return clones;
    }

    function printClosestHousesForEachHouse() external view {
        console.log("Printing from hashmap: ");
        for (uint r = 0; r < clones.length;){
            console.log("House: ", clones[r]);
            address[] memory houses = closestHouses[clones[r]];

            for (uint s = 0; s < houses.length;){
                console.log("Next closest house: ", houses[s]);
                unchecked{ s++; }
            }
            unchecked{ r++; }
        }
    }

    function makeTransfer(address houseWithSolar) public {
        address houseThatNeedsPV = findHouseThatNeedsPV(houseWithSolar);

        uint amount;
        uint diffHouseThatNeedsPV = House(houseThatNeedsPV).getDemand() - House(houseThatNeedsPV).getPVGeneration();
        uint diffHouseWithSolar = House(houseWithSolar).getPVGeneration() - House(houseWithSolar).getDemand();
        if (diffHouseThatNeedsPV < diffHouseWithSolar){
            amount = diffHouseThatNeedsPV;
        }
        else {
            amount = diffHouseWithSolar;
        }

        House(houseWithSolar).getSolarToken().transfer(houseThatNeedsPV, amount); // need to work on amount
        // reset PV generated for each house
        House(houseWithSolar).subtractFromPVGeneration(amount);
        House(houseThatNeedsPV).subtractFromPVGeneration(amount);
    }

    function findHouseThatNeedsPV(address houseWithSolar) internal view returns (address houseNeedsPV) {
        address[] memory houseArray = closestHouses[houseWithSolar];
        for (uint p = 0; p < houseArray.length;){
            if (House(houseArray[p]).booleanNeedPV() == true){
                houseNeedsPV = houseArray[p];
                return houseNeedsPV;
            }
            unchecked{ p++; }
        }
    }

    function addHouseToMap(address houseAddress) internal {
        // add house with empty array to mapping
        address[] memory emptyArray = new address[](clones.length - 1);
        closestHouses[houseAddress] = emptyArray;

        // for each house, we need to make an array of houses
        for (uint i = 0; i < clones.length;){
            // we need to remove the current house from the array
            address[] memory houseArray = createHouseArrayMinusCurrentHouse(clones[i]);
            // need to sort array based on distance from house we are selecting to the rest of the houses
            address[] memory sortedArray = insertionSort(houseArray, clones[i]);
            closestHouses[clones[i]] = sortedArray; // add new sorted array to hashmap for particular house address
            unchecked{ i++; }
        }
    }

    function insertionSort(address[] memory houseArray, address curHouse) internal view returns (address[] memory){
        uint size = houseArray.length;
        for (uint g = 1; g < size;){
            address key = houseArray[g];
            int h;
            unchecked{ h = int(g - 1); }
            
            uint distanceFromKeyToHouse = calculateDistanceBetweenHouses(House(key).getLatitude(), House(curHouse).getLatitude(), House(key).getLongitude(), House(curHouse).getLongitude());
            while (h >= 0 && distanceFromKeyToHouse < calculateDistanceBetweenHouses(House(houseArray[uint(h)]).getLatitude(), House(curHouse).getLatitude(), House(houseArray[uint(h)]).getLongitude(), House(curHouse).getLongitude())){
                houseArray[uint(h + 1)] = houseArray[uint(h)];
                unchecked{ h = h - 1; }
            }
            houseArray[uint(h + 1)] = key;
            unchecked{ g++; }
        }
        return houseArray;
    }

    function createHouseArrayMinusCurrentHouse(address houseAddress) internal view returns (address[] memory houseArray){
        houseArray = new address[](clones.length - 1);
        uint counter = 0;
        for (uint a = 0; a < clones.length;){
            if (clones[a] != houseAddress){
                houseArray[counter] = clones[a];
                unchecked{ counter++; }
            }
            unchecked{ a++; }
        }
        return houseArray;
    }

    function calculateDistanceBetweenHouses(uint latitude1, uint latitude2, uint longitude1, uint longitude2) internal pure returns (uint){
        int x = int(latitude1) - int(latitude2);
        int y = int(longitude1) - int(longitude2);
        uint xPlusYSquared = uint((x*x) + (y*y));
        return sqrt(xPlusYSquared);
    }

    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x;
            unchecked{ x = (y / 2) + 1; }
            while (x < z) {
                z = x;
                unchecked{ x = ((y / x) + x) / 2; }
            }
        } 
        else if (y != 0) {
            z = 1;
        }
    }
}