const app = require('./app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, function () {
  console.log('Patient appointment API listening on port ' + PORT);
});
