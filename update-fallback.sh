#!/usr/bin/bash

logger "gudbootie: Oh yeahhh, guuud bootie!"
logger "gudbootie: Saving current kernel (+modules, DKMS) as fallback"

FALLBACK_NAME=gudbootie

KERNEL_VERSION=$(uname -r)
KERNEL_PATH=$(fd --type file --extension efi $KERNEL_VERSION /)
KERNEL_DIR=$(dirname $KERNEL_PATH)

# Check if running kernel is already copied as the fallback
FALLBACK_PATH=$KERNEL_DIR/${FALLBACK_NAME}.efi
logger "gudbootie: FALLBACK_PATH : $FALLBACK_PATH"

if [[ -f $FALLBACK_PATH ]]; then
   KERNEL_HASH=$(xxhsum $KERNEL_PATH | awk '{print $1}')
   FALLBACK_HASH=$(xxhsum $FALLBACK_PATH | awk '{print $1}')
   logger "gudbootie: KERNEL_HASH   : $KERNEL_HASH"
   logger "gudbootie: NÖHNGÜD_HASH  : $FALLBACK_HASH"
   if [[ $KERNEL_HASH == $FALLBACK_HASH ]]; then
      logger "gudbootie: Fallback already exists and is up-to-date; nothing to do"
      exit 0
   fi
else
   logger "gudbootie: No Fallback exists, skipping hash check"
fi

MODULES_DIR=$(fd --type directory $KERNEL_VERSION / | grep modules)
DKMS_DIRS=$(fd --type directory $KERNEL_VERSION / | grep dkms)
logger "gudbootie: KERNEL_PATH : $KERNEL_PATH"
logger "gudbootie: KERNEL_DIR  : $KERNEL_DIR"
logger "gudbootie: MODULES_DIR : $MODULES_DIR"
logger "gudbootie: DKMS_DIRS   :"
for D in $DKMS_DIRS; do
   logger "gudbootie:  - $D"
done

FALLBACK_MODULES_DIR=$(dirname $MODULES_DIR)/${FALLBACK_NAME}
logger "gudbootie: FALLBACK_MODULES_DIR : $FALLBACK_MODULES_DIR"

# Clear previous fallback files, moving them to /tmp on the off chance they are wanted for anything before next boot
TMP_DIR=$(mktemp -d)
logger "gudbootie: TMP_DIR : $TMP_DIR"
mv $FALLBACK_PATH $TMP_DIR/
mv $FALLBACK_MODULES_DIR $TMP_DIR/
for D in $DKMS_DIRS; do
   mv $(dirname $D)/${FALLBACK_NAME} $TMP_DIR/
done

# Copy running kernel (& modules, DKMS) as new fallback
cp $KERNEL_PATH $FALLBACK_PATH
cp -r $MODULES_DIR $FALLBACK_MODULES_DIR
for D in $DKMS_DIRS; do
   logger $(dirname $D)
   logger "gudbootie: Copying DKMS dir $D to $(dirname $D)/${FALLBACK_NAME}"
   cp -r $D $(dirname $D)/${FALLBACK_NAME}
done

