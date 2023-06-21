const { accounts, contract } = require('@openzeppelin/test-environment');
const [ owner ] = accounts; // an array with the addresses of all unlocked accounts in the local blockchain

const { expect } = require('chai');

const Solar = contract.fromArtifact('Solar'); // Loads the compiled Solar contract

// Test cases are declared with the it function and grouped in describe blocks
describe('MyContract', function () {

    it('deployer is owner', async function () {
      const solarContract = await Solar.new({ from: owner });
      expect(await solarContract.owner()).to.equal(owner);
    });
  });

