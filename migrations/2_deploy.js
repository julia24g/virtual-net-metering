// migrations/2_deploy.js
const House = artifacts.require("House");
const HouseFactory = artifacts.require("HouseFactory");

module.exports = async function (deployer) {
  
  var latitude = 43;
  var longitude = 79;
  await deployer.deploy(House, latitude, longitude).then(() => console.log(House.address));
  const instance1 = await House.deployed();

  await deployer.deploy(HouseFactory, House.address).then(() => console.log(HouseFactory.address));
  const instance2 = await HouseFactory.deployed();
};