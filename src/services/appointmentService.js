const db = require('../db');

function mapAppointmentRow(row) {
  return {
    id: row.id,
    starts_at: row.starts_at,
    status: row.status,
    reason: row.reason,
    doctor: {
      id: row.doctor_id,
      full_name: row.doctor_full_name
    },
    clinic: {
      id: row.clinic_id,
      name: row.clinic_name,
      city: row.clinic_city
    }
  };
}

function getUpcomingAppointments(patientId, callback) {
  const sql = `
    SELECT
      a.id,
      a.starts_at,
      a.status,
      a.reason,
      d.id AS doctor_id,
      d.full_name AS doctor_full_name,
      c.id AS clinic_id,
      c.name AS clinic_name,
      c.city AS clinic_city
    FROM appointments a
    INNER JOIN doctors d
      ON d.id = a.doctor_id
    INNER JOIN clinics c
      ON c.id = a.clinic_id
      AND c.id = d.clinic_id
    WHERE a.patient_id = $1
      AND a.starts_at >= NOW()
      AND a.status = 'scheduled'
    ORDER BY a.starts_at ASC, a.id ASC
  `;

  const promise = db.query(sql, [patientId]).then(function (result) {
    return result.rows.map(mapAppointmentRow);
  });

  if (typeof callback === 'function') {
    promise
      .then(function (rows) {
        callback(null, rows);
      })
      .catch(function (err) {
        callback(err);
      });

    return undefined;
  }

  return promise;
}

module.exports = {
  getUpcomingAppointments: getUpcomingAppointments
};
