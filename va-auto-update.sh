#!/bin/bash

CHECK_VA_UPDATES="${CHECK_VA_UPDATES:-yes}"
AUTOUPDATE_VA="${AUTOUPDATE_VA:-yes}"
VA_REPO="https://github.com/opentibiabr/otbr-va.git"
VA_BRANCH="main"
PREFIX="https://github."
SUFFIX=".git"


# Check OTBR-VA Updates
MSORT_OK=$(dpkg-query -W --showformat='${Status}\n' msort|grep "install ok installed")
if [ "" = "$MSORT_OK" ]; then
  echo "No msort installed. Setting up msort."
  apt install -y msort
fi

# Save versions in variables
REMOTE_VA_VER=$(grep '"version":' /otbr/system/tmp/va-version.json -m1 | cut -d\" -f4)
LOCAL_VA_VER=$(grep '"version":' /otbr/system/server-build/package.json -m1 | cut -d\" -f4)

# Function to verify if local version is less than remote version
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }

# Check versions
if version_lt $LOCAL_VA_VER $REMOTE_VA_VER; then
    if version_lt $LOCAL_VA_VER "1.2.1"; then # UPDATE v1.2.1
        wget -q -O /otbr/system/va-check-update.sh https://raw.githubusercontent.$REMOTE_VA/main/va-check-update.sh
        chmod +x /otbr/system/va-check-update.sh
        sed -i -e 's/\r$//' /otbr/system/va-check-update.sh

        wget -q -O /otbr/system/auto-backup.sh https://raw.githubusercontent.$REMOTE_VA/main/auto-backup.sh
        chmod +x /otbr/system/auto-backup.sh
        sed -i -e 's/\r$//' /otbr/system/auto-backup.sh

        wget -q -O /otbr/system/server-repo-update.sh https://raw.githubusercontent.$REMOTE_VA/main/server-repo-update.sh
        chmod +x /otbr/system/server-repo-update.sh
        sed -i -e 's/\r$//' /otbr/system/server-repo-update.sh
    fi
fi

#pkill canary    # This line must be the last and can be uncommented only if a restart is required to apply changes.
