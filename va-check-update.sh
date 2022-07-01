#!/bin/bash

CHECK_VA_UPDATES="${CHECK_VA_UPDATES:-yes}"
AUTOUPDATE_VA="${AUTOUPDATE_VA:-yes}"
VA_REPO="https://github.com/opentibiabr/otbr-va.git"
VA_BRANCH="main"
PREFIX="https://github."
SUFFIX=".git"


# Check OTBR-VA Updates
if [ "$CHECK_VA_UPDATES" == "yes" ]; then
REMOTE_VA=${VA_REPO#"$PREFIX"}
REMOTE_VA=${REMOTE_VA%"$SUFFIX"}
wget -q -O /otbr/system/tmp/va-version.json https://raw.githubusercontent.$REMOTE_VA/main/package.json
REMOTE_VA_VER=$(grep '"version":' /otbr/system/tmp/va-version.json -m1 | cut -d\" -f4)
REMOTE_VA_MAJOR=${REMOTE_VA_VER%%.*}
REMOTE_VA_PATCH=${REMOTE_VA_VER##*.}
REMOTE_VA_MINOR=${REMOTE_VA_VER##$REMOTE_VA_MAJOR.}
REMOTE_VA_MINOR=${REMOTE_VA_MINOR%%.$REMOTE_VA_PATCH}
LOCAL_VA_VER=$(grep '"version":' /otbr/system/server-build/package.json -m1 | cut -d\" -f4)
LOCAL_VA_MAJOR=${LOCAL_VA_VER%%.*}
LOCAL_VA_PATCH=${LOCAL_VA_VER##*.}
LOCAL_VA_MINOR=${LOCAL_VA_VER##$LOCAL_VA_MAJOR.}
LOCAL_VA_MINOR=${LOCAL_VA_MINOR%%.$LOCAL_VA_PATCH}

    if [ "$LOCAL_VA_MAJOR" != "$REMOTE_VA_MAJOR" ]; then
        echo ""
        echo "There is a major release for OTBR Virtual Appliance. For more information please check the latest commits on:"
        echo "https://github.com/$REMOTE_VA/commits/$VA_BRANCH"
        echo "While this is a MAJOR release, the auto update will not run."
        echo "It's recommended to re-deploy the OTBR Virtual Appliance image due to the changes in the operational system."
        echo "For further questions please contact us on our official Discord channel."
        echo "https://discord.gg/3NxYnyV"
        echo ""
    else
        if [ "$LOCAL_VA_MINOR" != "$REMOTE_VA_MINOR" ]; then
            echo ""
            echo "There is a minor update for OTBR Virtual Appliance. For more information please check the latest commits on:"
            echo "https://github.com/$REMOTE_VA/commits/$VA_BRANCH"
            echo "Minor updates are executed during the startup process and it might restart the server to conclude the changes."
            echo "The update is required in order to keep the consistency of the advances of the project with your server."
            wget -q -O /otbr/system/server-build/va-auto-update.sh https://raw.githubusercontent.$REMOTE_VA/main/va-auto-update.sh
            chmod +x /otbr/system/server-build/va-auto-update.sh
            /bin/bash /otbr/system/server-build/va-auto-update.sh
            mv /otbr/system/tmp/va-version.json /otbr/system/server-build/package.json
            echo "OTBR Virtual Appliance updated with success!"
            echo ""
        else
            if [ "$LOCAL_VA_PATCH" != "$REMOTE_VA_PATCH" ]; then
                echo ""
                echo "There are new fixes or patches available for OTBR Virtual Appliance. For more information please check the latest commits on:"
                echo "https://github.com/$REMOTE_VA/commits/$VA_BRANCH"
                echo "Fixes and patches are executed during the startup process and it might restart the Canary service to conclude the changes."
                wget -q -O /otbr/system/server-build/va-auto-update.sh https://raw.githubusercontent.$REMOTE_VA/main/va-auto-patch.sh
                chmod +x /otbr/system/server-build/va-auto-patch.sh
                /bin/bash /otbr/system/server-build/va-auto-patch.sh
                mv /otbr/system/tmp/va-version.json /otbr/system/server-build/package.json
                echo "OTBR Virtual Appliance updated with success!"
                echo ""
            else
                sleep 0
            fi
        fi
    fi
else
	sleep 0
fi
