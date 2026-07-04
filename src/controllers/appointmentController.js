const appointmentService = require('../services/appointmentService');

function parsePatientId(value) {
  if (!/^\d+$/.test(value)) {
    return null;
  }

  const patientId = Number(value);

  if (!Number.isSafeInteger(patientId) || patientId <= 0) {
    return null;
  }

  return patientId;
}

async function listUpcomingAppointments(req, res) {
  const patientId = parsePatientId(req.params.patientId);

  if (patientId === null) {
    return res.status(400).json({ error: 'Invalid patient id' });
  }

  try {
    const appointments = await appointmentService.getUpcomingAppointments(patientId);

    return res.json({
      patient_id: patientId,
      appointments: appointments
    });
  } catch (err) {
    console.error('Could not load appointments', err);
    return res.status(500).json({ error: 'Could not load appointments' });
  }
}

module.exports = {
  listUpcomingAppointments: listUpcomingAppointments
};
