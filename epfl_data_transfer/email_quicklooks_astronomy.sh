#!/bin/bash

umask 002

# a script to email MIRA Concordia quicklooks from ltesrv5 to Karim Agabi
# for cloud-context information for astronomy
# see the file email_quicklooks_setup.txt for information on how this works


# === Configuration ===
SUBJECT="Cloud radar plot - $(date -d "yesterday" +%Y-%m-%d)"
BODY="Hello,

Please find attached the MIRA cloud radar plot from the AWACA shelter at Concordia for $(date -d "yesterday" +%Y-%m-%d).

For questions please contact heather.corden@epfl.ch or alexis.berne@epfl.ch

Best wishes from Heather and the AWACA team.


"

RECIPIENTS=("heather.corden@epfl.ch" "astep-star@oca.eu")


YESTERDAY=$(date -d "yesterday" +%Y%m%d)
YEAR="${YESTERDAY:0:4}"
MONTH="${YESTERDAY:4:2}"
DAY="${YESTERDAY:6:2}"


# === Expected file patterns ===
CANDIDATE_FILES=(
    "/awaca/raid/dmc/mira/quicklooks/${YEAR}/${MONTH}/${DAY}/${YESTERDAY}_mira_zenith_day_dmc_Zg.png"
)

# === Check which files exist ===
ATTACHMENTS=()
for FILE in "${CANDIDATE_FILES[@]}"; do
    echo $FILE
    if [[ -f "$FILE" ]]; then
        ATTACHMENTS+=("$FILE")
    fi
done

# Error if no attachments found
if [ ${#ATTACHMENTS[@]} -eq 0 ]; then
    echo "No files found for $YESTERDAY."
fi

# === Build mutt command ===
CMD=(mutt -s "$SUBJECT")
for ATTACH in "${ATTACHMENTS[@]}"; do
    CMD+=(-a "$ATTACH")
done
CMD+=(-- "${RECIPIENTS[@]}")

# === Send the email ===
"${CMD[@]}" <<< "$BODY"

