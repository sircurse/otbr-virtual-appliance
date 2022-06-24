#!/bin/bash

CHECK_DISTRO_UPDATES="${CHECK_DISTRO_UPDATES:-yes}"
CHECK_DATAPACK_UPDATES="${CHECK_DATAPACK_UPDATES:-yes}"
CHECK_AAC_UPDATES="${CHECK_AAC_UPDATES:-yes}"
AAC_REPO="${AAC_REPO:-https://github.com/sircurse/myaac.git}"
AAC_BRANCH="${AAC_BRANCH:-master}"
DATAPACK_REPO="${DATAPACK_REPO:-https://github.com/opentibiabr/otservbr-global.git}"
DATAPACK_BRANCH="${DATAPACK_BRANCH:-main}"
DISTRO_REPO="${DISTRO_REPO:-https://github.com/opentibiabr/canary.git}"
DISTRO_BRANCH="${DISTRO_BRANCH:-main}"
PREFIX="https://github."
SUFFIX=".git"


# Check Distro Updates
if [ "$CHECK_DISTRO_UPDATES" == "yes" ]; then
REMOTE_DISTRO=${DISTRO_REPO#"$PREFIX"}
REMOTE_DISTRO=${REMOTE_DISTRO%"$SUFFIX"}
wget -q -O /otbr/system/tmp/distro-version.json https://raw.githubusercontent.$REMOTE_DISTRO/main/package.json
REMOTE_DISTRO_VER=$(grep '"version":' /otbr/system/tmp/distro-version.json -m1 | cut -d\" -f4)
REMOTE_DISTRO_MAJOR=${REMOTE_DISTRO_VER%%.*}
REMOTE_DISTRO_PATCH=${REMOTE_DISTRO_VER##*.}
REMOTE_DISTRO_MINOR=${REMOTE_DISTRO_VER##$REMOTE_DISTRO_MAJOR.}
REMOTE_DISTRO_MINOR=${REMOTE_DISTRO_MINOR%%.$REMOTE_DISTRO_PATCH}
LOCAL_DISTRO_VER=$(grep '"version":' /otbr/distro/package.json -m1 | cut -d\" -f4)
LOCAL_DISTRO_MAJOR=${LOCAL_DISTRO_VER%%.*}
LOCAL_DISTRO_PATCH=${LOCAL_DISTRO_VER##*.}
LOCAL_DISTRO_MINOR=${LOCAL_DISTRO_VER##$LOCAL_DISTRO_MAJOR.}
LOCAL_DISTRO_MINOR=${LOCAL_DISTRO_MINOR%%.$LOCAL_DISTRO_PATCH}

    if [ "$LOCAL_DISTRO_MAJOR" != "$REMOTE_DISTRO_MAJOR" ]; then
    echo $LOCAL_DISTRO_MAJOR $REMOTE_DISTRO_MAJOR
        echo "There is a major release on Canary Distro. For more information please check the latest commits on:"
        echo "https://github.com/$REMOTE_DISTRO/commits/$DISTRO_BRANCH"
        echo "It is recommend to follow any guide while updating major releases."
        echo "Usually it is required to sync the updates on your datapack and distro sources."
        echo "You can also execute git fetch command in your main folder."
        echo "Followed by git pull."
        echo ""
        echo ""
    else
        if [ "$LOCAL_DISTRO_MINOR" != "$REMOTE_DISTRO_MINOR" ]; then
            echo "There is a minor update on Canary Distro. For more information please check the latest commits on:"
            echo "https://github.com/$REMOTE_DISTRO/commits/$DISTRO_BRANCH"
            echo "It is recommend to follow any guide while updating minor versions."
            echo "Usually it is required to sync the updates on your datapack and distro sources."
            echo "You can also execute git fetch command in your main folder."
            echo "Followed by git pull."
            echo ""
            echo ""
        else
            if [ "$LOCAL_DISTRO_PATCH" != "$REMOTE_DISTRO_PATCH" ]; then
                echo "There are new fixes or patches available on your Canary Distro. For more information please check the latest commits on:"
                echo "https://github.com/$REMOTE_DISTRO/commits/$DISTRO_BRANCH"
                echo "You can also execute git fetch command in your main folder."
                echo "Followed by git pull."
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

# Check Datapack Updates
if [ "$CHECK_DATAPACK_UPDATES" == "yes" ]; then
REMOTE_DATAPACK=${DATAPACK_REPO#"$PREFIX"}
REMOTE_DATAPACK=${REMOTE_DATAPACK%"$SUFFIX"}
wget -q -O /otbr/system/tmp/datapack-version.json https://raw.githubusercontent.$REMOTE_DATAPACK/main/package.json
REMOTE_DATAPACK_VER=$(grep '"version":' /otbr/system/tmp/datapack-version.json -m1 | cut -d\" -f4)
REMOTE_DATAPACK_MAJOR=${REMOTE_DATAPACK_VER%%.*}
REMOTE_DATAPACK_PATCH=${REMOTE_DATAPACK_VER##*.}
REMOTE_DATAPACK_MINOR=${REMOTE_DATAPACK_VER##$REMOTE_DATAPACK_MAJOR.}
REMOTE_DATAPACK_MINOR=${REMOTE_DATAPACK_MINOR%%.$REMOTE_DATAPACK_PATCH}
LOCAL_DATAPACK_VER=$(grep '"version":' /otbr/server/package.json -m1 | cut -d\" -f4)
LOCAL_DATAPACK_MAJOR=${LOCAL_DATAPACK_VER%%.*}
LOCAL_DATAPACK_PATCH=${LOCAL_DATAPACK_VER##*.}
LOCAL_DATAPACK_MINOR=${LOCAL_DATAPACK_VER##$LOCAL_DATAPACK_MAJOR.}
LOCAL_DATAPACK_MINOR=${LOCAL_DATAPACK_MINOR%%.$LOCAL_DATAPACK_PATCH}

    if [ "$LOCAL_DATAPACK_MAJOR" != "$REMOTE_DATAPACK_MAJOR" ]; then
        echo "There is a major release on Canary Distro. For more information please check the latest commits on:"
        echo "https://github.com/$REMOTE_DATAPACK/commits/$DATAPACK_BRANCH"
        echo "It is recommend to follow any guide while updating major releases."
        echo "Usually it is required to sync the updates on your datapack and distro sources."
        echo "You can also execute git fetch command in your main folder."
        echo "Followed by git pull."
        echo ""
        echo ""
    else
        if [ "$LOCAL_DATAPACK_MINOR" != "$REMOTE_DATAPACK_MINOR" ]; then
            echo "There is a minor update on Canary Distro. For more information please check the latest commits on:"
            echo "https://github.com/$REMOTE_DATAPACK/commits/$DATAPACK_BRANCH"
            echo "It is recommend to follow any guide while updating minor versions."
            echo "Usually it is required to sync the updates on your datapack and distro sources."
            echo "You can also execute git fetch command in your main folder."
            echo "Followed by git pull."
            echo ""
            echo ""
        else
            if [ "$LOCAL_DATAPACK_PATCH" != "$REMOTE_DATAPACK_PATCH" ]; then
                echo "There are new fixes or patches available on your Canary Distro. For more information please check the latest commits on:"
                echo "https://github.com/$REMOTE_DATAPACK/commits/$DATAPACK_BRANCH"
                echo "You can also execute git fetch command in your main folder."
                echo "Followed by git pull."
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

# Check AAC Updates
if [ "$CHECK_AAC_UPDATES" == "yes" ]; then
REMOTE_AAC=${AAC_REPO#"$PREFIX"}
REMOTE_AAC=${REMOTE_AAC%"$SUFFIX"}
wget -q -O /otbr/system/tmp/aac-version.json https://raw.githubusercontent.$REMOTE_AAC/main/package.json
REMOTE_AAC_VER=$(grep '"version":' /otbr/system/tmp/aac-version.json -m1 | cut -d\" -f4)
REMOTE_AAC_MAJOR=${REMOTE_AAC_VER%%.*}
REMOTE_AAC_PATCH=${REMOTE_AAC_VER##*.}
REMOTE_AAC_MINOR=${REMOTE_AAC_VER##$REMOTE_AAC_MAJOR.}
REMOTE_AAC_MINOR=${REMOTE_AAC_MINOR%%.$REMOTE_AAC_PATCH}
LOCAL_AAC_VER=$(grep '"version":' /var/www/html/package.json -m1 | cut -d\" -f4)
LOCAL_AAC_MAJOR=${LOCAL_AAC_VER%%.*}
LOCAL_AAC_PATCH=${LOCAL_AAC_VER##*.}
LOCAL_AAC_MINOR=${LOCAL_AAC_VER##$LOCAL_AAC_MAJOR.}
LOCAL_AAC_MINOR=${LOCAL_AAC_MINOR%%.$LOCAL_AAC_PATCH}

    if [ "$LOCAL_AAC_MAJOR" != "$REMOTE_AAC_MAJOR" ]; then
        echo "There is a major release on Canary Distro. For more information please check the latest commits on:"
        echo "https://github.com/$REMOTE_AAC/commits/$AAC_BRANCH"
        echo "It is recommend to follow any guide while updating major releases."
        echo "Usually it is required to sync the updates on your datapack and distro sources."
        echo "You can also execute git fetch command in your main folder."
        echo "Followed by git pull."
        echo ""
        echo ""
    else
        if [ "$LOCAL_AAC_MINOR" != "$REMOTE_AAC_MINOR" ]; then
            echo "There is a minor update on Canary Distro. For more information please check the latest commits on:"
            echo "https://github.com/$REMOTE_AAC/commits/$AAC_BRANCH"
            echo "It is recommend to follow any guide while updating minor versions."
            echo "Usually it is required to sync the updates on your datapack and distro sources."
            echo "You can also execute git fetch command in your main folder."
            echo "Followed by git pull."
            echo ""
            echo ""
        else
            if [ "$LOCAL_AAC_PATCH" != "$REMOTE_AAC_PATCH" ]; then
                echo "There are new fixes or patches available on your Canary Distro. For more information please check the latest commits on:"
                echo "https://github.com/$REMOTE_AAC/commits/$AAC_BRANCH"
                echo "You can also execute git fetch command in your main folder."
                echo "Followed by git pull."
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
