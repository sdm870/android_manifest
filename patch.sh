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

#apply_patch device/xiaomi/sm8250-common 0001-sm8250-common-parts-Add-dynamic-thermal-profile-impl.patch
#apply_patch device/xiaomi/sm8250-common 0001-sm8250-common-parts-Fix-thermal-profile-build-for-an.patch
#apply_patch device/xiaomi/sm8250-common 0001-sm8250-common-parts-Adapt-Thermal-Parts-to-S-style.patch
#apply_patch device/xiaomi/sm8250-common 0001-sm8250-common-parts-Increase-BootCompletedReceiver-p.patch
apply_patch frameworks/base 0001-base-Introduce-PixelPropsUtils.patch
apply_patch frameworks/base 0001-PixelPropsUtils-spoof-photos.patch
apply_patch frameworks/base add_burnIn_protection.patch
apply_patch frameworks/base bring_in_drawables_for_statusbar_icon_toggles.patch
apply_patch packages/apps/LineageParts add_option_to_always_disable_USB_gadgets.patch
apply_patch packages/apps/Updater add_support_for_local_updates.patch
apply_patch packages/overlays/Lineage dynamically_add_additional_fonts.patch
apply_patch vendor/lineage add_script_for_dynamically_adding_fonts.patch
apply_patch vendor/lineage 0001-add-pixel-config.patch

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
    repopick 318741 331246 331247 331248
    repopick 331131 330511 331272 331273
    repopick 331404

    # android_device_xiaomi_alioth
    repopick 331274

    # android_frameworks_base
    #repopick 320714 329326
    repopick 330940 331389 331390 331391 331392 331393

    # android_packages_apps_LineageParts
    #repopick 326739

    # android_packages_apps_Trebuchet
    #repopick 330789

    # android_packages_apps_Settings
    repopick 331382

    # android_packages_apps_Updater
    #repopick 323341

    # android_packages_overlays_Lineage
    #repopick -f 330450
    repopick 331383

    # android_vendor_lineage
    #repopick -f 330449
    repopick 331362 331384

    echo "Nothing to repopick here"
fi
