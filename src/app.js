const express = require('express');
const routes = require('./routes');

const app = express();

app.use(express.json());

app.get('/health', function (req, res) {
  res.json({ status: 'ok' });
});

app.use('/api', routes);

app.use(function (req, res) {
  res.status(404).json({ error: 'Not found' });
});

app.use(function (err, req, res, next) {
  console.error(err);

  const statusCode = Number.isInteger(err.statusCode) ? err.statusCode : 500;
  const message = statusCode === 500 ? 'Unexpected server error' : err.message;

  res.status(statusCode).json({ error: message });
});

module.exports = app;
