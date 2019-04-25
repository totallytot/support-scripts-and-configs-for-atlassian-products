#!/bin/bash
D=`date +%Y-%m-%d_%H-%M-%S`
########
BACK_DIR_J="/s3/jira"
DIR_JIRA="/opt/atlassian/jira"
DIR_J_HOME="/var/atlassian/application-data/jira"
########
mkdir $BACK_DIR_J/db
pg_dump --host 127.0.0.1 --port 5432 --username postgres --format=c --blobs --quote-all-identifiers --verbose --file /$BACK_DIR_J/db/$D-jira.psql jiradb
tar -czvpf $BACK_DIR_J/$D-jira.psql.tar.gz $BACK_DIR_J/db/$D-jira.psql
tar -czvpf $BACK_DIR_J/$D-Jira-home.tar.gz $DIR_J_HOME \
--exclude=/var/atlassian/application-data/jira/log \
--exclude=/var/atlassian/application-data/jira/analytics-logs \
--exclude=/var/atlassian/application-data/jira/tmp \
--exclude=/var/atlassian/application-data/jira/export \
--exclude=/var/atlassian/application-data/jira/import \
--exclude=/var/atlassian/application-data/jira/plugins/.osgi-plugins \
--exclude=/var/atlassian/application-data/jira/plugins/.bundled-plugins
tar -czvpf $BACK_DIR_J/$D-Jira-opt.tar.gz $DIR_JIRA \
--exclude=/opt/atlassian/jira/logs \
--exclude=/opt/atlassian/jira/temp \
--exclude=/opt/atlassian/jira/work
rm -rf $BACK_DIR_J/db
