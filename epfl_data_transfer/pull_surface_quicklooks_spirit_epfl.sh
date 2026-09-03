#!/bin/bash

# script to sync the surface weather station quiclooks made by Lea Raillard to EPFL
# to avoid connection limits, ssh multiplexing is used

# the following lines are required in .ssh/config (as lteuser on ltesrv5)
#Host spiritx1
#    HostName spiritx1.ipsl.fr
#    User hcorden
#    IdentityFile ~/.ssh/id_ed25519_spirit
#    ControlMaster auto
#    ControlPath ~/.ssh/cm-%r@%h:%p
#    ControlPersist 10m



# Heather Corden 3.9.2026


umask 002

REMOTE='spiritx1' # the ssh link config is in the .ssh/config file

dt=$(date '+%Y/%m/%d %H:%M:%S');

echo "$dt Pulling quicklooks from spirit to ltesrv2"

# Start a multiplexed SSH master connection in the background
ssh -MNf $REMOTE

for site in d17 d47 d85 dmc; do
	rsync -rva $REMOTE:/data/lraillard/Postdoc_EPFL/QUICKLOOKS/QUICKLOOKS_SURF/$site/ /awaca/raid/$site/awacasurf/quicklooks/ 
done

# Close the master SSH connection
ssh -O exit $REMOTE
