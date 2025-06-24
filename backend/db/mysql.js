// db/mysql.js
const mysql = require("mysql2");
const dotenv = require("dotenv");
dotenv.config();

const db = mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASS,
  database: process.env.MYSQL_DB,
});

db.connect((err) => {
  if (err) throw err;
  console.log("✅ Connected to MySQL");
});

module.exports = db;
