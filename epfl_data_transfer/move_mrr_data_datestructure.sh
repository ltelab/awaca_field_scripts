#!/bin/bash
umask 002
set -euo pipefail

trap 'echo "Stopping..."; kill 0' INT TERM

# script to move mrr data between metek date subfolders and YYYY/MM/DD subfolders
# on the same server (no ssh)

site="d47"

SOURCE_BASE="/mnt/proj1x/AWACA/TRANSECT/_HDD2025/${site^^}/mrr/mrr"
TARGET_BASE="/mnt/proj1x/AWACA/TRANSECT/mrr/${site}/"


# Source structure:
#   SOURCE_BASE/YYYYMM/YYYYMMDD/files...
#
# Target structure:
#   TARGET_BASE/YYYY/MM/DD/files...

echo "Source: $SOURCE_BASE"
echo "Target: $TARGET_BASE"

find "$SOURCE_BASE" -mindepth 2 -maxdepth 2 -type d | sort |
while read -r SOURCE_DIR; do

    DAY=$(basename "$SOURCE_DIR")   # YYYYMMDD

    YEAR=${DAY:0:4}
    MONTH=${DAY:4:2}
    DAYNUM=${DAY:6:2}

    TARGET_DIR="${TARGET_BASE}/${YEAR}/${MONTH}/${DAYNUM}"

    mkdir -p "$TARGET_DIR"

    echo "Syncing:"
    echo "  $SOURCE_DIR"
    echo "  -> $TARGET_DIR"

    rsync -av "$SOURCE_DIR/" "$TARGET_DIR/"

done

