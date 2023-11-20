// migrations/2_deploy.js

const { default: DepositManager } = require("@maticnetwork/maticjs/lib/root/DepositManager");
// const { artifacts } = require("hardhat");

// const Solar = artifacts.require("Solar");
const House = artifacts.require("House");
const HouseFactory = artifacts.require("HouseFactory");

module.exports = async function (deployer) {
  
  var latitude = 43;
  var longitude = 79;
  await deployer.deploy(House, latitude, longitude).then(() => console.log(House.address));
  const instance1 = await House.deployed();

  var libraryAddress = "0x5f8e26facc23fa4cbd87b8d9dbbd33d5047abde1";
  await deployer.deploy(HouseFactory, libraryAddress).then(() => console.log(HouseFactory.address));
  const instance2 = await HouseFactory.deployed();
};