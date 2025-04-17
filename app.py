from flask import Flask, request, jsonify
from models import db, Master, Post, Favourite
from config import Config
from datetime import datetime
from sqlalchemy import func
from sqlalchemy import and_
from sqlalchemy import create_engine, Column, Integer, String, ARRAY

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

@app.route('/addMaster', methods=['POST'])
def add_master():
    data = request.json
    new_master = Master(login=data['login'], password=data['password'], avatar=data['avatar'].encode('utf-8'), city=data['city'], phone=data['phone'])
    db.session.add(new_master)
    db.session.commit()
    return jsonify({'message': 'Master account created successfully'}), 201

@app.route('/login', methods=['POST'])
def login_master():
    data = request.json
    master = Master.query.filter_by(login=data['login'], password=data['password']).first()
    if master:
        return jsonify({'message': 'Login successful', 'avatar': master.avatar.decode('utf-8'), 'city': master.city, 'phone': master.phone}), 200
    return jsonify({'message': 'Invalid credentials'}), 401

@app.route('/master/<string:login>', methods=['GET'])
def get_master_data(login):
    master = Master.query.filter_by(login=login).first()
    if master:
        return jsonify({
            'login': master.login,
            'password': master.password,
            'avatar': master.avatar.decode('utf-8'),
            'city': master.city,
            'phone': master.phone
        })
    else:
        return jsonify({'error': 'Invalid credentials'}), 404

@app.route('/addPost', methods=['POST'])
def add_post():
    data = request.json
    new_post = Post(author_login=data['author_login'], photo=data['photo'].encode('utf-8'), tags=data['tags'], date_posted=datetime.now(), likes=data['likes'])
    db.session.add(new_post)
    db.session.commit()
    return jsonify({'message': 'Post added successfully'}), 201

@app.route('/getAllPosts', methods=['GET'])
def get_all_posts():
    posts = Post.query.all()
    output = [{'post_id': post.post_id, 'author_login': post.author_login, 'photo': post.photo.decode('utf-8'), 'tags': post.tags, 'date_posted': post.date_posted.isoformat(), 'likes': post.likes} for post in posts]
    return jsonify(output)

@app.route('/posts/<string:author_login>', methods=['GET'])
def get_posts_by_author(author_login):
    posts = Post.query.filter_by(author_login=author_login).all()
    output = [{'post_id': post.post_id, 'author_login': post.author_login, 'photo': post.photo.decode('utf-8'), 'tags': post.tags, 'date_posted': post.date_posted.isoformat(), 'likes': post.likes} for post in posts]
    return jsonify(output)

@app.route('/postsByTags', methods=['POST'])
def get_posts_by_tags():
    data = request.json
    tags = data.get('tags')
    if tags == []:
        return jsonify([])
    posts = Post.query.filter(and_(*[Post.tags.any(tag) for tag in tags])).all()
    if posts:
        output = [{'post_id': post.post_id, 'author_login': post.author_login, 'photo': post.photo.decode('utf-8'), 'tags': post.tags, 'date_posted': post.date_posted.isoformat(), 'likes': post.likes} for post in posts]
    else:
        output = []
    return jsonify(output)


@app.route('/addToFavourites', methods=['POST'])
def add_to_favourites():
    data = request.json
    new_favourite = Favourite(owner_login=data['owner_login'], post_id=data['post_id'])
    db.session.add(new_favourite)
    db.session.commit()
    return jsonify({'message': 'Post added to favourites'}), 201

@app.route('/favourites/<string:owner_login>', methods=['GET'])
def get_favourites(owner_login):
    favourites = Favourite.query.filter_by(owner_login=owner_login).all()
    output = []
    for favourite in favourites:
        post = PostModel.query.get(favourite.post_id)
        if post:
            post_data = {
                'post_id': post.post_id,
                'author_login': post.author_login,
                'photo': base64.b64encode(post.photo).decode('utf-8'),
                'tags': post.tags,
                'date_posted': post.date_posted.isoformat(),
                'likes': post.likes
            }
            output.append(post_data)
    return jsonify(output)

@app.route('/favourites/<string:owner_login>/<int:post_id>', methods=['DELETE'])
def remove_from_favourites(owner_login, post_id):
    favourite = Favourite.query.filter_by(owner_login=owner_login, post_id=post_id).first()
    if favourite:
        db.session.delete(favourite)
        db.session.commit()
        return jsonify({'message': 'Favourite removed successfully'}), 200
    return jsonify({'message': 'Favourite not found'}), 404

@app.route('/deletePost/<int:post_id>', methods=['DELETE'])
def delete_post(post_id):
    post = Post.query.get(post_id)
    if post:
        Favourite.query.filter_by(post_id=post_id).delete()
        db.session.delete(post)
        db.session.commit()
        return jsonify({'message': 'Post deleted successfully'}), 200
    return jsonify({'message': 'Post not found'}), 404

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
