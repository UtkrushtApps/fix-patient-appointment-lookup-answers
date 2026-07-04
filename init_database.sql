CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  full_name TEXT NOT NULL,
  date_of_birth DATE NOT NULL
);

CREATE TABLE clinics (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT NOT NULL
);

CREATE TABLE doctors (
  id SERIAL PRIMARY KEY,
  full_name TEXT NOT NULL,
  clinic_id INTEGER NOT NULL REFERENCES clinics(id)
);

CREATE TABLE appointments (
  id SERIAL PRIMARY KEY,
  patient_id INTEGER NOT NULL REFERENCES patients(id),
  clinic_id INTEGER NOT NULL REFERENCES clinics(id),
  doctor_id INTEGER NOT NULL REFERENCES doctors(id),
  starts_at TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL DEFAULT 'scheduled',
  reason TEXT
);

CREATE INDEX idx_doctors_clinic_id ON doctors(clinic_id);
CREATE INDEX idx_appointments_patient_starts_at ON appointments(patient_id, starts_at);

INSERT INTO patients (full_name, date_of_birth) VALUES
  ('Asha Mehta', '1991-05-12'),
  ('Rohan Iyer', '1986-11-03'),
  ('Meera Shah', '2000-02-20');

INSERT INTO clinics (name, city) VALUES
  ('Green Valley Clinic', 'Pune'),
  ('Northside Health Center', 'Mumbai'),
  ('CareFirst Family Clinic', 'Bengaluru');

INSERT INTO doctors (full_name, clinic_id) VALUES
  ('Dr. Kavita Rao', 1),
  ('Dr. Sameer Kulkarni', 2),
  ('Dr. Nisha Menon', 3);

INSERT INTO appointments (patient_id, clinic_id, doctor_id, starts_at, status, reason) VALUES
  (1, 1, 1, NOW() + INTERVAL '2 days', 'scheduled', 'General checkup'),
  (1, 2, 2, NOW() + INTERVAL '7 days', 'scheduled', 'Follow-up consultation'),
  (1, 3, 3, NOW() - INTERVAL '4 days', 'completed', 'Old consultation'),
  (1, 1, 1, NOW() + INTERVAL '10 days', 'cancelled', 'Cancelled visit'),
  (2, 2, 2, NOW() + INTERVAL '1 day', 'scheduled', 'Blood pressure review'),
  (3, 3, 3, NOW() + INTERVAL '3 days', 'scheduled', 'Annual physical');
