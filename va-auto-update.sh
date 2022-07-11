#!/bin/bash

CHECK_VA_UPDATES="${CHECK_VA_UPDATES:-yes}"
AUTOUPDATE_VA="${AUTOUPDATE_VA:-yes}"
VA_REPO="https://github.com/opentibiabr/otbr-va.git"
VA_BRANCH="main"
PREFIX="https://github."
SUFFIX=".git"


# Check OTBR-VA Updates
REMOTE_VA=${VA_REPO#"$PREFIX"}
REMOTE_VA=${REMOTE_VA%"$SUFFIX"}
LOCAL_VA_VER=$(grep '"version":' /otbr/system/server-build/package.json -m1 | cut -d\" -f4)
LOCAL_VA_MAJOR=${LOCAL_VA_VER%%.*}
LOCAL_VA_PATCH=${LOCAL_VA_VER##*.}
LOCAL_VA_MINOR=${LOCAL_VA_VER##$LOCAL_VA_MAJOR.}
LOCAL_VA_MINOR=${LOCAL_VA_MINOR%%.$LOCAL_VA_PATCH}

if (($LOCAL_VA_PATCH <= 17 )); then # Start update <= v1.0.17
    wget -q -O /otbr/system/va-check-update.sh https://raw.githubusercontent.$REMOTE_VA/main/va-check-update.sh
    chmod +x /otbr/system/va-check-update.sh

    wget -q -O /otbr/system/auto-backup.sh https://raw.githubusercontent.$REMOTE_VA/main/auto-backup.sh
    chmod +x /otbr/system/auto-backup.sh

    wget -q -O /otbr/system/server-repo-update.sh https://raw.githubusercontent.$REMOTE_VA/main/server-repo-update.sh
    chmod +x /otbr/system/server-repo-update.sh
fi # End update <= v1.0.17




#pkill canary    # This line must be the last and can be uncommented only if a restart is required to apply changes.