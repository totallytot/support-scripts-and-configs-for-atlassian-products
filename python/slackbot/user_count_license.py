import os
import requests
import json
import bs4
from bs4 import BeautifulSoup
from dotenv import load_dotenv

#export variables from .env file
project_folder = os.path.expanduser('/your_path_to_.env_file')
load_dotenv(os.path.join(project_folder, '.env'))


# curl parsing
def bitbucket_license():
        response = requests.get('https://example.com/bitbucket/rest/api/1.0/users?permission=LICENSED_USER&limit=1000',
        auth=(os.environ.get("LOGIN"),os.environ.get("PASSWORD")))
        data = response.json()
        return (data["size"])

def jira_license():
        response = requests.get('https://example.com/jira/rest/api/2/applicationrole',
        auth=(os.environ.get("LOGIN"),os.environ.get("PASSWORD")))
        data = response.json()
        return data[0]["userCount"]

def confluence_license():
        r = requests.get('https://example.com/confluence/dosearchsite.action?cql=type+%3D+%22user%22',
        auth=(os.environ.get("LOGIN"),os.environ.get("PASSWORD")))
        soup = bs4.BeautifulSoup(r.text, 'lxml')
        return soup.find("p")['data-totalsize']
