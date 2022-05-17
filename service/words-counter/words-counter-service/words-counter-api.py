import requests
from bs4 import BeautifulSoup
from flask import jsonify, Flask
from collections import Counter
from string import punctuation
import os
import json


app = Flask(__name__)

nginx_url=os.environ.get('NGINX_URL')
print('nginx',nginx_url)

@app.route("/")
def index():
    """Function to test the functionality of the API"""
    return "Hello, world!"

@app.route("/api/count", methods=["GET"])
def get_words_frequency():
    """Function to retrieve frequently occuring words (twice or more)"""
    try:
        r = requests.get(nginx_url)
        soup = BeautifulSoup(r.content,'html.parser')
        text = (''.join(s.findAll(text=True))for s in soup.findAll('p'))
        c = Counter((x.rstrip(punctuation).lower() for y in text for x in y.split()))
        return json.dumps(c.most_common())

    except Exception as exception:
        return jsonify(str(exception))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
