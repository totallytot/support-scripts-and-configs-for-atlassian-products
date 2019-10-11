#!/bin/bash

##### remove date if you use versions in s3
BACKUP_DATE=`date +%Y-%m-%d_%H-%M-%S`
DIR_JIRA="/opt/atlassian/jira"
DIR_JIRA_HOME="/var/atlassian/application-data/jira"
S3_BUCKET="s3://test"
#####
tar -czf - $DIR_JIRA $DIR_JIRA_HOME \
--exclude=/opt/atlassian/jira/jre/lib/management/jmxremote.password \
--exclude=/opt/atlassian/jira/temp \
--exclude=/opt/atlassian/jira/logs \
--exclude=/opt/atlassian/jira/work \
--exclude=/var/atlassian/application-data/jira/log \
--exclude=/var/atlassian/application-data/jira/analytics-logs \
--exclude=/var/atlassian/application-data/jira/tmp \
--exclude=/var/atlassian/application-data/jira/export \
--exclude=/var/atlassian/application-data/jira/import \
--exclude=/var/atlassian/application-data/jira/plugins/.osgi-plugins \
--exclude=/var/atlassian/application-data/jira/plugins/.bundled-plugins | \
aws s3 cp - $S3_BUCKET/jira/jira_backup_$BACKUP_DATE.tar.gz