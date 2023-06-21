//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/House.sol";

contract TestHouse {
  function testSettingAndGettingPVGeneration() public
  {
    House house = House(DeployedAddresses.House());
    uint pvGenerated = 5;
    house.setPVGeneration(pvGenerated);
    Assert.equal(house.getPVGeneration(), pvGenerated, "Owner should have 5 PV generated");
  }
  function testSettingAndGettingDemand() public
  {
      House house = House(DeployedAddresses.House());
      uint demand = 10;
      house.setDemand(demand);
      Assert.equal(house.getDemand(), demand, "Owner should have 10 demand");
  }
  function testWhenPVGeneratedGreaterThanDemand() public
  {
      House house = House(DeployedAddresses.House());
      uint demand = 10;
      uint pvGenerated = 15;
      house.setDemand(demand);
      bool expected = true;

      Assert.equal(house.setPVGeneration(pvGenerated), expected, "Output should be true");
  }
}
