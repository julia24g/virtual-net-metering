//SPDX-License-Identifier: Unlicense
// contracts/HouseFactory.sol
/// @title
/// @author Julia Groza
/// @notice 

pragma solidity ^0.8.0;

import "./House.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HouseFactory is Ownable {

    address public libraryAddress;
    address[] public clones; // this array is in storage
    mapping(address => address[]) public closestHouses;
    // uint constant private costOfTransfer = 0;

    // Initializing the address that deploys the HouseFactory contract
    constructor(address _libraryAddress) {
        libraryAddress = _libraryAddress;
    }

    function createHouse(uint _latitude, uint _longitude) public {
        address house = Clones.clone(libraryAddress); // creates a new House object with the createClone function from CloneFactory.sol - not cloning the right thing?
        House newHouse = House(house);
        newHouse.initialize(_latitude, _longitude);
        clones.push(house); // adds house to array of houses in the HouseFactory contract
        addHouseToMap(house);
    }

    function getAllHouses() external view returns (address[] memory) {
        return clones;
    }

    // function printClosestHousesForEachHouse() external view {
    //     console.log("Printing from hashmap: ");
    //     for (uint r = 0; r < clones.length;){
    //         console.log("House: ", clones[r]);
    //         address[] memory houses = closestHouses[clones[r]];

    //         for (uint s = 0; s < houses.length;){
    //             console.log("Next closest house: ", houses[s]);
    //             unchecked{ s++; }
    //         }
    //         unchecked{ r++; }
    //     }
    // }

    // this function will need to be called at every hour
    function makeTransfer() external {
        // iterate through all houses in clones
        if (clones.length > 1){
            for (uint r = 0; r < clones.length;){
                House currentHouse = House(clones[r]);
                if (currentHouse.getPVGeneration() < currentHouse.getDemand()){
                    unchecked { r++; }
                    continue;
                }

                uint pv = currentHouse.getPVGeneration();
                uint demand = currentHouse.getDemand();
                uint amountAvailable;
                unchecked {amountAvailable = uint(pv - demand);}

                if (amountAvailable == 0) {
                    unchecked { r++; }
                    continue;
                }

                // go through map to see next house that needs it
                address requestee = findHouseThatNeedsPV(clones[r]);

                // need to make sure address exists, else there are no houses to exchange with
                if (requestee == address(0)){
                    break;
                }

                uint transferAmount;
                uint amountRequested;
                unchecked { amountRequested = uint(House(requestee).getDemand() - House(requestee).getPVGeneration()); }

                if (amountAvailable > amountRequested){
                    transferAmount = amountRequested;
                }
                else{
                    transferAmount = amountAvailable;
                }

                // capture amount sent
                currentHouse.setAmountSent(transferAmount);
                House(requestee).setAmountReceived(transferAmount);

                currentHouse.subtractFromPVGeneration(transferAmount);
                House(requestee).addToPVGeneration(transferAmount);
                unchecked { r++; }
            }

        }
        setAllSentAndReceivedToZero();
    }

    function findHouseThatNeedsPV(address houseWithSolar) internal view returns (address houseNeedsPV) {
        address[] memory houseArray = closestHouses[houseWithSolar];
        for (uint p = 0; p < houseArray.length;){
            if (House(houseArray[p]).getPVGeneration() < House(houseArray[p]).getDemand()){
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
        if (clones.length > 1){
            for (uint i = 0; i < clones.length;){
                // we need to remove the current house from the array
                address[] memory houseArray = createHouseArrayMinusCurrentHouse(clones[i]);
                // need to sort array based on distance from house we are selecting to the rest of the houses
                House curHouse = House(clones[i]);
                uint lat = curHouse.getLatitude();
                uint long = curHouse.getLongitude();
                address[] memory sortedArray = insertionSort(houseArray, lat, long);
                closestHouses[clones[i]] = sortedArray; // add new sorted array to hashmap for particular house address
                unchecked{ i++; }
            }
        }

    }

    function insertionSort(address[] memory houseArray, uint curHouseLat, uint curHouseLong) internal view returns (address[] memory){
        uint size = houseArray.length;
        for (uint g = 1; g < size;){
            address key = houseArray[g];
            int h;
            unchecked{ h = int(g - 1); }

            uint keyLatitude = House(key).getLatitude();
            uint keyLongitude = House(key).getLongitude();
            
            uint distanceFromKeyToHouse = calculateDistanceBetweenHouses(keyLatitude, curHouseLat, keyLongitude, curHouseLong);
            while (h >= 0 && distanceFromKeyToHouse < calculateDistanceBetweenHouses(House(houseArray[uint(h)]).getLatitude(), curHouseLat, House(houseArray[uint(h)]).getLongitude(), curHouseLong)){
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

    function setAllSentAndReceivedToZero() internal {
        for (uint i = 0; i < clones.length;){
            House(clones[i]).resetAmountSentAndAmountReceived();
            unchecked {
                i++;
            }
        }
    }
}