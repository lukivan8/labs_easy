#!/bin/bash
# Docker entrypoint script.

# Uncomment these for help with debugging
# echo "POSTGRES_USERNAME ${POSTGRES_USERNAME}"
# echo "POSTGRES_HOST ${POSTGRES_HOST}"
# echo "POSTGRES_PORT ${POSTGRES_PORT}"

# Wait until Postgres is ready
until pg_isready -U ${POSTGRES_USERNAME} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT}
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin/my_app eval "LabsEasy.Repo.migrate"
bin/my_app start