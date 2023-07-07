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
      console.logUint(a.getLatitude());
    }
  }

  function testCalculatingDistanceBetweenCoordinates() public
  {
    HouseFactory houseFactory = HouseFactory(DeployedAddresses.HouseFactory());
    Assert.equal(houseFactory.calculateDistanceBetweenHouses(4382158637879012, 4381664455946044, 7939797813498498, 7938858901723961), 1061023611064, "Distance should be 1061023611064");
  }

}
