// migrations/2_deploy.js
const Solar = artifacts.require("Solar");
const House = artifacts.require("House");
const HouseFactory = artifacts.require("HouseFactory");

module.exports = async function (deployer) {
  var amount = 27;
  var owner = "0x7c728214be9a0049e6a86f2137ec61030d0aa964";
  await deployer.deploy(Solar, amount, owner).then(() => console.log(Solar.address));
  const instance = await Solar.deployed();
  
  var latitude = 43;
  var longitude = 79;
  var libraryAddress = "0x5f8e26facc23fa4cbd87b8d9dbbd33d5047abde1";
  await deployer.deploy(House, latitude, longitude, libraryAddress).then(() => console.log(House.address));
  const instance2 = await House.deployed();

  var libraryAddress = "0x5f8e26facc23fa4cbd87b8d9dbbd33d5047abde1";
  await deployer.deploy(HouseFactory, libraryAddress).then(() => console.log(HouseFactory.address));
  const instance3 = await HouseFactory.deployed();
};