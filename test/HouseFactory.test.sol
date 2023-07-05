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
    int latitude = 43;
    int longitude = -78;
    houseFactory.createHouse(latitude, longitude);
  }

  function testGettingAllHouses() public
  {
    HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
    address[] memory allHouses = houseFactory.getAllHouses();
    
    for (uint i = 0; i < allHouses.length; i++){
      House a = House(allHouses[i]);
      a.setDemand(20);
      uint demand = a.getDemand();
    }
  }

}
