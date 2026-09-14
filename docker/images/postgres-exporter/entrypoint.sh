#!/bin/sh

SECRET_FILE="/run/secrets/DJANGO_DATABASE_URL"

[ ! -f "$SECRET_FILE" ] && echo "ERROR: $SECRET_FILE not exists" >&2 && exit
[ ! -s "$SECRET_FILE" ] && echo "ERROR: $SECRET_FILE is empty" >&2 && exit 1

export DATA_SOURCE_NAME=$(cat "$SECRET_FILE") || exit

[ -z "$DATA_SOURCE_NAME" ] && echo "ERROR: DATA_SOURCE_NAME is empty" >&2 && exit 1

exec /bin/postgres_exporter
