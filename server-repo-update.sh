#!/bin/bash

cd /otbr/distro/
git fetch
git pull

cd /otbr/server/
git fetch
git pull

chown -R otadmin:root /otbr/*

cd /var/www/html/
git fetch
git pull
chown -R www-data.www-data /var/www/html
chmod 760 images/guilds
chmod 760 images/houses
chmod 760 images/gallery
chmod 760 animated-outfits
chmod -R 770 system/cache