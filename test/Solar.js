const Solar = artifacts.require("Solar");

contract("Solar", (accounts) => {
  it("Initialize account with 27 Solar Tokens", async () => {
    const solarInstance = await Solar.deployed();
    const balance = await solarInstance.balanceOf.call("0x7c728214be9a0049e6a86f2137ec61030d0aa964");
    assert.equal(balance.valueOf(), 27, "27 wasn't in the first account");
  });
});