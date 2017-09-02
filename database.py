from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Slivers125@localhost/EvenKeel'
app.debug = True

db = SQLAlchemy(app)