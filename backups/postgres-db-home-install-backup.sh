#!/bin/bash
D=`date +%Y-%m-%d_%H-%M-%S`
########
BACK_DIR_J="/s3"
DIR_JIRA="/opt/atlassian/jira"
DIR_J_HOME="/var/atlassian/application-data/jira"
########
mkdir $BACK_DIR_J/db
pg_dump --host 127.0.0.1 --port 5432 --username postgres --format=c --blobs --quote-all-identifiers --verbose --file /$BACK_DIR_J/db/$D-jira.psql jira
/bin/tar -czpf $BACK_DIR_J/$D-jira.psql.tar.gz $BACK_DIR_J/db/$D-jira.psql
/bin/tar --exclude=/opt/application-data/jira/log --exclude=/opt/application-data/jira/plugins/.osgi-plugins -czpf $BACK_DIR_J/$D-Jira-home.tar.gz $DIR_J_HOME
/bin/tar --exclude=/opt/jira/logs --exclude=/opt/jira/temp -czpf $BACK_DIR_J/$D-Jira-opt.tar.gz $DIR_JIRA
/bin/rm -rf $BACK_DIR_J/db/*
/bin/rm -rf $BACK_DIR_J/db
