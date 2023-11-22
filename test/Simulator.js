// const { calcTouRate } = require('../calculation');
const HouseFactory = artifacts.require("HouseFactory");
const House = artifacts.require("House");
const fs = require('fs')

const csv = require('fast-csv')
const ObjectsToCsv = require('objects-to-csv');

const loadData = []
const pvProduction = []
const csvRows = []

fs.createReadStream('test/../load_data/USA_NY_New.York-Central.Park.725033_TMY3_BASE.csv')
  .pipe(csv.parse({ headers: true }))
  .on('error', error => console.error(error))
  .on('data', row => loadData.push(row));

fs.createReadStream('test/../load_data/PVproduction.csv')
.pipe(csv.parse({ headers: true }))
.on('error', error => console.error(error))
.on('data', row => pvProduction.push(row));

// const addCSV = function (data) {
//     const values = Object.values(data).join(',');
//     csvRows.push(values)
// }

function randomIntFromInterval() { // from -10 to 10
  return Math.floor(Math.random() * (10 - (-10) + 1) + (-10))
}

contract("Simulation", (accounts) => {
  it("Perform year-long simulation", async () => {
    // Run the Python file
    // const Cbuy = calcTouRate();

    const houseFactoryInstance = await HouseFactory.deployed();
    await houseFactoryInstance.createHouse(4300671665687827, 8126146616146633);
    await houseFactoryInstance.createHouse(4300687485657513, 8125149344797477);
    await houseFactoryInstance.createHouse(4300687485657518, 8125349344797477);

    const houses = []
    const clones = await houseFactoryInstance.getAllHouses()
    for (let i = 0; i < clones.length; i++){
      houses.push(new House(clones[i]))
    }

    for (let i = 0; i < 10; i++) {
        //populating supply and demand
        // await houses[0].setDemand(5)
        // await houses[0].setPVGeneration(10)
        // await houses[1].setDemand(10)
        // await houses[1].setPVGeneration(2)
        // await houses[2].setDemand(5)
        // await houses[2].setPVGeneration(7)

        for (let j = 0; j < clones.length; j++){
          hourlyDemand = Math.round((randomIntFromInterval() / 100) * parseInt(loadData[i]['General:InteriorLights:Electricity [kW](Hourly)']) + parseInt(loadData[i]['General:InteriorLights:Electricity [kW](Hourly)']))
          hourlySupply = Math.round((randomIntFromInterval() / 100) * parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) + parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']))
          // console.log("demand random", demandRandom)
          // console.log("supply random", supplyRandom)
          await houses[j].setDemand(hourlyDemand)
          await houses[j].setPVGeneration(hourlySupply)
        }
        await houseFactoryInstance.makeTransfer();

      }

  });

});