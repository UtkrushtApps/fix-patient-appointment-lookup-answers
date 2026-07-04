#!/bin/sh
set -e

cd /root/task

echo "[run] installing Node dependencies..."
npm install
echo "Starting PostgreSQL and Node.js services..."
docker-compose up -d --build

echo "Waiting for PostgreSQL to become ready..."
ATTEMPTS=0
until docker-compose exec -T db pg_isready -U app_user -d healthcare >/dev/null 2>&1; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "$ATTEMPTS" -gt 30 ]; then
    echo "PostgreSQL did not become ready in time."
    docker-compose logs db
    exit 1
  fi
  sleep 2
done

echo "PostgreSQL is ready. Waiting for API..."
ATTEMPTS=0
until wget -qO- http://localhost:3000/health >/dev/null 2>&1; do
  ATTEMPTS=$((ATTEMPTS + 1))
  if [ "$ATTEMPTS" -gt 30 ]; then
    echo "API did not respond in time."
    docker-compose logs app
    exit 1
  fi
  sleep 2
done

echo "Application is running."
echo "Health check: http://localhost:3000/health"
echo "Try: http://localhost:3000/api/patients/1/appointments"
