const { artifacts } = require("hardhat");

// migrations/2_deploy.js
const Solar = artifacts.require('Solar');
const House = artifacts.require('House');

module.exports = async function (deployer) {
  await deployer.deploy(Solar);
  const instance = await Solar.deployed();

  await deployer.deploy(House);
  const instance2 = await Solar.deployed();
};