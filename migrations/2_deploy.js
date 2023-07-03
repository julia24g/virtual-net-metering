// migrations/2_deploy.js
const Solar = artifacts.require("Solar");
const House = artifacts.require("House");

module.exports = async function (deployer) {
  var amount = 27;
  var owner = "0x7c728214be9a0049e6a86f2137ec61030d0aa964";
  await deployer.deploy(Solar, amount, owner).then(() => console.log(Solar.address));
  const instance = await Solar.deployed();
  

  var postalCode = "L3T2Z1";
  await deployer.deploy(House, postalCode).then(() => console.log(House.address));
  const instance2 = await House.deployed();
};