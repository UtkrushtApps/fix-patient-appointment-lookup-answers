const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.PGHOST || 'db',
  port: Number(process.env.PGPORT || 5432),
  database: process.env.PGDATABASE || 'healthcare',
  user: process.env.PGUSER || 'app_user',
  password: process.env.PGPASSWORD || 'app_password'
});

function query(text, params, callback) {
  if (typeof params === 'function') {
    return pool.query(text, params);
  }

  return pool.query(text, params, callback);
}

module.exports = {
  query: query,
  pool: pool
};
