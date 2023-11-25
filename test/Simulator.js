// const { calcTouRate } = require('../calculation');
const HouseFactory = artifacts.require("HouseFactory");
const House = artifacts.require("House");
const fs = require('fs')

const csv = require('fast-csv')
const ObjectsToCsv = require('objects-to-csv');
const { convertArrayToCSV } = require('convert-array-to-csv')

const loadData = []
const pvProduction = []
const amountSentCSV = []
const amountReceivedCSV = []
const csvHeader = ["Hour since Jan 1", "House 1", "House 2", "House 3", "House 4", "House 5", "House 6", "House 7", "House 8", "House 9", "House 10"]


fs.createReadStream('test/../load_data/PVdemand.csv')
  .pipe(csv.parse({ headers: true }))
  .on('error', error => console.error(error))
  .on('data', row => loadData.push(row));

fs.createReadStream('test/../load_data/PVproduction.csv')
.pipe(csv.parse({ headers: true }))
.on('error', error => console.error(error))
.on('data', row => pvProduction.push(row));

function randomIntFromInterval() { // from -10 to 10
  return Math.floor(Math.random() * (20 - (-20) + 1) + (-20))
}

contract("Simulation", (accounts) => {
  let house
  let houseFactoryInstance
  it("Perform year-long simulation", async () => {
    // Run the Python file
    // const Cbuy = calcTouRate();
    // const houseFactoryInstance = await HouseFactory.deployed();
    // const house = await House.deployed();

    house = await House.new(parseInt(4300671665687827), parseInt(8126146616146633));
    houseFactoryInstance = await HouseFactory.new(house.address);

    await houseFactoryInstance.createHouse(parseInt(4300671665687827), parseInt(8126146616146633));
    await houseFactoryInstance.createHouse(parseInt(4300687485657513), parseInt(8125149344797477));
    await houseFactoryInstance.createHouse(parseInt(4300687485657513), parseInt(8125149344797477));

    const houses = []
    const clones = await houseFactoryInstance.getAllHouses()
    for (let i = 0; i < clones.length; i++){
      houses.push(new House(clones[i]))
    }

    for (let i = 4000; i < 4200; i++) {
        //populating supply and demand
        for (let j = 0; j < clones.length; j++){
          hourlyDemand = Math.round((randomIntFromInterval() / 100) * parseInt(loadData[i]['Total Electricity Consumption (10^7)']) + parseInt(loadData[i]['Total Electricity Consumption (10^7)']))
          hourlySupply = Math.round((randomIntFromInterval() / 100) * parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) + parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']))
          await houses[j].setDemand(hourlyDemand)
          await houses[j].setPVGeneration(hourlySupply)
          const demand = await houses[j].getDemand()
          const supply = await houses[j].getPVGeneration()
          console.log(parseInt(demand.toString()))
          console.log(parseInt(supply.toString()))
        }

        await houseFactoryInstance.makeTransfer();

        const currentAmountSentRow = [i]
        const currentAmountReceivedRow = [i]

        for (let i = 0; i < clones.length; i++){
          const amountSent = await houses[i].getAmountSet();
          const amountReceived = await houses[i].getAmountReceived();
          currentAmountSentRow.push(parseInt(amountSent.toString()))
          currentAmountReceivedRow.push(parseInt(amountReceived.toString()))
        }

        amountSentCSV.push(currentAmountSentRow)
        amountReceivedCSV.push(currentAmountReceivedRow)
        
      }

      const csvSentDataArrays = convertArrayToCSV(amountSentCSV, {
        csvHeader,
        separator: ','
      })

      const csvReceivedDataArrays = convertArrayToCSV(amountReceivedCSV, {
        csvHeader,
        separator: ','
      })

      fs.writeFile('sentOutput.csv', csvSentDataArrays, err => {
        if (err){
          console.log(18, err);
        }
        console.log("sent CSV file saved successfully!");
      })

      fs.writeFile('receivedOutput.csv', csvReceivedDataArrays, err => {
        if (err){
          console.log(18, err);
        }
        console.log("received CSV file saved successfully!");
      })

  });

});