//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/polygon/HouseFactory.sol";
import "../contracts/polygon/House.sol";

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
    uint startGas = gasleft();
    uint latitude = 4300671665687827; 
    uint longitude = 8126146616146633;
    houseFactory.createHouse(latitude, longitude);
    latitude = 4300687485657513; 
    longitude = 8125149344797477;
    houseFactory.createHouse(latitude, longitude);
    // latitude = 4300687485657518; 
    // longitude = 8125149342797477;
    // houseFactory.createHouse(latitude, longitude);
    // latitude = 4300487485957513; 
    // longitude = 8125349344797377;
    // houseFactory.createHouse(latitude, longitude);
    // latitude = 4200687485057513; 
    // longitude = 8125149344797477;
    // houseFactory.createHouse(latitude, longitude);
    // longitude = 8125169342797477;
    // houseFactory.createHouse(latitude, longitude);
    // latitude = 4300687485957513; 
    // longitude = 8425349344797477;
    // houseFactory.createHouse(latitude, longitude);
    // latitude = 4300687485057512; 
    // longitude = 8125149344997477;
    // houseFactory.createHouse(latitude, longitude);
    // latitude = 4300680485957513; 
    // longitude = 8125349344797477;
    // houseFactory.createHouse(latitude, longitude);
    // latitude = 4300687485057513; 
    // longitude = 8125649344797477;
    // houseFactory.createHouse(latitude, longitude);
    address[] memory clones = houseFactory.getAllHouses();
    uint demand = 10;
    House(clones[0]).setDemand(demand);
    House(clones[1]).setDemand(demand);

    uint supply1 = 5;
    uint supply2 = 15;
    House(clones[0]).setPVGeneration(supply1);
    House(clones[1]).setPVGeneration(supply2);

    houseFactory.makeTransfer();
  }
}
