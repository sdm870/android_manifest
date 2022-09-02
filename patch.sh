#!/bin/bash

PATCH_DIR=${PWD}
echo "TOP: $PATCH_DIR"

if [ -f "build/envsetup.sh" ]; then
    . build/envsetup.sh
else
    echo "Can't find build/envsetup.sh."
    exit
fi

# ----------------------------------
# Colors
# ----------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

#################################################################
# Download patches
#
# Example: download_patch [FILE_DIR_IN_PATCHES] [PATCH_FILE]
#################################################################
function download_patch {
    echo -e "${GREEN}Downloading patch $2...${NOCOLOR}"
    cd "$PATCH_DIR" || exit
    wget -O "$2" https://raw.githubusercontent.com/sdm870/android_manifest/lineage-19.1/patches/"$1"/"$2" -q --show-progress
    echo -e "${GREEN}.................${NOCOLOR}"
}

#################################################################
# Apply patches
#
# Example: apply_patch [REPO_DIR] [PATCH_FILE]
#################################################################
function apply_patch {
    download_patch "$1" "$2"
    echo -e "${GREEN}Applying patch...${NOCOLOR}"
    echo -e "${LIGHTBLUE}Target repo:${NOCOLOR} $1"
    echo -e "${LIGHTBLUE}Patch file:${NOCOLOR} $2"

    if [ -d "$1" ]; then
        cd "$1" || exit
        if [ -f "$PATCH_DIR/$2" ]; then
            git am -3 --ignore-whitespace "$PATCH_DIR"/"$2"
        else
            echo "Can't find patch file $2, skipping patch"
        fi
        cd "$PATCH_DIR" && echo ""
    else
        echo "Can't find dir $1, skipping patch"
    fi
    if [ -f "$PATCH_DIR/$2" ]; then
        rm "$PATCH_DIR"/"$2"
    fi
    echo -e "${GREEN}.................${NOCOLOR}"
}

apply_patch frameworks/base 0001-base-Introduce-PixelPropsUtils.patch
apply_patch frameworks/base 0001-PixelPropsUtils-spoof-photos.patch

#################################################################
# GERRIT CHERRYPICKS                                            #
#                                                               #
# Examples:                                                     #
# repopick [CHANGE_NUMBER]                                      #
#################################################################

if ! command -v repopick &>/dev/null; then
    echo "repopick could not be found"
    exit
else

    # android_device_xiaomi_sm8250-common
    repopick 334166 334167 334233 334605 334565 334567 334572
    repopick 335326 335440 335441 335326

    # android_device_xiaomi_alioth
    repopick 334644 334645 334646

    # android_kernel_xiaomi_sm8250
    #repopick

    # android_frameworks_base
    repopick 331627

    # android_packages_apps_Camera2
    repopick 332230

    # android_packages_apps_LineageParts
    #repopick

    # android_packages_apps_ThemePicker
    #repopick

    # android_packages_apps_Trebuchet
    #repopick

    # android_packages_apps_Updater
    repopick 332089

    # android_packages_overlays_Lineage
    repopick -f -t custom_font

    # android_vendor_lineage
    #repopick

    echo "Nothing to repopick here"
fi
