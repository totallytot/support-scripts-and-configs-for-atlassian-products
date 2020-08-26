#!/bin/bash

rsync -avzhe ssh \
--progress \
--exclude 'plugins/.osgi-plugins' \
--exclude 'export' \
--exclude 'analytics-logs' \
--exclude 'import' \
--exclude 'log' \
--exclude 'tmp' \
--exclude 'plugins/.bundled-plugins' \
--exclude 'dbconfig.xml' \
user@10.1.255.121:/home/apps/jira/jira_home/ \
/var/atlassian/application-data/jira/ \
&& sudo chown jira:jira -R /var/atlassian/application-data/jira/ \
&& sudo chmod g+rwx -R /var/atlassian/application-data/jira/
