#!/bin/bash

# script to push quicklooks from epfl to the spirit servers in Paris using rsync
# ATTENTION: parts of the local and remote paths are hard-written in the rsync command for simplicity, will need changing if the paths change

# the rsync is very simple for most instruments as the same folder structure is used YYYY/MM/DD
# for wprof, the date subfolders have to be introduced

# to avoid connection limits, ssh multiplexing is used

# the following lines are required in .ssh/config (as lteuser on ltesrv5)
#Host spiritx1
#    HostName spiritx1.ipsl.fr
#    User hcorden
#    IdentityFile ~/.ssh/id_ed25519_spirit
#    ControlMaster auto
#    ControlPath ~/.ssh/cm-%r@%h:%p
#    ControlPersist 10m



# Heather Corden 16.7.2025


umask 002

REMOTE='spiritx1' # the ssh link config is in the .ssh/config file

dt=$(date '+%Y/%m/%d %H:%M:%S');

echo "$dt Pushing quicklooks from ltesrv5 to spirit"

# Start a multiplexed SSH master connection in the background
ssh -MNf $REMOTE

# raid MIRA and MRR
for site in d17 d47 d85 dmc; do
	rsync -rva /awaca/raid/$site/mrr/quicklooks/ $REMOTE:/bdd/AWACA/QUICKLOOK/$site/mrr/
	rsync -rva /awaca/raid/$site/mira/quicklooks/ $REMOTE:/bdd/AWACA/QUICKLOOK/$site/mira/	
done

#DDU mrr
rsync -rva /awaca/ddu/mrr/quicklooks/ $REMOTE:/bdd/AWACA/QUICKLOOK/ddu/mrr/

#DDU stxpol
rsync -rva /awaca/ddu/stxpol/quicklooks/ $REMOTE:/bdd/AWACA/QUICKLOOK/ddu/stxpol/

# DDU windprof
rsync -rva /awaca/ddu/windprof/quicklooks/ $REMOTE:/bdd/AWACA/QUICKLOOK/ddu/windprof/

# DDU wprof

while read -r FILE; do
    # Extract date from filename
    BASENAME=$(basename "$FILE")               # quicklook_YYYYMMDD.png
    DATE=${BASENAME:16:8}                        # YYYYMMDD
    YEAR=${DATE:0:4}
    MONTH=${DATE:4:2}
    DAY=${DATE:6:2}

    # Construct remote path
    REMOTE_PATH="/bdd/AWACA/QUICKLOOK/ddu/wprof/$YEAR/$MONTH/$DAY/"
    
    #echo "Processing: $FILE"
    #echo "Remote path: $REMOTE:$REMOTE_PATH"

    # Use rsync to copy single file to (new) remote directory
    ssh -n $REMOTE "mkdir -p $REMOTE_PATH" #the n tells ssh not to read from stdin, apparently required in loops
    rsync -az "$FILE" "$REMOTE":"$REMOTE_PATH"
done < <(find /awaca/ddu/wprof/quicklooks/ -type f -name "WProf_quicklook_*.png") # this uses process subsitution, not sure if it is really required or not

# Close the master SSH connection
ssh -O exit $REMOTE
