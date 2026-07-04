const express = require('express');
const appointmentController = require('../controllers/appointmentController');

const router = express.Router();

router.get('/:patientId/appointments', appointmentController.listUpcomingAppointments);

module.exports = router;
