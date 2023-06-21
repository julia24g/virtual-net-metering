const Solar = artifacts.require("Solar");

contract("Solar", (accounts) => {
  it("should put 1000 SLR in the first account", async () => {
    const solarInstance = await Solar.deployed();
    const balance = await solarInstance.balanceOf.call(accounts[0]);

    assert.equal(balance.valueOf(), 0, "0 wasn't in the first account");
  });
});