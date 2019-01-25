#!/bin/bash
D=`date +%Y-%m-%d_%H-%M-%S`
######## Some parameters.
BACK_DIR_J="/BackupJira"
BACK_DIR_C="/BackupWiki"
#
DIR_JIRA="/opt/jira/"
DIR_J_HOME="/opt/application-data/jira/"
#
DIR_C="/opt/confluence/"
DIR_C_HOME="/opt/application-data/confluence/"
########
/bin/mkdir $BACK_DIR_J/db
pg_dump --host 127.0.0.1 --port 5432 --username postgres --format=c --blobs --quote-all-identifiers --verbose --file /BackupJira/db/$D-jira.psql jira
/bin/tar -czpf $BACK_DIR_J/$D-jira.psql.tar.gz $BACK_DIR_J/db/$D-jira.psql
/bin/tar --exclude=/opt/application-data/jira/log --exclude=/opt/application-data/jira/plugins/.osgi-plugins -czpf $BACK_DIR_J/$D-Jira-home.tar.gz $DIR_J_HOME
/bin/tar --exclude=/opt/jira/logs --exclude=/opt/jira/temp -czpf $BACK_DIR_J/$D-Jira-opt.tar.gz $DIR_JIRA
/bin/rm -rf $BACK_DIR_J/db/*
/bin/rm -rf $BACK_DIR_J/db
#######################################
/bin/mkdir $BACK_DIR_C/db
pg_dump --host 127.0.0.1 --port 5432 --username postgres --format=c --blobs --quote-all-identifiers --verbose --file /BackupWiki/db/$D-confluence.psql confluence
/bin/tar -czpf $BACK_DIR_C/$D-confluence.psql.tar.gz $BACK_DIR_C/db/$D-confluence.psql
/bin/tar --exclude=/opt/application-data/confluence/logs --exclude=/opt/application-data/confluence/plugins-osgi-cache -czpf $BACK_DIR_C/$D-confluence-opt.tar.gz $DIR_C
/bin/tar --exclude=/opt/confluence/logs --exclude=/opt/confluence/temp -czpf $BACK_DIR_C/$D-confluence-home.tar.gz $DIR_C_HOME
/bin/rm -rf $BACK_DIR_C/db/*
/bin/rm -rf $BACK_DIR_C/db
#######################################
