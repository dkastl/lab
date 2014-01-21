#!/bin/bash
# ------------------------------------------------------------------------------
set -e # Exit script immediately on first error.

PATHNAME=$(cd `dirname $0` && pwd)

# Items
ITEMS=(482 411 428 429 484 499 478 415 431 442 432 441)
NAME="UR Apartment"

# Check on "kansai-akiya" website
for ITEM in "${ITEMS[@]}"
do
	if [ ! -f "/tmp/${ITEM}.current" ]; then
	    touch "/tmp/${ITEM}.current"
	fi
	
	# Get some understandable names
    case ${ITEM} in
        482) NAME="ＫＯＢＥ・岡本";;
        411) NAME="シティコート住吉本町";;
        428) NAME="フレール東芦屋町";;
        429) NAME="フレール芦屋朝日ヶ丘";;
        484) NAME="グリーンヒルズ御影";;
        499) NAME="ウェルブ六甲道４番街";;
        478) NAME="ＡＣＴＡ西宮";;
        415) NAME="ＨＡＴ神戸・灘の浜";;
        431) NAME="ＨＡＴ神戸・脇の浜";;
        442) NAME="ルゼフィール岩屋中町";;
        432) NAME="ルネシティ脇浜町";;
        441) NAME="ルネシティ脇浜町第２";;
    esac

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
		SUBJECT="[UR-Scan] Update detected in ${NAME} [${ITEM}]"
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
	
	# Get some understandable names
    case ${ITEM} in
        482) NAME="ＫＯＢＥ・岡本";;
        411) NAME="シティコート住吉本町";;
        428) NAME="フレール東芦屋町";;
        429) NAME="フレール芦屋朝日ヶ丘";;
        484) NAME="グリーンヒルズ御影";;
        499) NAME="ウェルブ六甲道４番街";;
        478) NAME="ＡＣＴＡ西宮";;
        415) NAME="ＨＡＴ神戸・灘の浜";;
        431) NAME="ＨＡＴ神戸・脇の浜";;
        442) NAME="ルゼフィール岩屋中町";;
        432) NAME="ルネシティ脇浜町";;
        441) NAME="ルネシティ脇浜町第２";;
    esac

	# Backup previous count
	cp "/tmp/${ITEM}_sumai.current" "/tmp/${ITEM}_sumai.history"

	# Check for available apartments
	${PATHNAME}/scan.js ${ITEM} > "/tmp/${ITEM}_sumai.current"

	# Check for data changes
	if ! diff "/tmp/${ITEM}_sumai.current" "/tmp/${ITEM}_sumai.history" >/dev/null
	then
		# Files have changed. Send email:
		ADDRESS="mail@example.com"
		SUBJECT="[UR-SUMAI] Reservation available in ${NAME} [${ITEM}]"
		CONTENT="Check http://lab.karida.de/urscan/ for details."
		(echo ${CONTENT}) | mailx -s "${SUBJECT}" ${ADDRESS}
	fi
done
