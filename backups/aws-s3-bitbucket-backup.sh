#!/bin/bash

##### remove date if you use versions in s3
BACKUP_DATE=`date +%Y-%m-%d_%H-%M-%S`
DIR_CONFLUENCE="/opt/atlassian/confluence"
DIR_CONFLUENCE_HOME="/var/atlassian/application-data/confluence"
S3_BUCKET="s3://adc-aws-atlassian-temp"
#####
tar -czf - $DIR_CONFLUENCE $DIR_CONFLUENCE_HOME \
--exclude=$DIR_CONFLUENCE/jre/lib/management/jmxremote.password \
--exclude=$DIR_CONFLUENCE/temp \
--exclude=$DIR_CONFLUENCE/logs \
--exclude=$DIR_CONFLUENCE/work \
--exclude=$DIR_CONFLUENCE_HOME/logs \
--exclude=$DIR_CONFLUENCE_HOME/analytics-logs \
--exclude=$DIR_CONFLUENCE_HOME/temp \
--exclude=$DIR_CONFLUENCE_HOME/webresource-temp \
--exclude=$DIR_CONFLUENCE_HOME/restore \
--exclude=$DIR_CONFLUENCE_HOME/export \
--exclude=$DIR_CONFLUENCE_HOME/restore | \
aws s3 cp - $S3_BUCKET/confapp01/confluence_backup_$BACKUP_DATE.tar.gz
