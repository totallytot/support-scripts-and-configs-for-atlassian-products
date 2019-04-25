#!/bin/bash
D=`date +%Y-%m-%d_%H-%M-%S`
########
BACKUP_DIR="/s3/eazybi"
DB="eazybi_jira"
########
mkdir $BACKUP_DIR/db
pg_dump --host 127.0.0.1 --port 5432 --username postgres -vFc $DB > $BACKUP_DIR/db/$D-eazybi.psql
tar -czvpf $BACKUP_DIR/$D-eazybi.psql.tar.gz $BACKUP_DIR/db/$D-eazybi.psql
rm -rf $BACKUP_DIR/db
