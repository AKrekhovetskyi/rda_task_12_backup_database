#! /bin/bash

set -o errexit -o nounset -o pipefail

if [ -z "${DB_USER:-}" ] || [ -z "${DB_PASSWORD:-}" ]; then
    echo "ERROR: DB_USER and DB_PASSWORD must be set in environment" >&2; exit 1;
fi

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" ShopDB --add-drop-table --no-create-db --result-file=backup.sql
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBReserve < backup.sql

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" ShopDB --no-create-info --result-file=backup-no-info.sql
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBDevelopment < backup-no-info.sql
