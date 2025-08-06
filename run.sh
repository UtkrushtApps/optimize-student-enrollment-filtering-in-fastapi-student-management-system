#!/bin/bash
set -e
cd /root/task
echo 'Starting StudentHub containers...'
docker-compose up -d
echo 'Waiting for PostgreSQL service to be ready...'
until docker exec studenthub_postgres pg_isready -U studentuser > /dev/null 2>&1; do
  sleep 2
done
echo 'Database is ready.'
echo 'Waiting for FastAPI to start...'
until curl -s http://localhost:8000/docs > /dev/null 2>&1; do
  sleep 2
done
echo 'FastAPI service is up.'
echo 'Deployment completed successfully!'
