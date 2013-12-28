#!/bin/bash
# ------------------------------------------------------------------------------
set -e # Exit script immediately on first error.

PATHNAME=$(cd `dirname $0` && pwd)

# Items
ITEMS=(411 482 484)

# Check on "kansai-akiya" website
for ITEM in "${ITEMS[@]}"
do
	if [ ! -f "/tmp/${ITEM}.current" ]; then
	    touch "/tmp/${ITEM}.current"
	fi
	
	# Backup previous hash
	cp "/tmp/${ITEM}.current" "/tmp/${ITEM}.history"

	# Download latest data
	ROOT="http://www.ur-net.go.jp/kansai-akiya/xml_room"
	curl -s "${ROOT}/${ITEM}0.json" | md5sum | cut -c 1-32 > "/tmp/${ITEM}.current"

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

# Check on SUMAI website
for ITEM in "${ITEMS[@]}"
do
	if [ ! -f "/tmp/${ITEM}_sumai.current" ]; then
	    touch "/tmp/${ITEM}_sumai.current"
	fi
	
	# Backup previous count
	cp "/tmp/${ITEM}_sumai.current" "/tmp/${ITEM}_sumai.history"

	# Check for available apartments
	${PATHNAME}/scan.js ${ITEM} > "/tmp/${ITEM}_sumai.current"

	# Check for data changes
	if ! diff "/tmp/${ITEM}_sumai.current" "/tmp/${ITEM}_sumai.history" >/dev/null
	then
		# Files have changed. Send email:
		ADDRESS="mail@example.com"
		SUBJECT="[UR-SUMAI] Reservation available in ${ITEM}"
		CONTENT="Check http://lab.karida.de/urscan/ for details."
		(echo ${CONTENT}) | mailx -s "${SUBJECT}" ${ADDRESS}
	fi
done
