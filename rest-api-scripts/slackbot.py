#Bot created for monitoring active Atlassian Licenses by typing simple commands.
#Bot created according to this article: https://www.fullstackpython.com/blog/build-first-slack-bot-python.html
#!Important
#Don't forget to export SLACK_BOT_TOKEN and change URLs with credentials.
#Python version 2.7
#May the force be with you


import requests
import os
import time
import re
import logging
import json
logging.basicConfig()
import bs4
from bs4 import BeautifulSoup

from slackclient import SlackClient
import ssl

if hasattr(ssl, '_create_unverified_context'):
    ssl._create_default_https_context = ssl._create_unverified_context

# instantiate Slack client
slack_client = SlackClient(os.environ.get('SLACK_BOT_TOKEN'))
# starterbot's user ID in Slack: value is assigned after the bot starts up
starterbot_id = None

# constants
RTM_READ_DELAY = 1 # 1 second delay between reading from RTM
LICENSE  = 'bitbucket license', 'jira-software license', 'jira-service-deck license', 'confluence license'
MENTION_REGEX = "^<@(|[WU].+?)>(.*)"
USERNAME = "User"
PASSWORD = "Password"




#curl parsing

response = requests.get('https://example.com/bitbucket/rest/api/1.0/users?permission=LICENSED_USER&limit=1000', auth=(USERNAME, PASSWORD))
data = response.json()
BITBUCKET_LICENSE = (data["size"])

response = requests.get('https://example.com/jira/rest/api/2/applicationrole', auth=(USERNAME, PASSWORD))
data = response.json()
JIRA_SOFTWARE_LICENSE =  data[1]["userCount"]

response = requests.get('https://example.com/jira/rest/api/2/applicationrole', auth=(USERNAME, PASSWORD))
data = response.json()
JIRA_SD_LICENSE =  data[0]["userCount"]

r = requests.get('https://example.com/confluence/dosearchsite.action?cql=type+%3D+%22user%22', auth=(USERNAME, PASSWORD))
soup = bs4.BeautifulSoup(r.text, 'lxml')
CONFLUENCE_LICENSE = soup.find("p")['data-totalsize']


def parse_bot_commands(slack_events):
    """
        Parses a list of events coming from the Slack RTM API to find bot commands.
        If a bot command is found, this function returns a tuple of command and channel.
        If its not found, then this function returns None, None.
    """
    for event in slack_events:
        if event["type"] == "message" and not "subtype" in event:
            user_id, message = parse_direct_mention(event["text"])
            if user_id == starterbot_id:
                return message, event["channel"]
    return None, None

def parse_direct_mention(message_text):
    """
        Finds a direct mention (a mention that is at the beginning) in message text
        and returns the user ID which was mentioned. If there is no direct mention, returns None
    """
    matches = re.search(MENTION_REGEX, message_text)
    # the first group contains the username, the second group contains the remaining message
    return (matches.group(1), matches.group(2).strip()) if matches else (None, None)

def handle_command(command, channel):
    """
        Executes bot command if the command is known
    """
    # Default response is help text for the user
    default_response = "Not sure what you mean. Try *{}*.".format(LICENSE)

    # Finds and executes the given command, filling in response
    response =  None
    # This is where you start to implement more commands!

    if command.startswith('bitbucket license'):
         response = "Count of Bitbucket licenses: {}".format(BITBUCKET_LICENSE)
    if command.startswith('jira-software license'):
         response = "Count of Jira Software licenses: {}".format(JIRA_SOFTWARE_LICENSE)
    if command.startswith('jira-software license'):
         response = "Count of Jira-Service Desk licenses: {}".format(JIRA_SD_LICENSE)
    if command.startswith('confluence license'):
         response = "Count of Confluence licenses: {}".format(CONFLUENCE_LICENSE)

    # Sends the response back to the channel
    slack_client.api_call(
        "chat.postMessage",
        channel=channel,
        text=response or default_response
    )

if __name__ == "__main__":
    if slack_client.rtm_connect(with_team_state=False):
        print("Starter Bot connected and running!")
        # Read bot's user ID by calling Web API method `auth.test`
        starterbot_id = slack_client.api_call("auth.test")["user_id"]
        while True:
            command, channel = parse_bot_commands(slack_client.rtm_read())
            if command:
                handle_command(command, channel)
            time.sleep(RTM_READ_DELAY)
    else:
        print("Connection failed. Exception traceback printed above.")
