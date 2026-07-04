#!/bin/sh
set -e

cd /root/task 2>/dev/null || true

echo "Stopping and removing docker-compose services..."
docker-compose down -v --remove-orphans || true

echo "Removing task containers if present..."
docker rm -f patient_appointments_app patient_appointments_db 2>/dev/null || true

echo "Removing related images where possible..."
docker rmi root-task-app 2>/dev/null || true

echo "Pruning Docker system resources..."
docker system prune -a --volumes -f || true

echo "Deleting /root/task..."
rm -rf /root/task || true

echo "Cleanup complete."
