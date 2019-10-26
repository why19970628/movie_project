from . import admin
from app.home import home
from flask import render_template, redirect, url_for


@admin.route("/")
def index():
    return "<h1 style='color:red'>this is admin"
    # return render_template("home/index.html")