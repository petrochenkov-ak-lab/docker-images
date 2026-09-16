#!/bin/bash
set -e

if [ -z "${RUNNER_TOKEN}" ]; then
  echo "Error: RUNNER_TOKEN environment variable is required."
  exit 1
fi

# Более надёжная генерация случайного имени
if [ -z "${RUNNER_NAME}" ]; then
  RUNNER_NAME="runner-$(head /dev/urandom | tr -dc 'a-z0-9' | head -c 5)"
fi

echo "Configuring GitHub Actions Runner as ${RUNNER_NAME}..."

./config.sh --unattended \
  --url "https://github.com/petrochenkov-ak-lab" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --replace \
  --work "_work"

# Функция для удаления раннера из GitHub при остановке контейнера
cleanup() {
    echo "Removing runner from GitHub..."
    ./config.sh remove --token "${RUNNER_TOKEN}"
}

# Перехватываем сигналы завершения (SIGINT, SIGTERM)
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

echo "Registration successful. Starting the runner..."

# Запускаем в бэкграунде и ждем, чтобы trap мог перехватить сигналы остановки
./run.sh &
wait $!
