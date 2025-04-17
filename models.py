from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Master(db.Model):
    __tablename__ = 'master'
    login = db.Column(db.String, primary_key=True)
    password = db.Column(db.String, nullable=False)
    avatar = db.Column(db.LargeBinary, nullable=False)
    city = db.Column(db.String)
    phone = db.Column(db.String)

class Post(db.Model):
    __tablename__ = 'post'
    post_id = db.Column(db.Integer, primary_key=True)
    author_login = db.Column(db.String, db.ForeignKey('master.login'), nullable=False)
    photo = db.Column(db.LargeBinary, nullable=False)
    tags = db.Column(db.ARRAY(db.String), nullable=False)
    date_posted = db.Column(db.DateTime, nullable=False)
    likes = db.Column(db.Integer, nullable=False)

class Favourite(db.Model):
    __tablename__ = 'favourite'
    id = db.Column(db.Integer, primary_key=True)
    owner_login = db.Column(db.String, db.ForeignKey('master.login'), nullable=False)
    post_id = db.Column(db.Integer, db.ForeignKey('post.post_id'), nullable=False)

