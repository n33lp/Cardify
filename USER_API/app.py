''' FLASK SERVER '''

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from helpers import validate_pass
import json

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
with open('STOCKIMAGE.txt') as f:
    STOCKIMAGE = f.readline()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    firstname = db.Column(db.String(120), nullable=False)
    lastname = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    token = db.Column(db.String(120), nullable=False)
    profilepic = db.Column(db.String(20000), nullable=True)
     
with open("CREDS.json") as f:
    data = json.load(f)
    LLM=data['LLM_key']
   

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data['username']
    email = data['email']
    firstname = data['firstname']
    lastname = data['lastname']
    password = generate_password_hash(data['password'])
    # profilepic= data['profilepic']
    token = generate_password_hash(username+email+password)
    if username=='' or email=='' or firstname=='' or lastname=='' or password=='':
        return jsonify({'message': 'Please fill all the fields'}), 400
    

    new_user = User(username=username,firstname=firstname,lastname=lastname, email=email, password=password, token = token,profilepic=STOCKIMAGE)

    
    
    
    if User.query.filter_by(username=username).first() and User.query.filter_by(email=email).first():
        return jsonify({'message': "Username and Email already exists, click 'Forgot Password'."}), 409
    elif User.query.filter_by(username=username).first():
        return jsonify({'message': "Username already exists, click 'Forgot Password'."}), 409
    elif User.query.filter_by(email=email).first():
        return jsonify({'message': "Email already exists, click 'Forgot Password'."}), 409
    elif not validate_pass(data['password']):
        return jsonify({'message': "Password does not meet the requirements"}), 400
    
    db.session.add(new_user)
    db.session.commit()
    return jsonify({'message': 'User created successfully','access_token': token})

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data['username']
    password = data['password']

    user = User.query.filter_by(username=username).first()
    
    if user and check_password_hash(user.password, password):
        return jsonify({
            'message': 'Login successful',
            'token': user.token,
            'email': user.email,
            'firstname': user.firstname,
            'lastname': user.lastname,
            'profilepic': user.profilepic,
            }), 200
    else:
        return jsonify({'message': 'Invalid username or password'}), 401


@app.route('/index', methods=['GET'])
def GETindex():
    return response('hellow world')
    
@app.route('/all', methods=['GET'])
def GETall():
    return jsonify([{"username": user.username, "email": user.email, "password": user.password, "token": user.token} for user in User.query.all()]), 200


@app.route('/llm/validateUser', methods=['GET'])
def validateforLLM():
    data = request.json
   
    if not validateforLLM(data):
        return jsonify({'message': 'Access denied'}), 401
    
    if validateUserandToken(data):
        return jsonify({'message': 'User validated successfully', 'access': True}), 200
    
    return jsonify({'message': 'User not validated successfully', 'access': False}), 200
   
def validateforLLM(data):
    llmtoken = data['llmtoken']
    return True if llmtoken == LLM else False
   
def validateUserandToken(data):
    user = data['user']
    usertoken = data['usertoken']
    x = User.query.filter_by(username=user).first()  
    if x == None: return False
    return True if x.token == usertoken else False


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=5001)
