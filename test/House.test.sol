//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/polygon/House.sol";

contract TestHouse {
  // function testSettingAndGettingPVGeneration() public returns (uint)
  // {
  //   House house = House(DeployedAddresses.House());
  //   uint pvGenerated = 5;
  //   house.setPVGeneration(pvGenerated);
  //   // Assert.equal(house.getPVGeneration(), pvGenerated, "Owner should have 5 PV generated");
  //   return 0;
  // }
  // function testSettingAndGettingDemand() public returns (uint)
  // {
  //     House house = House(DeployedAddresses.House());
  //     uint demand = 10;
  //     house.setDemand(demand);
  //     // Assert.equal(house.getDemand(), demand, "Owner should have 10 demand");
  //     return 0;
  // }
  // function testWhenPVGeneratedGreaterThanDemand() public returns (uint)
  // {
  //     uint startGas = gasleft();
  //     House house = House(DeployedAddresses.House());
  //     uint demand = 10;
  //     uint pvGenerated = 15;
  //     house.setDemand(demand);
  //     house.setPVGeneration(pvGenerated);
  //     house.getDemand();
  //     house.subtractFromPVGeneration(5);
  //     house.addToPVGeneration(10);

  //     // Assert.equal(house.getSolarTokenBalance(), pvGenerated - demand, "Owner should have 5 solar tokens");
  //     // console.log("Gas used for testWhenPVGeneratedGreaterThanDemand(): %o", startGas - gasleft());
  //     return 0;
  // }

  // function testGettingLatitudeAndLongitude() public returns (uint)
  // {
  //   House house = House(DeployedAddresses.House());
  //   uint latitude = 43; 
  //   uint longitude = 79;

  //   // Assert.equal(house.getLatitude(), latitude, "House should have latitude of 43");
  //   // Assert.equal(house.getLongitude(), longitude, "House should have latitude of 79");
  //   return 0;
  // }
}
