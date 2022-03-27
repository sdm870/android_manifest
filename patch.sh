#!/bin/bash

. build/envsetup.sh

PATCH_DIR=${PWD}

echo "TOP: $PATCH_DIR"

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

function apply_patch {
    echo -e "${GREEN}Applying patch...${NOCOLOR}"
    echo -e "${LIGHTBLUE}Target repo:${NOCOLOR} $1"
    echo -e "${LIGHTBLUE}Patch file:${NOCOLOR} $2"
    echo ""

    cd $1
    git am -3 --ignore-whitespace $2
    cd $PATCH_DIR
    echo ""
}

#################################################################
# CHERRYPICKS                                                   #
#                                                               #
# Examples:                                                     #
# repopick [CHANGE_NUMBER]                                      #
#################################################################

# android_device_xiaomi_sm8250-common
repopick -f 326561
repopick 326578 326708 326709 326999

# android_hardware_lineage_interfaces
repopick 322575

# android_hardware_xiaomi
repopick 323135 327376

# android_device_lineage_sepolicy
repopick 322576

# android_kernel_xiaomi_sm8250
repopick 314802

#################################################################
# PATCHES
#
# Example: apply_patch [REPO_DIR] [PATCH_FILE]
#################################################################

