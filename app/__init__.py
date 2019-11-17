# coding:utf8
#注册蓝图
from flask import Flask,render_template
####创建数据库表
import pymysql
from flask_sqlalchemy import SQLAlchemy
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:123456@localhost/movie'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SECRET_KEY'] = '5728441192754541acd7a3ef681b3bbb'
app.debug = True
db = SQLAlchemy(app)



from app.home import home as home_blueprint
from app.admin import admin as admin_blueprint

app.register_blueprint(home_blueprint)
app.register_blueprint(admin_blueprint, url_prefix="/admin")#访问admin需 /admin


@app.errorhandler(404)
def page_not_found(error):
    return render_template("home/404.html"), 404