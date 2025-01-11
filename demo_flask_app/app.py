from flask import Flask,render_template,request,jsonify,redirect

app = Flask(__name__)

"""

This is the main Flask app.
Few changes to flask entry point comment.
"""
@app.route("/")
def home():
    return render_template("index.html")



"""

This is the main Flask app.
Few changes to flask entry point comment.
"""
@app.route("/hello")
def index():
    return "hello! how are you!"