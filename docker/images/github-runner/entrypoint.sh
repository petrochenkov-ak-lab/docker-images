#!/bin/bash

if [ -z "${RUNNER_TOKEN}" ]; then
  echo "Error: RUNNER_TOKEN environment variable is required."
  exit 1
fi

if [ -z "${RUNNER_NAME}" ]; then
  RUNNER_NAME="runner-$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 5 | head -n 1)" || exit
fi

echo "Configuring GitHub Actions Runner..."

./config.sh --unattended \
  --url "https://github.com/petrochenkov-ak-lab" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --replace \
  --work "_work" || exit

echo "Registration successful. Starting the runner..."

exec ./run.sh
