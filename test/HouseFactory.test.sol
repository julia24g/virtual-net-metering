//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HouseFactory.sol";
import "hardhat/console.sol";

contract TestHouseFactory {
  function testCreationOfNewHouse() public
  {
    HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
    uint latitude = 43234234234; 
    uint longitude = 79984758743;
    houseFactory.createHouse(latitude, longitude);
  }

  function testGettingAllHouses() public
  {
    HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
    address[] memory allHouses = houseFactory.getAllHouses();
    
    for (uint i = 0; i < allHouses.length; i++){
      House a = House(allHouses[i]);
      a.setDemand(20);
    }
  }

}
