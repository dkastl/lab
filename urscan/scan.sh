#!/bin/bash
# ------------------------------------------------------------------------------
set -e # Exit script immediately on first error.

# Items
ITEMS=(4110 4820 4840)

for ITEM in "${ITEMS[@]}"
do
	if [ ! -f "/tmp/${ITEM}.current" ]; then
	    touch "/tmp/${ITEM}.current"
	fi
	
	# Backup previous hash
	cp "/tmp/${ITEM}.current" "/tmp/${ITEM}.history"

	# Download latest data
	ROOT="http://www.ur-net.go.jp/kansai-akiya/xml_room"
	curl -s "${ROOT}/${ITEM}.json" | md5sum | cut -c 1-32 > "/tmp/${ITEM}.current"

	# Check for data changes
	if ! diff "/tmp/${ITEM}.current" "/tmp/${ITEM}.history" >/dev/null
	then
		# Files have changed. Send email:
		ADDRESS="mail@example.com"
		SUBJECT="[UR-Scan] Update detected in ${ITEM}"
		CONTENT="Check http://lab.karida.de/urscan/ for details."
		(echo ${CONTENT}) | mailx -s "${SUBJECT}" ${ADDRESS}
	fi
done
