#!/bin/bash

CHECK_VA_UPDATES="${CHECK_VA_UPDATES:-yes}"
AUTOUPDATE_VA="${AUTOUPDATE_VA:-yes}"
AAC_REPO="https://github.com/sircurse/otbr-va.git"
AAC_BRANCH="main"
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
    echo $LOCAL_VA_MAJOR $REMOTE_VA_MAJOR
        echo "There is a major release on OTBR Virtual Appliance. For more information please check the latest commits on:"
        echo "https://github.com/$REMOTE_VA/commits/$VA_BRANCH"
        echo "While this is a MAJOR release, the auto update will not run."
        echo "It's recommended to re-deploy the OTBR Virtual Appliance image due to the changes in the operational system."
        echo "For further questions please contact us on our official Discord channel."
        echo "https://discord.gg/3NxYnyV"
        echo ""
        echo ""
    else
        if [ "$LOCAL_VA_MINOR" != "$REMOTE_VA_MINOR" ]; then
            echo "There is a minor update on OTBR Virtual Appliance. For more information please check the latest commits on:"
            echo "https://github.com/$REMOTE_VA/commits/$VA_BRANCH"
            echo "Minor updates can affect how your system is configured, and any changes will be taken during the process."
            echo "The update is required in order to keep the consistency of the advances of the project with your server."
            /bin/bash /otbr/system/va-auto-update.sh
            mv /otbr/system/tmp/va-version.json /otbr/system/server-build/package.json
            echo "OTBR Virtual Appliance updated with success!"
            echo ""
            echo ""
        else
            if [ "$LOCAL_VA_PATCH" != "$REMOTE_VA_PATCH" ]; then
                echo "There are new fixes or patches available on OTBR Virtual Appliance. For more information please check the latest commits on:"
                echo "https://github.com/$REMOTE_VA/commits/$VA_BRANCH"
                echo "Fixes and patches can be executed during the startup process."
                /bin/bash /otbr/system/va-auto-update.sh
                mv /otbr/system/tmp/va-version.json /otbr/system/server-build/package.json
                echo "OTBR Virtual Appliance updated with success!"
                echo ""
                echo ""
            else
                sleep 0
            fi
        fi
    fi
else
	sleep 0
fi
