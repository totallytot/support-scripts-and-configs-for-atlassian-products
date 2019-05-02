#!/bin/bash
set -e
#AWS CLI should be configured
AWS_BUCKET="PATH_TO_BUCKET"
DUMP_OBJECT=$1
DIR="/home/db"
DB_USER="confluenceuser"

echo "Postgres restore from s3 – looking for dump in s3 "
if [ -n “${DUMP_OBJECT}” ]; then
objectSet=$(aws s3 ls s3://${AWS_BUCKET}/ --recursive| sort | tail -n 1 | awk '{print $4 }')
if [ -z “$objectSet” ]; then
echo "Backup file not found in s3 bucket"
else
echo "Downloading dump from s3 – $object"
aws s3 cp s3://amway-amer-atlassian-backup/$objectSet ${DIR}/${DUMP_OBJECT}
dbName=$(echo $objectSet | awk -F / '{print $4 }'| awk -F . '{print $1 }')
echo "dropping old database $dbName"
dbPgOwner=$(echo "SELECT r.rolname FROM pg_catalog.pg_database d JOIN pg_catalog.pg_roles r ON d.datdba = r.oid JOIN pg_catalog.pg_tablespace t on d.dattablespace = t.oid WHERE d.datname= '$dbName';"| psql 2>&1)
echo $dbPgOwner
dbOwner=$(echo $dbPgOwner | awk '{print $3 }')
echo $dbOwner
dbPgTblspc=$(echo "SELECT t.spcname FROM pg_catalog.pg_database d JOIN pg_catalog.pg_roles r ON d.datdba = r.oid JOIN pg_catalog.pg_tablespace t on d.dattablespace= t.oid WHERE d.datname= '$dbName';"| psql 2>&1)
echo $dbPgTblspc
dbTblspc=$(echo $dbPgTblspc | awk '{print $3 }')
echo $dbTblspc
PRE_RESTORE_PSQL="GRANT ALL PRIVILEGES ON DATABASE $dbName to $DB_USER; REVOKE connect ON DATABASE $dbName FROM PUBLIC;"
echo $PRE_RESTORE_PSQL
dropResult=$(echo "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$dbName' AND pid <> pg_backend_pid(); DROP DATABASE $dbName;" | psql 2>&1)
echo $dropResult
if echo $dropResult | grep "other session using the database" -> /dev/null; then
echo "RESTORE FAILED – another database session is preventing drop of database $dbName"
exit 1
fi
createResult=$(echo "CREATE DATABASE $dbName OWNER $dbOwner tablespace = $dbTblspc;" | psql 2>&1)
echo $createResult
echo "postgres restore from s3 – filling target database with dump"
if [ -n "$PRE_RESTORE_PSQL" ]; then
echo "postgres restore from s3 – executing pre-restore psql"
printf %s "$PRE_RESTORE_PSQL" | psql
fi
psql -U $dbOwner -d $dbName < /home/db/$dbName.sql
fi
echo "Postgres restore from s3 – complete – $DUMP_OBJECT $dbName"
else
echo "Please pass the backup dump file name as script argument"
fi
