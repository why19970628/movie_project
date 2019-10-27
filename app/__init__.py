# coding:utf8
#注册蓝图
from flask import Flask,render_template

app = Flask(__name__)
app.debug = True

from app.home import home as home_blueprint
from app.admin import admin as admin_blueprint

app.register_blueprint(home_blueprint)
app.register_blueprint(admin_blueprint, url_prefix="/admin")#访问admin需 /admin


@app.errorhandler(404)
def page_not_found(error):
    return render_template("home/404.html"), 404