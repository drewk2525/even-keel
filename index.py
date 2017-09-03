from flask import Flask, render_template, request, jsonify, json
#from flask_sqlalchemy import * 
from database import app, db
from dataModel import Users, addUser, getUsers
import jinja2

#app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Slivers125@localhost/test'
#db = SQLAlchemy(app)
#
#class Users(db.Model):
#  __table__ = db.Table('users', db.metadata, autoload=True, autoload_with=db.engine)

app.debug = True
  
@app.route("/")
def home():
  return render_template('home.html')

@app.route("/api/newUser", methods=['POST'])
def newUser():
  if request.method == 'POST':
    newUser = request.get_json(force=True, silent=True)
    userType = newUser['userType']
    first = newUser['firstName']
    last = newUser['lastName']
    email = newUser['email']
    password = newUser['password']
    addUser(userType, first, last, email, password)
    return jsonify( 
      first = first,
      last = last,
      email = email
    )
  else:
    return false
#  newUserPy = json.loads(request.json)
#  return jsonify(
#    first = newUserPy.firstName,
#    last = newUserPy.lastName,
#    email = newUserPy.email
#    first = request.json['firstName'],
#    last = request.json['lastName'],
#    email = request.json['email']
#  )


#  if request.method == 'POST':
#    default = ''
#    first = request.form['first-name']
#    last = request.form['last-name']
#    email = request.form['email']
#    password = request.form['password']
#    repeatPassword = request.form['repeat-password']
#    return render_template('login.html', first=first, last=last)
  
#@app.route("/")
#def hello():
#  users = getUsers()
#  userList = ""
#  for user in users:
#    name = user.FirstName + " " + user.LastName
#    email = user.Email
#    userList += "<b>"+name+"</b> "+email+"<br>"
#      
#  return render_template('index.html', users=jinja2.Markup(userList))
#
#@app.route("/test", methods=['POST'])
#def test():
#  if request.method == 'POST':
#    first = request.form['firstName']
#    last = request.form['lastName']
#    email = request.form['email']
#    password = request.form['password']
#    addUser(1, first, last, email, 'ABC', password)
#    return render_template('display.html', name=request.form['firstName'] + " " + request.form['lastName'])