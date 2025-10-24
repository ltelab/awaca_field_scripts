#!/bin/bash
umask 002

# script to simplify copying basta files. This one is just for my laptop to ltesrv4, could adjust with ssh multiplexing for copying from spirit to ltesrv4

REMOTE='lteuser@ltesrv4.epfl.ch'

LOCAL_BASE='/home/corden/Downloads/BASTA_D17_25m/'

: ' #this is how to comment multiple lines
for site in d17 d47 d85 dmc; do
	for level in L1 L0; do
		for res in 12m5 25m 100m; do
			while read -r FILE; do
    				# Extract date from filename
    				BASENAME=$(basename "$FILE")               # quicklook_YYYYMMDD.png
    				DATE=${BASENAME: -18:8}                        # YYYYMMDD
    				YEAR=${DATE:0:4}
    				MONTH=${DATE:4:2}
    				DAY=${DATE:6:2}

    				# Construct remote path
    				REMOTE_PATH="/t5500/awaca/raid/$site/basta/data/$level/$res/$YEAR/$MONTH/$DAY/"
    
    				echo "Processing: $FILE"
    				echo "Remote path: $REMOTE:$REMOTE_PATH"

    				# Use rsync to copy single file to (new) remote directory
    				ssh -n $REMOTE "mkdir -p $REMOTE_PATH" #the n tells ssh not to read from stdin, apparently required in loops
    				rsync -az "$FILE" "$REMOTE":"$REMOTE_PATH"
			done < <(find "$LOCAL_BASE/${site^^}/$level/$res/" -type f -name "BASTA*.nc") # this uses process subsitution, not sure if it is 
		done
	done
done			
'	
	
			
for site in d17; do
	for level in L1; do
		for res in 25m; do
			while read -r FILE; do
    				# Extract date from filename
    				BASENAME=$(basename "$FILE")               # quicklook_YYYYMMDD.png
    				DATE=${BASENAME: -18:8}                        # YYYYMMDD
    				YEAR=${DATE:0:4}
    				MONTH=${DATE:4:2}
    				DAY=${DATE:6:2}

    				# Construct remote path
    				REMOTE_PATH="/t5500/awaca/raid/$site/basta/data/$level/$res/$YEAR/$MONTH/$DAY/"
    
    				echo "Processing: $FILE"
    				echo "Remote path: $REMOTE:$REMOTE_PATH"

    				# Use rsync to copy single file to (new) remote directory
    				ssh -n $REMOTE "mkdir -p $REMOTE_PATH" #the n tells ssh not to read from stdin, apparently required in loops
    				rsync -az "$FILE" "$REMOTE":"$REMOTE_PATH"
			done < <(find "$LOCAL_BASE/" -type f -name "*.nc") # this uses process subsitution, not sure if it is 
		done
	done
done			


