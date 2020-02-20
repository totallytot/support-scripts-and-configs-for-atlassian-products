### not a script yet, just a flow for manual actions ###

# create db dump in prod
ssh centos@10.40.2.229
mysqldump -u root -p jira > jira.dump
exit

# move db dump to staging
sftp centos@10.40.2.229
get jira.dump
exit

# stop Jira staging app
sudo service jira stop

# recreate database
mysql -u root -pjh12yMm2! -e "drop database jira"
mysql -u root -pjh12yMm2! -e "create database jira character set utf8mb4 collate utf8mb4_bin"

# restore db dump
mysql -u root -pjh12yMm2! jira < jira.dump

# grant rights
mysql -u root -pjh12yMm2! -e "grant all privileges on jira.* to 'jira'@'localhost'"
mysql -u root -pjh12yMm2! -e "flush privileges"

# remove not required data
mysql -u root -pjh12yMm2! jira -e "truncate table mailserver"
mysql -u root -pjh12yMm2! jira -e "truncate table serviceconfig"
mysql -u root -pjh12yMm2! jira -e "truncate table filtersubscription"

# sync data folder
sudo chown centos -R /var/atlassian/application-data/jira/
rsync -avzhO centos@10.40.2.229:/var/atlassian/application-data/jira/data/ /var/atlassian/application-data/jira/data/
sudo chown jira:jira -R /var/atlassian/application-data/jira/
sudo chmod u+rwx,g+rwx -R /var/atlassian/application-data/jira/

# clear plugin cache and remove old logs
rm -rf /var/atlassian/application-data/jira/log/*
rm -rf /var/atlassian/application-data/jira/plugins/.bundled-plugins
rm -rf /var/atlassian/application-data/jira/plugins/.osgi-plugins

# start Jira staging app
sudo service jira start

# update Jira base URL and app links
# reindex Jira
# set developer licenses for Jira and all plugins