const express = require('express');
const appointmentRoutes = require('./appointments');

const router = express.Router();

router.use('/patients', appointmentRoutes);

module.exports = router;
