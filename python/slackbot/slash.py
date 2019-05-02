from flask import Flask,render_template
from flask import jsonify
from flask import request
import os
import json
import requests
import user_count_license
from threading import Thread
app = Flask(__name__)


def backgroundworker(response_url):

    # your task

    payload = {"text": "Count of Confluence licenses: {}\n Count of Jira licenses: {}\n Count of Bitbucket licenses: {}" \
         .format(user_count_license.confluence_license(),user_count_license.jira_license(),user_count_license.bitbucket_license())}

    requests.post(response_url,data=json.dumps(payload))

@app.route('/license',methods=['POST','GET'])
def receptionist():

    response_url = request.form.get("response_url")


    thr = Thread(target=backgroundworker, args=[response_url])
    thr.start()

    return jsonify(text = "Please, wait a bit, working on your request")

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
