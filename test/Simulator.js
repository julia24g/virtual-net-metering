const HouseFactory = artifacts.require("HouseFactory");
const House = artifacts.require("House");
const fs = require('fs')
const csv = require('fast-csv')
const { convertArrayToCSV } = require('convert-array-to-csv')

loadData = []
pvProduction = []
amountSentCSV = []
amountReceivedCSV = []

fs.createReadStream('test/../load_data/PVdemand.csv')
  .pipe(csv.parse({ headers: true }))
  .on('data', row => loadData.push(row));

fs.createReadStream('test/../load_data/PVproduction.csv')
.pipe(csv.parse({ headers: true }))
.on('data', row => pvProduction.push(row));

function randomIntFromInterval() { // from -10 to 10
  return Math.floor(Math.random() * (20 - (-20) + 1) + (-20))
}

contract("Simulation", (accounts) => {
  let house
  let houseFactoryInstance
  it("Perform year-long simulation", async () => {

    house = await House.new(parseInt(4300671665687827), parseInt(8126146616146633));
    houseFactoryInstance = await HouseFactory.new(house.address);

    await houseFactoryInstance.createHouse(parseInt(4300671665687827), parseInt(8126146616146633));
    await houseFactoryInstance.createHouse(parseInt(4300687485657513), parseInt(8125149344797477));
    await houseFactoryInstance.createHouse(parseInt(4300687485657513), parseInt(8125149344797477));
    await houseFactoryInstance.createHouse(parseInt(4300687482657513), parseInt(8125149344717477));
    await houseFactoryInstance.createHouse(parseInt(4300687485657713), parseInt(8125149354797477));
    await houseFactoryInstance.createHouse(parseInt(4300687488657513), parseInt(8125149344797277));
    await houseFactoryInstance.createHouse(parseInt(4300687483657513), parseInt(8125149344797497));
    await houseFactoryInstance.createHouse(parseInt(4300687485657563), parseInt(8125149347797477));
    await houseFactoryInstance.createHouse(parseInt(4300687481657513), parseInt(8125149344797077));
    await houseFactoryInstance.createHouse(parseInt(4300687485657013), parseInt(8125149340797477));

    houses = await houseFactoryInstance.getAllHouses()
    const rawData = fs.readFileSync('counter.json');
    const config = JSON.parse(rawData);
    const count = config.COUNT

    for (let i = count; i < count + 10; i++) {
        //populating supply and demand
        for (let j = 0; j < 2; j++){
          hourlyDemand = Math.round((randomIntFromInterval() / 100) * parseInt(loadData[i]['Total Electricity Consumption (10^7)']) + parseInt(loadData[i]['Total Electricity Consumption (10^7)']))
          hourlySupply = Math.round((randomIntFromInterval() / 100) * parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) + parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) * 2)
          h = new House(houses[j])
          await h.setDemand(hourlyDemand)
          await h.setPVGeneration(hourlySupply)
        }

        for (let j = 2; j < 4; j++){
          hourlyDemand = Math.round((randomIntFromInterval() / 100) * parseInt(loadData[i]['Total Electricity Consumption (10^7)']) + parseInt(loadData[i]['Total Electricity Consumption (10^7)']))
          hourlySupply = Math.round((randomIntFromInterval() / 100) * parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) + parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']))
          h = new House(houses[j])
          await h.setDemand(hourlyDemand)
          await h.setPVGeneration(hourlySupply)
        }

        for (let j = 4; j < 6; j++){
          hourlyDemand = Math.round((randomIntFromInterval() / 100) * parseInt(loadData[i]['Total Electricity Consumption (10^7)']) + parseInt(loadData[i]['Total Electricity Consumption (10^7)']))
          hourlySupply = Math.round((randomIntFromInterval() / 100) * parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) + parseInt(pvProduction[i]['Lifetime Hourly Data: System power generated (kW)(10000000)']) / 2)
          h = new House(houses[j])
          await h.setDemand(hourlyDemand)
          await h.setPVGeneration(hourlySupply)
        }

        for (let j = 6; j < 10; j++){
          hourlyDemand = Math.round((randomIntFromInterval() / 100) * parseInt(loadData[i]['Total Electricity Consumption (10^7)']) + parseInt(loadData[i]['Total Electricity Consumption (10^7)']))
          h = new House(houses[j])
          await h.setDemand(hourlyDemand)
          await h.setPVGeneration(0);
        }

        await houseFactoryInstance.makeTransfer();

        currentAmountSentRow = [i]
        currentAmountReceivedRow = [i]

        for (let k = 0; k < 10; k++){
          h = new House(houses[k]);
          amountSent = await h.getAmountSent();
          amountReceived = await h.getAmountReceived();
          currentAmountSentRow.push(parseInt(amountSent.toString()))
          currentAmountReceivedRow.push(parseInt(amountReceived.toString()))
          await h.resetAmountSentAndAmountReceived();
        }

        amountSentCSV.push(currentAmountSentRow)
        amountReceivedCSV.push(currentAmountReceivedRow)

      }
      const data = JSON.stringify({ COUNT: count + 50 });
      fs.writeFileSync('counter.json', data);

      csvHeader = ["Hour since Jan 1", "House 1", "House 2", "House 3", "House 4", "House 5", "House 6", "House 7", "House 8", "House 9", "House 10"]

      csvSentDataArrays = convertArrayToCSV(amountSentCSV, {
        csvHeader,
        separator: ','
      })
      csvReceivedDataArrays = convertArrayToCSV(amountReceivedCSV, {
        csvHeader,
        separator: ','
      })

      // Append data to the existing CSV file
      fs.appendFile("receivedOutput.csv", csvReceivedDataArrays, (err) => {
        if (err) {
            console.error('Error appending to the file:', err);
        } else {
            console.log('Data appended to the received file successfully.');
        }
      });
      fs.appendFile("sentOutput.csv", csvSentDataArrays, (err) => {
        if (err) {
            console.error('Error appending to the file:', err);
        } else {
            console.log('Data appended to the sent file successfully.');
        }
      });

  });

});