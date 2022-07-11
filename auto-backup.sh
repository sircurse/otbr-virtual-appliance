#!/bin/bash
DB_NAME="${MARIADB_DATABASE:-canary}"

# Don't move from here
TIME="$(date +'%d-%m-%Y-%H-%M')"

if [[ -z "$DB_NAME" ]]; then
    echo "Database name in environments while installing the VA."
else
    mysqldump --login-path=local --column-statistics=0 $DB_NAME | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' > "/otbr/dbbkp/dbbkp-"$TIME".sql"
    echo "Backup Complete."
fi
