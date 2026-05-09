const fs = require('fs');
const path = require('path');
const mysql = require('mysql2');

const csvPath = path.resolve(__dirname, 'dataset', 'cleaned', 'superstore_cleaned.csv');
const normalizedCsvPath = csvPath.replace(/\\/g, '/');

if (!fs.existsSync(csvPath)) {
  console.error('CSV file not found:', csvPath);
  process.exit(1);
}

const connection = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'sales_dashboard',
  localInfile: true,
  streamFactory: (filePath) => fs.createReadStream(filePath),
});

const importSql = `LOAD DATA LOCAL INFILE ?
INTO TABLE superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\\n'
IGNORE 1 ROWS`;

connection.connect((connectErr) => {
  if (connectErr) {
    console.error('MySQL connection failed:', connectErr.message);
    process.exit(1);
  }

  connection.query(importSql, [normalizedCsvPath], (queryErr, results) => {
    connection.end();

    if (queryErr) {
      console.error('CSV import failed:', queryErr.message);
      process.exit(1);
    }

    console.log('CSV import completed successfully. Rows affected:', results.affectedRows);
  });
});
