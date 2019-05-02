import requests
import os
import re
import json
import bs4
import expiration_date
from dotenv import load_dotenv
from datetime import datetime

#export credential from file
project_folder = os.path.expanduser('/home/slackbot')
load_dotenv(os.path.join(project_folder, '.env'))

FMT = '%m/%d/%Y'
payload = {'text': "Atlassian Applications Licenses will expire in: {} days".format(expiration_date.jira_expiration_date()) }

def expiration_date():
        r = requests.get('https://example.com/jira/rest/plugins/applications/1.0/installed/jira-software/license',
        auth=(os.environ.get("LOGIN"),os.environ.get("PASSWORD")))

        data = r.json()
        date = (data["expiryDateString"])

        today = datetime.today().strftime('%m/%d/%Y')

        convert_to_date=datetime.strptime(date,'%m/%d/%y')
        license_expiration=datetime.strftime(convert_to_date,'%m/%d/%Y')

        delta = datetime.strptime(license_expiration,FMT) - datetime.strptime(today,FMT)
        if delta.days == 90 or delta.days == 180 or delta.days == 60 or delta.days <=30:
                r = requests.post("SLACK_INCOMMING_WEBHOOK", data=payload)
jira_expiration_date()
