from flask import Flask
from database import db

class Users(db.Model):
  __table__ = db.Table('Users', db.metadata, autoload=True, autoload_with=db.engine)
  
def addUser(userTypeID, first, last, email, salt, password):
  user = Users(UserTypeID=userTypeID, FirstName=first, LastName=last, Email=email, Salt=salt, Password=password)
  db.session.add(user)
  db.session.commit()
  
def getUsers():
  users = Users.query.order_by(Users.LastName, Users.FirstName.desc())
  return user