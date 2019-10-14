#!/bin/bash

##### remove date if you use versions in s3
BACKUP_DATE=`date +%Y-%m-%d_%H-%M-%S`
DIR_FISHEYE="/opt/atlassian/fisheye"
DIR_FISHEYE_INST="/var/atlassian/application-data/fisheye"
S3_BUCKET="s3://atlassian-temp"
#####
tar -czf - $DIR_FISHEYE $DIR_FISHEYE_INST \
--exclude=$DIR_FISHEYE_INST/analytics-logs \
--exclude=$DIR_FISHEYE_INST/var/tmp \
--exclude=$DIR_FISHEYE_INST/var/log | \
aws s3 cp - $S3_BUCKET/fishapp01/fisheye_backup_$BACKUP_DATE.tar.gz
