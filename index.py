from flask import Flask, render_template, request, jsonify, json, session
from flask.ext.session import Session
#from flask_sqlalchemy import * 
#from flask.ext.session import Session
from database import app, db
from dataModel import Users, addUser, getUsers, checkLogin, getHeartRateTypes, getUserID, addHeartRate
import jinja2

app.debug = True
app.debug = True
app.secret_key = 'super-secret'
app.config['SESSION_TYPE'] = 'filesystem'
# 14400 = 4 hour session lifetime
app.config['PERMANENT_SESSION_LIFETIME'] = 14400

Session(app)

@app.route("/")
def home():
  return render_template('home.html')
  
@app.route("/api/newUser", methods=['POST'])
def newUser():
  if request.method == 'POST':
    newUser = request.get_json(force=True, silent=True)
    addUser(newUser)
    return jsonify( 
      newUser
    )
  else:
    return json.dumps(False)
  
@app.route("/api/login", methods=['POST'])
def login():
#  session['user']
  if request.method == 'POST':
    user = request.get_json(force=True, silent=True)
    session['user'] = checkLogin(user)
    if(session['user'] != "false"):
      session['isValid'] = 'True'
      session['userID'] = getUserID(user)
      return session['user']
    else:
      session.clear()
      return json.dumps(False)
  else:
    return json.dumps(False)

@app.route("/api/logout", methods=['POST'])
def logout():
  session.clear()
  return json.dumps(True)

@app.route("/api/checkValidSession", methods=['POST'])
def checkValidSession():
  return session.get('user', 'false')

@app.route("/api/getHeartRateTypes", methods=['POST'])
def hrTypes():
  if request.method == 'POST':
    heartRateTypes = getHeartRateTypes() 
    return heartRateTypes
#    return jsonify( heartRateTypes )
  else:
    return json.dumps(False)
  
@app.route("/api/addHeartRate", methods=['POST'])
def addHR():
  if request.method == 'POST':
    HR = request.get_json(force=True, silent=True)
    userID = session['userID']
    HRResult = addHeartRate(HR, userID)
    return HRResult
  else:
    return json.dumps(False)