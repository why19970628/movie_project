from . import admin
from app.home import home
from flask import render_template, redirect, url_for, flash, session, request
# from app.admin.forms import LoginForm
from forms import LoginForm
from app.models import Admin
from functools import wraps


def admin_log_req(f):
    """
    登录装饰器
    """

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "admin" not in session:
            return redirect(url_for("admin.login", next=request.url))
        return f(*args, **kwargs)

    return decorated_function



@admin.route("/")
@admin_log_req
def index():
    return render_template("admin/index.html")


# 登录
@admin.route("/login/", methods=["GET", "POST"])
def login():
    """
    后台登录
    """
    form = LoginForm()
    da = form.account.errors
    print(da)
    if form.validate_on_submit(): #表单数据
        data = form.data
        admin = Admin.query.filter_by(name=data["account"]).first()#查找admin
        if not admin.check_pwd(data['pwd']):
            flash("密码错误", "err")
            return redirect(url_for("admin.login"))
        session['admin'] = data['account']
        return redirect(request.args.get("next") or url_for("admin.index"))
    return render_template("admin/login.html", form=form)


@admin.route("/logout/")
@admin_log_req
def logout():
    session.pop("admin", None)
    return redirect(url_for("admin.login"))


@admin.route("/pwd/")
@admin_log_req
def pwd():
    return render_template("admin/pwd.html")


@admin.route("/tag/add")
@admin_log_req
def tag_add():
    return render_template("admin/tag_add.html")


@admin.route("/tag/list")
@admin_log_req
def tag_list():
    return render_template("admin/tag_list.html")


@admin.route("/movie/add")
@admin_log_req
def movie_add():
    return render_template("admin/movie_add.html")


@admin.route("/movie/list")
@admin_log_req
def movie_list():
    return render_template("admin/movie_list.html")


@admin.route("/preview/add")
@admin_log_req
def preview_add():
    return render_template("admin/preview_add.html")


@admin.route("/preview/list")
@admin_log_req
def preview_list():
    return render_template("admin/preview_list.html")


@admin.route("/user/list")
@admin_log_req
def user_list():
    return render_template("admin/user_list.html")


@admin.route("/user/view")
@admin_log_req
def user_view():
    return render_template("admin/user_view.html")


@admin.route("/comment/list")
@admin_log_req
def comment_list():
    return render_template("admin/comment_list.html")


@admin.route("/moviecol/list")
@admin_log_req
def moviecol_list():
    return render_template("admin/moviecol_list.html")


# 日志管理
@admin.route("/oplog/list")
@admin_log_req
def oplog_list():
    return render_template("admin/oplog_list.html")


# 管理员登录日志
@admin.route("/adminloginlog/list")
@admin_log_req
def adminloginlog_list():
    return render_template("admin/adminloginlog_list.html")


# 用户登录日志
@admin.route("/userloginlog/list")
@admin_log_req
def userloginlog_list():
    return render_template("admin/userloginlog_list.html")


# 角色管理
@admin.route("/role/add")
@admin_log_req
def role_add():
    return render_template("admin/role_add.html")


@admin.route("/role/list")
@admin_log_req
def role_list():
    return render_template("admin/role_list.html")


# 权限管理
@admin.route("/auth/add")
@admin_log_req
def auth_add():
    return render_template("admin/auth_add.html")


@admin.route("/auth/list")
@admin_log_req
def auth_list():
    return render_template("admin/auth_list.html")


# 权限管理
@admin.route("/admin/add")
@admin_log_req
def admin_add():
    return render_template("admin/admin_add.html")


@admin.route("/admin/list")
@admin_log_req
def admin_list():
    return render_template("admin/admin_list.html")
