#!/bin/bash

path="/otbr/dbbkp"               #Path where the backup of your database "Db
nameBackup="dbbkp"                      #Name of your choice for the backup
mysqlSrv="otservdb"
mysqlUser="mydbuser"
mysqlPass="mypassword"
mysqlDatabase="canary"


# Don't move from here
TIMER="$(date +'%d-%m-%Y-%H-%M')"

if [[ -z "$mysqlUser" || -z "$mysqlPass" || -z "$mysqlDatabase" ]]; then
    echo "Please fill in username, password and database in settings."
else
    mysqldump --login-path=local --column-statistics=0 $mysqlDatabase | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' > $path"/"$nameBackup"-"$TIMER".sql"
    echo "Backup Complete."
fi
