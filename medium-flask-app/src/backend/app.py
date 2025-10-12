import os
from flask import Flask
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route('/')
def main():
    return 'Hello... Write Your Name in the URL...'

@app.route('/MyNameIs/<name>')
def hello(name):
    return 'Hello ' + name + ', How are you?'

if __name__ == '__main__':
    app.run(host=os.getenv("FLASK_RUN_HOST"), port=int(os.getenv("FLASK_RUN_PORT")))
