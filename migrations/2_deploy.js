// migrations/2_deploy.js
const Solar = artifacts.require('Solar');

module.exports = async function (deployer) {
  await deployer.deploy(Solar);
  const instance = await Solar.deployed();
};