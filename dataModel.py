from flask import Flask, json
import random
import hashlib
from database import db

### User Table ###
class Users(db.Model):
  __table__ = db.Table('Users', db.metadata, autoload=True, autoload_with=db.engine)
  
def addUser(newUser):
  userTypeID = newUser['userTypeID']
  first = newUser['firstName']
  last = newUser['lastName']
  email = newUser['email']
  password = newUser['password']
  salt = createSalt()
  hashedPW = hashlib.sha512(password+salt).hexdigest()
  user = Users(UserTypeID=userTypeID, FirstName=first, LastName=last, Email=email, Salt=salt, Password=hashedPW)
  db.session.add(user)
  db.session.commit()
  return True
  
def getUsers():
  users = Users.query.order_by(Users.LastName, Users.FirstName.desc())
  return user

def createSalt():
  ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  chars=[]
  for i in range(128):
    chars.append(random.choice(ALPHABET))

  return "".join(chars)


### LKUserTypeTable ###
class LKUserType(db.Model):
  __table__ = db.Table('LKUserType', db.metadata, autoload=True, autoload_with=db.engine)

def getUserTypes():
  userTypes = LKUserType.query.order_by(LKUserType.UserTypeID)
  return userTypes

def checkLogin(user):
  userEmail = user['email']
  checkUser = db.session.query(Users).filter(Users.Email == userEmail).first()
  if checkUser is None:
    return json.dumps(False)
  hashedPW = hashlib.sha512(user['password']+checkUser.Salt).hexdigest()
  if hashedPW == checkUser.Password:
    return json.dumps(True)
  else:
    return json.dumps(False)
    