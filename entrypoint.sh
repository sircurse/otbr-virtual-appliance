#!/bin/bash

N=10
DEFAULT_MAP="${CHECK_DISTRO_UPDATES:-otbr}"

echo ""
echo ""
echo ""

/bin/bash /otbr/system/server-build.sh
/bin/bash /otbr/system/server-check-update.sh


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
