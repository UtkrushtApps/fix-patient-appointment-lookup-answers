# Solution Steps

1. Update the database helper so it exposes a promise-returning `query` function while still supporting PostgreSQL connection settings from environment variables used by Docker Compose.

2. Change the appointment service to run one parameterized SQL query with `$1` for the patient id instead of interpolating values into SQL.

3. In the service query, select only upcoming scheduled appointments by filtering `starts_at >= NOW()` and `status = 'scheduled'`.

4. Join `appointments` to `doctors` through `appointments.doctor_id = doctors.id` and to `clinics` through the appointment clinic relationship, while ensuring the doctor belongs to the same clinic.

5. Map the flat SQL rows into clean JSON appointment objects that include appointment fields plus nested `doctor` and `clinic` details.

6. Update the controller to parse and validate the route parameter as a positive safe integer before calling the service.

7. Make the controller `async` and `await` the service result before sending the response so the endpoint no longer returns an empty or stale appointments array.

8. Return a consistent success response shaped as `{ patient_id, appointments }` and return predictable JSON errors for invalid patient ids and database failures.

9. Keep the route mounted at `/api/patients/:patientId/appointments` so clients can call the required endpoint without changing URLs.

10. Optionally pass PostgreSQL environment variables through Docker Compose and keep the health check endpoint unchanged for service readiness checks.

