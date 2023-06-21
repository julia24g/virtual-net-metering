//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/House.sol";

contract TestHouse {
    function testPVGeneration() public{
        House house = House(DeployedAddresses.House());
        uint pvGenerated = 5;
        house.setPVGeneration(pvGenerated);
        Assert.equal(house.getPVGeneration(), pvGenerated, "Owner should have 5 PV generated");
  }
}
