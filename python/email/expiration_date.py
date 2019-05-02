import requests
import os
import re
import json
import bs4
from bs4 import BeautifulSoup
from dotenv import load_dotenv
from datetime import datetime

project_folder = os.path.expanduser('/home/slackbot')
load_dotenv(os.path.join(project_folder, '.env'))

FMT = '%m/%d/%Y'

def bitbucket_expiration_date():
        r = requests.get('https://example.com/bitbucket/admin/license',
        auth=(os.environ.get("LOGIN"),os.environ.get("PASSWORD")))

        soup = bs4.BeautifulSoup(r.text, 'lxml')
        date = soup.find("time")["title"]
        today = datetime.today().strftime('%m/%d/%Y')

        convert_to_date=datetime.strptime(date,'%d %B %Y %H:%M %p')
        license_expiration=datetime.strftime(convert_to_date,'%m/%d/%Y')

        delta = datetime.strptime(license_expiration, FMT) - datetime.strptime(today, FMT)
        return delta.days
def jira_expiration_date():
        r = requests.get('https://example.com/jira/rest/plugins/applications/1.0/installed/jira-software/license',
        auth=(os.environ.get("LOGIN"),os.environ.get("PASSWORD")))

        data = r.json()
        date = (data["expiryDateString"])

        today = datetime.today().strftime('%m/%d/%Y')

        convert_to_date=datetime.strptime(date,'%m/%d/%y')
        license_expiration=datetime.strftime(convert_to_date,'%m/%d/%Y')

        delta = datetime.strptime(license_expiration,FMT) - datetime.strptime(today,FMT)
        return delta.days
