import sys
import requests
import os
import re
import json
import bs4
import mailer
sys.path.insert(0, '/home/slackbot/')
import expiration_date
from bs4 import BeautifulSoup
from dotenv import load_dotenv
from datetime import datetime

project_folder = os.path.expanduser('/your_path_to_.env_file')
load_dotenv(os.path.join(project_folder, '.env'))

expiration = expiration_date.jira_expiration_date()
if expiration == 90 or expiration == 180 or expiration == 60 or expiration <=30:
        notification.send_email(expiration)
