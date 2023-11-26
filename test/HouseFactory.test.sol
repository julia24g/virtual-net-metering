//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/DeployedAddresses.sol";
import "../contracts/ethereum/HouseFactory.sol";
import "../contracts/ethereum/House.sol";
import "truffle/Console.sol";

contract TestHouseFactory {
  // function testCreationOfNewHouse() public
  // {
  //   HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
  //   uint latitude = 4300687485657513; 
  //   uint longitude = 8125149344797477;
  //   houseFactory.createHouse(latitude, longitude);
  // }

  // function testGettingAllHouses() public
  // {
  //   HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
  //   address[] memory allHouses = houseFactory.getAllHouses();
    
  //   for (uint i = 0; i < allHouses.length;){
  //     House a = House(allHouses[i]);
  //     // console.logUint(a.getLatitude());
  //     unchecked{ i++; }
  //   }
  // }

  function testCreateAndTransferOfMultipleHouses() public
  {
    HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
    uint latitude = 4300671665687827; 
    uint longitude = 8126146616146633;
    houseFactory.createHouse(latitude, longitude);
    latitude = 4300687485657513; 
    longitude = 8125149344797477;
    houseFactory.createHouse(latitude, longitude);

    address[] memory clones = houseFactory.getAllHouses();
    uint demand = 10;
    House(clones[0]).setDemand(demand);
    House(clones[1]).setDemand(demand);

    uint supply1 = 5;
    uint supply2 = 15;

    House(clones[0]).setPVGeneration(supply1);
    House(clones[1]).setPVGeneration(supply2);
    houseFactory.makeTransfer();
    console.log("hello");
  }
}
