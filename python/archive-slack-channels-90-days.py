import requests
import json
from datetime import datetime

response = requests.get('https://slack.com/api/channels.list?token=xoxb-xxxxx-xxxxxxx-xxxxxx&pretty=1')
data = response.json()
for data2 in data["channels"]:
        payload = data2["id"]
        print "%s"%(payload)
        r= requests.get("https://slack.com/api/channels.history?token=xoxp-xxxxxx-xxxxxx-xxxxxx-xxxxxxx&channel=%s&count=1&pretty=1"%(payload))
        history = r.json()
        ts = float(history["messages"][0]["ts"])
        today = datetime.today()
        s = (today - datetime.utcfromtimestamp(ts)).days
        if s >= 90:
                r= requests.post("https://slack.com/api/channels.archive?token=xoxp-xxxxxx-xxxxxx-xxxxxx-xxxxx&channel=%s&pretty=1 "%(payload))
                print r.json()
