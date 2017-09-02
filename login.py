from flask import Flask, render_template, request, jsonify
#from flask_sqlalchemy import * 
from database import app, db
from dataModel import Users, addUser, getUsers
import jinja2

