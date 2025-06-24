const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.PG_HOST,
  user: process.env.PG_USER,
  password: process.env.PG_PASS,
  database: process.env.PG_DB,
  port: 5432, // default PostgreSQL
});

pool.connect((err) => {
  if (err) {
    console.error('❌ PostgreSQL connection error:', err.stack);
  } else {
    console.log('✅ Connected to PostgreSQL');
  }
});

module.exports = pool;
