// migrations/2_deploy.js
const Solar = artifacts.require("Solar");
const House = artifacts.require("House");

module.exports = async function (deployer) {
  await deployer.deploy(Solar);
  const instance = await Solar.deployed();

  var postalCode = "L3T2Z1";
  await deployer.deploy(House, postalCode);
  const instance2 = await House.deployed();
};