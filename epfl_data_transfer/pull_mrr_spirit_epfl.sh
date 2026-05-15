#!/bin/bash
umask 002
set -euo pipefail

trap 'echo "Stopping..."; kill 0' INT TERM

REMOTE='spiritx1' # the ssh link config is in the .ssh/config file

# Start a multiplexed SSH master connection in the background
ssh -MNf $REMOTE

site="d47"

REMOTE_BASE="/mnt/proj1x/AWACA/TRANSECT/_HDD2025/${site^^}/mrr/mrr"
LOCAL_BASE="/awaca/raid/${site}/mrr/data"
echo "$REMOTE_BASE"

ssh $REMOTE \
  "find '${REMOTE_BASE}' -mindepth 2 -maxdepth 2 -type d | sort" |
while read -r REMOTE_DIR; do

    DAY=$(basename "$REMOTE_DIR")          # YYYYMMDD
    YEAR=${DAY:0:4}
    MONTH=${DAY:4:2}
    DAYNUM=${DAY:6:2}

    LOCAL_DIR="${LOCAL_BASE}/${YEAR}/${MONTH}/${DAYNUM}"

    mkdir -p "$LOCAL_DIR"

    echo "Syncing $REMOTE_DIR -> $LOCAL_DIR" 

    rsync -av "$REMOTE":"$REMOTE_DIR/" "${LOCAL_DIR}/"

done

# Close the master SSH connection
ssh -O exit $REMOTE


