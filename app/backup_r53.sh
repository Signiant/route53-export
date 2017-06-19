#!/bin/bash

PATH=$PATH:/app:/usr/local/bin:/usr/bin
BUCKET=$1

saveDirectory=/tmp/r53backup

log () {
        echo $1
}

if [ $# -ne 1 ]; then
  log "You must provide an S3 path as the argument (ie. s3://mybucket/mykey)"
  exit 1
fi

if [ -z "${BUCKET}" ]; then
  log "You must provide an S3 path as the argument (ie. s3://mybucket/mykey)"
  exit 1
else
  log "Syncing to bucket ${BUCKET}"
fi

if [[ ! -d "${saveDirectory}" ]]; then {
	mkdir -p "${saveDirectory}"
} fi

log "Obtaining zone list"
zones=$(/app/cli53 list |grep -v "Record count" |awk '{print $2}')
log "Zone list is $zones"

if [ -z "$zones" ]; then
  log "FATAL ERROR: No Route53 zones found to export"
  exit 2
fi

IFS="
"

date=$(date +%Y/%m/%d/%H_%M)
mkdir -p $saveDirectory/${date}

for zone in $zones ; do {
        log "Downloading $zone"
        cli53 export $zone > $saveDirectory/${date}/${zone}db
} done

if [ -n "$BUCKET" ]; then {
	log "Syncing to S3 bucket $BUCKET"
	aws s3 sync $saveDirectory $BUCKET
	rm -rf $saveDirectory
}; fi
