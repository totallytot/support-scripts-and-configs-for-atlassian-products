#!/bin/bash

##### remove date if you use versions in s3
BACKUP_DATE=`date +%Y-%m-%d_%H-%M-%S`
DIR_JIRA="/opt/atlassian/jira"
DIR_JIRA_HOME="/var/atlassian/application-data/jira"
S3_BUCKET="s3://test"
# if tar is more than 5 GB. Use GB.
EXPECTED_SIZE=100
#####
tar -czf - $DIR_JIRA $DIR_JIRA_HOME \
--exclude=$DIR_JIRA/jre/lib/management/jmxremote.password \
--exclude=$DIR_JIRA/temp \
--exclude=$DIR_JIRA/logs \
--exclude=$DIR_JIRA/work \
--exclude=$DIR_JIRA_HOME/log \
--exclude=$DIR_JIRA_HOME/analytics-logs \
--exclude=$DIR_JIRA_HOME/tmp \
--exclude=$DIR_JIRA_HOME/export \
--exclude=$DIR_JIRA_HOME/import \
--exclude=$DIR_JIRA_HOME/plugins/.osgi-plugins \
--exclude=$DIR_JIRA_HOME/plugins/.bundled-plugins | \
aws s3 cp --expected-size=$((1024*1024*1024*$EXPECTED_SIZE)) - $S3_BUCKET/jira/jira_backup_$BACKUP_DATE.tar.gz
