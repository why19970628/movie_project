from . import admin
from app.home import home
from flask import render_template, redirect, url_for, flash, session, request
# from app.admin.forms import LoginForm
from forms import LoginForm, TagForm, MovieForm
from app.models import Admin, Tag, Movie
from functools import wraps
from app import db, app
from werkzeug.utils import secure_filename
import os, uuid, datetime


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


def change_filename(filename):
    """
    修改上传文件名称
    """
    fileinfo = os.path.splitext(filename)
    filename = datetime.datetime.now().strftime("%Y%m%d%H%M%S") + str(uuid.uuid4().hex)  + list(fileinfo)[-1]
    return filename


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
    if form.validate_on_submit():  # 表单数据
        data = form.data
        admin = Admin.query.filter_by(name=data["account"]).first()  # 查找admin
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


# 添加标签
@admin.route("/tag/add", methods=["GET", "POST"])
@admin_log_req
def tag_add():
    form = TagForm()
    print(form.name.errors)
    if form.validate_on_submit():
        data = form.data
        tag = Tag.query.filter_by(name=data["name"]).count()  # 数据库查找信息
        if tag == 1:
            flash("名称已经存在!", "err")
            return redirect(url_for('admin.tag_add'))
        tag = Tag(
            name=data["name"]
        )
        db.session.add(tag)
        db.session.commit()
        flash("标签添加成功", "ok")  # 闪现消息
        redirect(url_for("admin.tag_add"))
    return render_template("admin/tag_add.html", form=form)


# 标签列表
@admin.route("/tag/list/<int:page>/", methods=["GET"])
@admin_log_req
def tag_list(page=None):
    if page is None:
        page = 1
    page_data = Tag.query.order_by(
        Tag.addtime.desc()  # 按添加时间排序
    ).paginate(page=page, per_page=10)
    return render_template("admin/tag_list.html", page_data=page_data)


@admin.route("/tag/del/<int:id>/", methods=["GET"])
@admin_log_req
# @admin_auth
def tag_del(id=None):
    """
    标签删除
    """
    # filter_by在查不到或多个的时候并不会报错，get会报错。
    tag = Tag.query.filter_by(id=id).first_or_404()
    db.session.delete(tag)
    db.session.commit()
    flash("标签<<{0}>>删除成功".format(tag.name), "ok")
    return redirect(url_for("admin.tag_list", page=1))


@admin.route("/tag/edit/<int:id>", methods=["GET", "POST"])
@admin_log_req
# @admin_auth
def tag_edit(id=None):
    """
    标签编辑
    """
    form = TagForm()
    form.submit.label.text = "修改"
    tag = Tag.query.get_or_404(id)  # 数据库依据id查找tag
    if form.validate_on_submit():
        data = form.data
        tag_count = Tag.query.filter_by(name=data["name"]).count()
        # 说明已经有这个标签了,此时向添加一个与其他标签重名的标签。
        if tag.name != data["name"] and tag_count == 1:
            flash("标签已存在", "err")
            return redirect(url_for("admin.tag_edit", id=tag.id))
        tag.name = data["name"]
        db.session.add(tag)
        db.session.commit()
        flash("标签修改成功", "ok")
        redirect(url_for("admin.tag_edit", id=tag.id))
    return render_template("admin/tag_edit.html", form=form, tag=tag)


@admin.route("/movie/add", methods=["GET", "POST"])
@admin_log_req
def movie_add():
    """
    添加电影页面
    """
    form = MovieForm()
    if form.validate_on_submit():
        data = form.data
        tag = Movie.query.filter_by(title=data["title"]).count()  # 数据库查找信息
        if tag == 1:
            flash("名称已经存在!", "err")
            return redirect(url_for('admin.movie_add'))
        file_url = secure_filename(form.url.data.filename) #更改文件名
        file_logo = secure_filename(form.logo.data.filename)
        if not os.path.exists(app.config["UP_DIR"]):
            # 创建一个多级目录
            os.makedirs(app.config["UP_DIR"])
            os.chmod(app.config["UP_DIR"], "rw")
        url = change_filename(file_url)
        logo = change_filename(file_logo)
        # 保存
        form.url.data.save(app.config["UP_DIR"] + url)
        form.logo.data.save(app.config["UP_DIR"] + logo)
        # url,logo为上传视频,图片之后获取到的地址
        movie = Movie(
            title=str(data["title"]),
            url=url,
            info=str(data['info']),
            logo=logo,
            star=int(data["star"]),
            playnum=0,
            commentnum=0,
            tag_id=int(data["tag_id"]),
            area=str(data["area"]),
            release_time=data["release_time"],
            length=str(data["length"])
        )
        db.session.add(movie)
        db.session.commit()
        flash("添加电影成功！", "ok")
        return redirect(url_for('admin.movie_add'))
    return render_template("admin/movie_add.html", form=form)


@admin.route("/movie/list/<int:page>",methods=["GET"])
@admin_log_req
def movie_list(page=None):
    """
    电影列表页面
    """
    if page is None:
        page = 1
    # 进行关联Tag的查询,单表查询使用filter_by 多表查询使用filter进行关联字段的声明
    page_data = Movie.query.join(Tag).filter(
        Tag.id == Movie.tag_id
    ).order_by(
        Movie.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("admin/movie_list.html",page_data=page_data)

@admin.route("/movie/edit/<int:id>/", methods=["GET", "POST"])
@admin_log_req
# @admin_auth
def movie_edit(id=None):
    """
    编辑电影页面
    """
    form = MovieForm()
    # 因为是编辑，所以非空验证空
    form.url.validators = []
    form.logo.validators = []
    movie = Movie.query.get_or_404(int(id))
    if request.method == "GET": #提供编辑电影的初值
        form.info.data = movie.info
        form.tag_id.data = movie.tag_id
        form.star.data = movie.star
        # form.logo = str(movie.logo)
        # form.url=str(movie.url)
    if form.validate_on_submit():
        data = form.data
        movie_count = Movie.query.filter_by(title=data["title"]).count() #根据表单提交的title查找
        # 存在表单提交的值，并且不等于数据库的存在的title,则无需重复提交。
        if movie_count == 1 and movie.title != data["title"]:
            flash("片名已经存在！", "err")
            return redirect(url_for('admin.movie_edit', id=id))
        # 创建目录
        if not os.path.exists(app.config["UP_DIR"]):
            os.makedirs(app.config["UP_DIR"])
            os.chmod(app.config["UP_DIR"], "rw")
        # 上传视频
        if form.url.data != "":
            file_url = secure_filename(form.url.data.filename)
            movie.url = change_filename(file_url)
            form.url.data.save(app.config["UP_DIR"] + movie.url)
        # 上传图片
        if form.logo.data != "":
            file_logo = secure_filename(form.logo.data.filename)
            movie.logo = change_filename(file_logo)
            form.logo.data.save(app.config["UP_DIR"] + movie.logo)

        movie.star = data["star"]
        movie.tag_id = data["tag_id"]
        movie.info = data["info"]
        movie.title = data["title"]
        movie.area = data["area"]
        movie.length = data["length"]
        movie.release_time = data["release_time"]
        db.session.add(movie)
        db.session.commit()
        flash("修改电影成功！", "ok")
        return redirect(url_for('admin.movie_edit', id=id))
    return render_template("admin/movie_edit.html", form=form, movie=movie)


@admin.route("/movie/del/<int:id>/", methods=["GET"])
@admin_log_req
# @admin_auth
def movie_del(id=None):
    """
    电影删除
    """
    movie = Movie.query.get_or_404(id)
    db.session.delete(movie)
    db.session.commit()
    flash("电影删除成功", "ok")
    return redirect(url_for('admin.movie_list', page=1))


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
