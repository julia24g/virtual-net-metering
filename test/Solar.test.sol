//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Solar.sol";

contract TestSolarToken {
    function testInitialBalanceUsingDeployedContract() public {
        Solar slr = Solar(DeployedAddresses.Solar());

        uint expected = 27;

        Assert.equal(slr.balanceOf(tx.origin), expected, "Owner should have 27 Solar initially");
  }
}
