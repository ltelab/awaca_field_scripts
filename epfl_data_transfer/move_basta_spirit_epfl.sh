#!/bin/bash
umask 002

# script to move basta data from the spirit server to epfl
# use ssh multiplexing to move the files to correct date-organised subfolders in the awaca directory
# Heather Corden 24/10/2025


REMOTE='spiritx1'


# Start a multiplexed SSH master connection in the background
ssh -MNf "$REMOTE"

for site in d17 d47 d85 dmc; do
    for level in L1 L0; do
        for res in 12m5 25m 100m; do
            # Find remote files matching the pattern
            ssh -n "$REMOTE" "find /homedata/ftoledo/data4heather/basta/$site/$level/$res/ -type f -name 'BASTA*.nc'" | while read -r FILE; do
                BASENAME=$(basename "$FILE")       # e.g., BASTA_YYYYMMDD_something.nc
                DATE=${BASENAME: -18:8}            # extract YYYYMMDD
                YEAR=${DATE:0:4}
                MONTH=${DATE:4:2}
                DAY=${DATE:6:2}

                LOCAL_PATH="/awaca/raid/$site/basta/data/$level/$res/$YEAR/$MONTH/$DAY/"

                echo "Processing: $FILE"
                echo "Local path: $LOCAL_PATH"

                # Create local directory
                mkdir -p "$LOCAL_PATH"

                # Pull file from remote to local
                rsync -az "$REMOTE:$FILE" "$LOCAL_PATH"
            done
        done
    done
done

ssh -O exit $REMOTE

