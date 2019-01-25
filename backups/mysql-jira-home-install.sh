#!/bin/bash
D=`date +%Y-%m-%d_%H-%M-%S`
######## Some parameters.
BACK_DIR="/s3mnt"
#
MYSQL_AUTH_J="-ujira -p"jira54jira" -hlocalhost"
MYSQL_BASE_J="jira"
DIR_JIRA="/opt/jira/"
DIR_J_HOME="/opt/application-data/jira/"
#
########
/bin/mkdir $BACK_DIR/db
/usr/bin/mysqldump $MYSQL_AUTH_J --databases $MYSQL_BASE_J > $BACK_DIR/db/$D-jira.sql
/bin/tar -czpf $BACK_DIR/$D-Jira_db.tar.gz $BACK_DIR/db/
/bin/tar --exclude=/opt/application-data/jira/log --exclude=/opt/application-data/jira/plugins/.osgi-plugins -czpf $BACK_DIR/$D-Jira-home.tar.gz $DIR_J_HOME
/bin/tar --exclude=/opt/jira/jre --exclude=/opt/jira/logs --exclude=/opt/jira/temp -czpf $BACK_DIR/$D-Jira-opt.tar.gz $DIR_JIRA
/bin/rm -rf $BACK_DIR/db/*
/bin/rm -rf $BACK_DIR/db
