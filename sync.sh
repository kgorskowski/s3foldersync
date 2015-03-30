#!/bin/sh -e
LOGFILE='var/log/s3sync.log'
logg () {
        echo -n `date +%Y%m%d%H%S` >> $LOGFILE
        echo "`basename $0`$1" >> $LOGFILE
}
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$S3_SOURCE" ] || [ -z "$S3_DESTINATION" ] || [ -z "$SRC_REGION" ] || [ -z "$DEST_REGION" ] ; then
  echo "Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, S3_SOURCE Bucket and SRC_REGION and S3_DESTINATION Bucket and DEST_REGION in env vars" 1>&2
  exit 1
fi
logg " started"
echo "Content of Source" $(aws s3 ls s3://$S3_SOURCE --human-readable --region $SRC_REGION) >> $LOGFILE
echo "Content of Destination" $(aws s3 ls s3://$S3_DESTINATION --human-readable --region $DEST_REGION) >> $LOGFILE

do_sync () {
        aws s3 sync --delete s3://$S3_SOURCE s3://$S3_DESTINATION --delete --source-region $SRC_REGION --region $DEST_REGION
}
if [ -z "$INTERVAL" ]; then
  # Run once
  do_sync >> $LOGFILE
else
  # Loop every $INTERVAL seconds
  while true; do
    s=`date +'%s'`

    do_sync >> $LOGFILE

    sleep $(( $INTERVAL - (`date +'%s'` - $s) ))
  done
fi
logg " ended"
