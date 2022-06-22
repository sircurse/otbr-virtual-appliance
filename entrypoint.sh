#!/bin/bash

N=10
DIR_DISTRO="/otbr/distro/"
DIR_SERVER="/otbr/server/"
DIR_AAC="/var/www/html"

HTTP_PORT="${HTTP_PORT:-8080}"
ENABLE_SSL="${ENABLE_SSL:-no}"
SERVER_IP="${SERVER_IP:-127.0.0.1}"
SERVER_NAME="${SERVER_NAME:-canary}"
SERVER_LOCATION="${SERVER_LOCATION:-South America}"
WEBPAGE="${WEBPAGE:-127.0.0.1}"
DEFAULT_MAP="${DEFAULT_MAP:-otbr}"

DB_USER="${MARIADB_USER:-canary}"
DB_PASS="${MARIADB_PASSWORD:-canary}"
DB_NAME="${MARIADB_DATABASE:-canary}"
DB_ROOTPASS="${MARIADB_ROOT_PASSWORD:-canary}"

AAC_REPO="${AAC_REPO:-https://github.com/sircurse/myaac.git}"
AAC_BRANCH="${AAC_BRANCH:-master}"
DATAPACK_REPO="${DATAPACK_REPO:-https://github.com/opentibiabr/otservbr-global.git}"
DATAPACK_BRANCH="${DATAPACK_BRANCH:-main}"
DISTRO_REPO="${DISTRO_REPO:-https://github.com/opentibiabr/canary.git}"
DISTRO_BRANCH="${DISTRO_BRANCH:-main}"


if [ -d "$DIR_DISTRO" ]
then
	if [ "$(ls -A $DIR_DISTRO)" ]; then
		sleep 0
	else
		echo "##################### RUNNING SERVER BUILD SETUP #######################"
		echo "Downloading Canary distro files..."
		cd /otbr/
		git clone -q --single-branch --branch $DISTRO_BRANCH $DISTRO_REPO distro
		git config --global --add safe.directory /otbr/distro
		echo "Download concluded!"
		echo ""
	fi
else
	echo "######################### RUNNING BUILD SETUP ##########################"
	echo "Downloading Canary distro files..."
	cd /otbr/
	git clone -q --single-branch --branch $DISTRO_BRANCH $DISTRO_REPO distro
	git config --global --add safe.directory /otbr/distro
	echo "Download concluded!"
	echo ""
fi

if [ -d "$DIR_SERVER" ]
then
	if [ "$(ls -A $DIR_SERVER)" ]; then
		sleep 0
	else
		echo "Downloading server datapack..."
		cd /otbr/
		git clone -q --single-branch --branch $DATAPACK_BRANCH $DATAPACK_REPO server
		echo "Download concluded!"
		echo ""
		echo "Setting up Canary server & datapack..."
		cd /otbr/server/
		cp config.lua.dist config.lua
		sed -i '/mysqlHost = .*$/c\mysqlHost = "'otservdb'"' config.lua
		sed -i '/mysqlUser = .*$/c\mysqlUser = "'$DB_USER'"' config.lua
		sed -i '/mysqlPass = .*$/c\mysqlPass = "'$DB_PASS'"' config.lua
		sed -i '/mysqlDatabase = .*$/c\mysqlDatabase = "'$DB_NAME'"' config.lua
		sed -i '/ip = .*$/c\ip = "'$SERVER_IP'"' config.lua
		sed -i '/serverName = .*$/c\serverName = "'$SERVER_NAME'"' config.lua
		sed -i '/url = .*$/c\url = "'$WEBPAGE'"' config.lua
		sed -i '/location = .*$/c\location = "'"$SERVER_LOCATION"'"' config.lua
		cp /otbr/system/server-build/canary .
		cd /otbr/system/
		sed -i '/mysqlUser=.*$/c\mysqlUser="'$DB_USER'"' auto-backup.sh
		sed -i '/mysqlPass=.*$/c\mysqlPass="'$DB_PASS'"' auto-backup.sh
		sed -i '/mysqlDatabase=.*$/c\mysqlDatabase="'$DB_NAME'"' auto-backup.sh
		cd /otbr/server/
		git config --global --add safe.directory /otbr/server
		sed -i -e '$aworld.zip' .git/info/exclude
		git config --global user.name 'Snail Mail'
		git config --global user.email '<>'
		git rm --cached data/world/world.zip
		git commit -m "Untracking world.zip"
		echo "Canary server set up with success!"
		echo ""
		echo "Creating OTBR Database..."
		chown -R otadmin:root /otbr/*
		cd /otbr/server/
		/usr/bin/expect <<-EOD
			spawn mysql_config_editor set --login-path=local --host=otservdb --user=$DB_USER --password
			expect "Enter password:"
			send "$DB_PASS\n"
			expect eof
		EOD
		mysql --login-path=local $DB_NAME < schema.sql
		mysql --login-path=local -D $DB_NAME -e "UPDATE accounts SET password = SUBSTRING(MD5(RAND()) FROM 1 FOR 51) WHERE id = 1;"
		echo "Database created with success!"
		echo ""
	fi
else
	echo "Downloading server datapack..."
	cd /otbr/
	git clone -q --single-branch --branch $DATAPACK_BRANCH $DATAPACK_REPO server
	echo "Download concluded!"
	echo ""
	echo "Setting up Canary server & datapack..."
	cd /otbr/server/
	cp config.lua.dist config.lua
	sed -i '/mysqlHost = .*$/c\mysqlHost = "'otservdb'"' config.lua
	sed -i '/mysqlUser = .*$/c\mysqlUser = "'$DB_USER'"' config.lua
	sed -i '/mysqlPass = .*$/c\mysqlPass = "'$DB_PASS'"' config.lua
	sed -i '/mysqlDatabase = .*$/c\mysqlDatabase = "'$DB_NAME'"' config.lua
	sed -i '/ip = .*$/c\ip = "'$SERVER_IP'"' config.lua
	sed -i '/serverName = .*$/c\serverName = "'$SERVER_NAME'"' config.lua
	sed -i '/url = .*$/c\url = "'$WEBPAGE'"' config.lua
	sed -i '/location = .*$/c\location = "'"$SERVER_LOCATION"'"' config.lua
	cp /otbr/system/server-build/canary .
	cd /otbr/system/
	sed -i '/mysqlUser=.*$/c\mysqlUser="'$DB_USER'"' auto-backup.sh
	sed -i '/mysqlPass=.*$/c\mysqlPass="'$DB_PASS'"' auto-backup.sh
	sed -i '/mysqlDatabase=.*$/c\mysqlDatabase="'$DB_NAME'"' auto-backup.sh
	cd /otbr/server/
	git config --global --add safe.directory /otbr/server
	sed -i -e '$aworld.zip' .git/info/exclude
	git config --global user.name 'Snail Mail'
	git config --global user.email '<>'
	git rm --cached data/world/world.zip
	git commit -m "Untracking world.zip"
	echo "Canary server set up with success!"
	echo ""
	echo "Creating OTBR Database..."
	chown -R otadmin:root /otbr/*
	cd /otbr/server/
	/usr/bin/expect <<-EOD
		spawn mysql_config_editor set --login-path=local --host=otservdb --user=$DB_USER --password
		expect "Enter password:"
		send "$DB_PASS\n"
		expect eof
	EOD
	mysql --login-path=local $DB_NAME < schema.sql
	mysql --login-path=local -D $DB_NAME -e "UPDATE accounts SET password = SUBSTRING(MD5(RAND()) FROM 1 FOR 51) WHERE id = 1;"
	echo "Database created with success!"
	echo ""
fi

if [ -d "$DIR_AAC" ]
then
	if [ "$(ls -A $DIR_AAC)" ]; then
		sleep 0
	else
		echo "Downloading AAC files..."
		cd /var/www/
		git clone -q --single-branch --branch $AAC_BRANCH $AAC_REPO html
		echo "Download concluded!"
		echo ""
		echo "Setting up AAC..."
		cd /var/www/html/
		chown -R www-data.www-data /var/www/html
		chmod 760 images/guilds
		chmod 760 images/houses
		chmod 760 images/gallery
		chmod 760 animated-outfits
		chmod -R 770 system/cache
		echo "AAC permissions set with success!"
		echo "ATTENTION: MyAAC is not yet installed, to complete the installation go to:"
		if [[ $HTTP_PORT != 80 && $HTTP_PORT != 443 ]]; then
			echo "$WEBPAGE:$HTTP_PORT/install"
		else
			echo "$WEBPAGE/install"
		fi
		echo "####################### SERVER BUILD COMPLETED #########################"
	fi
else
	echo "Downloading AAC files..."
	cd /var/www/
	git clone -q --single-branch --branch $AAC_BRANCH $AAC_REPO html
	echo "Download concluded!"
	echo ""
	echo "Setting up AAC..."
	cd /var/www/html/
	chown -R www-data.www-data /var/www/html
	chmod 760 images/guilds
	chmod 760 images/houses
	chmod 760 images/gallery
	chmod 760 animated-outfits
	chmod -R 770 system/cache
	echo "AAC permissions set with success!"
	echo "ATTENTION: MyAAC is not yet installed, to complete the installation go to:"
		if [[ $HTTP_PORT != 80 && $HTTP_PORT != 443 ]]; then
			echo "$WEBPAGE:$HTTP_PORT/install"
		else
			echo "$WEBPAGE/install"
		fi
	echo "####################### SERVER BUILD COMPLETED #########################"
fi

if [ -f /etc/nginx/sites-available/default ]; then
	sleep 0
else
	if [ "$ENABLE_SSL" == "yes" ]
	then
		cp /etc/nginx/templates/ssl-enabled /etc/nginx/sites-available/default
	else
		cp /etc/nginx/templates/ssl-disabled /etc/nginx/sites-available/default
		cd /etc/nginx/sites-available/
		sed -i '/listen 80.*$/c\        listen '$HTTP_PORT' default_server;' default
		sed -i '/80 default_server.*$/c\        listen [::]:'$HTTP_PORT' default_server;' default
	fi
fi

echo ""
echo ""
echo "######################## STARTING UP SERVICES ##########################"
sleep $N

echo ""
echo "Starting crontab..."
service cron start
echo ""

echo "Starting PHP-FPM..."
service php8.1-fpm start
echo "* Starting PHP-FPM [ OK ]"
echo ""

echo "Starting Nginx..."
service nginx start
echo ""

echo "########################################################################"
echo "###################### STARTING UP CANARY SERVER #######################"
echo "########################################################################"
if [ -f /otbr/distro/canary ]; then
	echo "Updating OTBR distro..."
	rm /otbr/server/canary
	cp /otbr/system/canary /otbr/server/canary
	chown otadmin:root /otbr/server/canary
	echo "OTBR distro updated with success!"
fi

if [ "$DEFAULT_MAP" == "otbr" ]; then
	if [ -f /otbr/server/data/world/world.zip ]; then
		UPDATE_MAP="$(curl -L -sI https://www.dropbox.com/s/nmc8w82one8mmp9/world.zip?dl=1 | grep -i Content-Length | awk 'a=$2/617  {print $2}')"
		REMOTE_MAP="$(echo $UPDATE_MAP | grep -o -E '[0-9]+')"
		LOCAL_MAP="$(ls -nl /otbr/server/data/world/world.zip | awk '{print $5}')"

		if [ "$LOCAL_MAP" != "$REMOTE_MAP" ]; then
			echo "Updating map..."
			rm /otbr/server/data/world/world.zip
			if [ -f /otbr/server/data/world/canary.otbm ]; then
				rm /otbr/server/data/world/canary.otbm
			fi
			wget -q -O /otbr/server/data/world/world.zip https://www.dropbox.com/s/nmc8w82one8mmp9/world.zip?dl=1
			echo "Map updated with success!"
		fi
	else
		wget -q -O /otbr/server/data/world/world.zip https://www.dropbox.com/s/nmc8w82one8mmp9/world.zip?dl=1
		echo "Map downloaded with success!"
	fi
fi

ulimit -c unlimited
set -o pipefail
cd /otbr/server ; gdb -ex run --batch -return-child-result --args su otadmin -c ./canary
