#!/bin/bash

cd /otbr/distro/
echo "Updating distro repo.."
git config pull.rebase false
git fetch
git pull

cd /otbr/server/
echo ""
echo "Updating datapack repo.."
git config pull.rebase false
git fetch
git pull

chown -R otadmin:root /otbr/*

cd /var/www/html/
echo ""
echo "Updating AAC repo.."
git config pull.rebase false
git fetch
git pull
chown -R www-data.www-data /var/www/html
chmod 760 images/guilds
chmod 760 images/houses
chmod 760 images/gallery
chmod 760 animated-outfits
chmod -R 770 system/cache