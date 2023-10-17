//const Solar = artifacts.require("HouseFactory");
const fs = require('fs')
const csv = require('fast-csv')
const ObjectsToCsv = require('objects-to-csv');

const data = []
const csvRows = []
 
fs.createReadStream('load_data/niagara_falls.csv')
  .pipe(csv.parse({ headers: true }))
  .on('error', error => console.error(error))
  .on('data', row => data.push(row))
  .on('end', () => console.log(data));

data.forEach(myFunction);

const addCSV = function (data) {
    const values = Object.values(data).join(',');
    csvRows.push(values)
}

function myFunction() {

    /**
     * 
     * INSERT STUFF HERE FOR PROCESSING
     */

    // the data structure being pushed to the CSV file
    const data = {
        'Date/Time' : time,
        'Total [kW](Hourly)' : kW
    }

    addCSV(data);
  }

(async () => {
    const csv = new ObjectsToCsv(csvRows);

    // Save to file:
    await csv.toDisk('./test.csv');

    // Return the CSV file as string:
    console.log(await csv.toString());

})();