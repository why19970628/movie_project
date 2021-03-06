from . import admin
from app.home import home
from flask import render_template, redirect, url_for, flash, session, request, abort
from app.admin.forms import LoginForm, TagForm, MovieForm, PreviewForm, PwdForm, AuthForm, RoleForm, AdminForm
from app.models import Admin, Tag, Movie, Preview, User, Comment, Moviecol, Oplog, Adminlog, Userlog, Auth, Role
from functools import wraps
from app import db, app
from werkzeug.utils import secure_filename
import os, uuid, datetime


def admin_log_req(f):
    """
    登录装饰器
    //  元组 dict
    """

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "admin" not in session:
            return redirect(url_for("admin.login", next=request.url))
        return f(*args, **kwargs)

    return decorated_function


@admin.context_processor
def tpl_extra():
    """
    上下应用处理器,将变量转为全局变量
    """
    try:
        admin = Admin.query.filter_by(name=session["admin"]).first()
    except:
        admin = None
    data = dict(
        online_time=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        logo="mtianyan.jpg",
        admin=admin,
    )
    # 之后直接传个admin。取admin face字段即可
    return data


def change_filename(filename):
    """
    修改上传文件名称
    """
    # print("原始文件name", filename)
    fileinfo = os.path.splitext(filename)
    # print("分割后：", fileinfo)
    filename = datetime.datetime.now().strftime("%Y%m%d%H%M%S") + str(uuid.uuid4().hex) + list(fileinfo)[-1]
    # print("最终文件name", filename)
    return filename


# 权限控制装饰器
def admin_auth(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        admin = Admin.query.join(
            Role
        ).filter(
            Role.id == Admin.role_id,
            Admin.id == session["admin_id"]
        ).first()
        # print(admin.role)
        if admin.role.name != '超级管理员':
            auths = admin.role.auths  # 登录用户的权限操作id
            auths = list(map(lambda v: int(v), auths.split(",")))
            auth_list = Auth.query.all()  # 所有权限
            urls = [v.url for v in auth_list for val in auths if val == v.id]  # 筛选出所有路由
            rule = request.url_rule
            # print(rule)
            if str(rule) not in urls:
                abort(404)
            return f(*args, **kwargs)
        else:
            return f(*args, **kwargs)

    return decorated_function


@admin.route("/")
@admin_log_req
@admin_auth
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
        session["admin_id"] = admin.id
        # 管理员登陆日志
        adminlog = Adminlog(
            admin_id=admin.id,
            ip=request.remote_addr,
        )
        db.session.add(adminlog)
        db.session.commit()
        return redirect(request.args.get("next") or url_for("admin.index"))
    return render_template("admin/login.html", form=form)


@admin.route("/logout/")
@admin_log_req
def logout():
    session.pop("admin", None)
    session.pop("admin_id", None)
    return redirect(url_for("admin.login"))


@admin.route("/pwd/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def pwd():
    """
    后台密码修改
    """
    form = PwdForm()  # 做完密码判断返回
    if form.validate_on_submit():
        data = form.data
        admin = Admin.query.filter_by(name=session["admin"]).first()  ##筛选 admin信息
        from werkzeug.security import generate_password_hash
        admin.pwd = generate_password_hash(data["new_pwd"])
        db.session.add(admin)
        db.session.commit()
        flash("修改密码成功，请重新登录！", "ok")
        return redirect(url_for('admin.logout'))
    return render_template("admin/pwd.html", form=form)


# 添加标签
@admin.route("/tag/add", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def tag_add():
    form = TagForm()
    # print(form.name.errors)
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
        # 添加 管理员增加标签log日志
        oplog = Oplog(
            admin_id=session["admin_id"],
            ip=request.remote_addr,
            reason="添加标签%s" % data["name"]
        )
        db.session.add(oplog)
        db.session.commit()
        flash("标签添加成功", "ok")  # 闪现消息
        redirect(url_for("admin.tag_add"))
    return render_template("admin/tag_add.html", form=form)


# 标签列表
@admin.route("/tag/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def tag_list(page=None):
    if page is None:
        page = 1
    page_data = Tag.query.order_by(
        Tag.addtime.desc()  # 按添加时间排序
    ).paginate(page=page, per_page=10)
    return render_template("admin/tag_list.html", page_data=page_data)


@admin.route("/tag/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
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
@admin_auth
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
@admin_auth
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
        # print("上传电影名称", form.url.data.filename)
        # print("上传logo", form.logo.data.filename)
        file_url = os.path.basename(form.url.data.filename)  # 获取文件名
        file_logo = os.path.basename(form.logo.data.filename)
        # print(file_url)
        # print(file_logo)
        if not os.path.exists(app.config["MOVIE_DIR"]):
            # 创建一个多级目录
            os.makedirs(app.config["MOVIE_DIR"])
            os.chmod(app.config["MOVIE_DIR"], "rw")
        if not os.path.exists(app.config["MOVIE_LOGO_DIR"]):
            # 创建一个多级目录
            os.makedirs(app.config["MOVIE_LOGO_DIR"])
            os.chmod(app.config["MOVIE_LOGO_DIR"], "rw")

        url = change_filename(file_url)
        logo = change_filename(file_logo)
        # 保存
        form.url.data.save(app.config["MOVIE_DIR"] + url)
        form.logo.data.save(app.config["MOVIE_LOGO_DIR"] + logo)
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


@admin.route("/movie/list/<int:page>", methods=["GET"])
@admin_log_req
@admin_auth
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
    return render_template("admin/movie_list.html", page_data=page_data)


@admin.route("/movie/edit/<int:id>/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def movie_edit(id=None):
    """
    编辑电影页面
    """
    form = MovieForm()
    # 因为是编辑，所以非空验证空
    form.url.validators = []
    form.logo.validators = []
    movie = Movie.query.get_or_404(int(id))
    if request.method == "GET":  # 提供编辑电影的初值
        form.info.data = movie.info
        form.tag_id.data = movie.tag_id
        form.star.data = movie.star
        # form.logo.data = movie.logo
        # form.url.data = movie.url
        # print(movie.star, movie.info)
        # print("movie_edit ", movie.logo, movie.url)
    if form.validate_on_submit():
        data = form.data
        movie_count = Movie.query.filter_by(title=data["title"]).count()  # 根据表单提交的title查找
        # 存在表单提交的值，并且不等于数据库的存在的title,则无需重复提交。
        old_movie_url = movie.url
        # print("删除")
        # print(old_movie_url)
        old_movie_logo = movie.logo
        # print(old_movie_logo)
        if movie_count == 1 and movie.title != data["title"]:
            flash("片名已经存在！", "err")
            return redirect(url_for('admin.movie_edit', id=id))
        # 创建目录
        if not os.path.exists(app.config["MOVIE_DIR"]):
            os.makedirs(app.config["MOVIE_DIR"])
            os.chmod(app.config["MOVIE_DIR"], "rw")
        if not os.path.exists(app.config["MOVIE_LOGO_DIR"]):
            # 创建一个多级目录
            os.makedirs(app.config["MOVIE_LOGO_DIR"])
            os.chmod(app.config["MOVIE_LOGO_DIR"], "rw")
        # 上传视频
        if form.url.data != "":
            file_url = os.path.basename(form.url.data.filename)
            movie.url = change_filename(file_url)
            form.url.data.save(app.config["MOVIE_DIR"] + movie.url)
            os.remove(app.config["MOVIE_DIR"] + old_movie_url)
        # 上传图片
        if form.logo.data != "":
            file_logo = os.path.basename(form.logo.data.filename)
            movie.logo = change_filename(file_logo)
            form.logo.data.save(app.config["MOVIE_LOGO_DIR"] + movie.logo)
            os.remove(app.config["MOVIE_LOGO_DIR"] + old_movie_logo)  # 删除旧电影logo
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
@admin_auth
def movie_del(id=None):
    """
    电影删除
    """
    movie = Movie.query.get_or_404(id)
    db.session.delete(movie)
    db.session.commit()
    os.remove(app.config["MOVIE_DIR"] + movie.url)  # 删除本地电影
    os.remove(app.config["MOVIE_LOGO_DIR"] + movie.logo)
    flash("电影删除成功", "ok")
    return redirect(url_for('admin.movie_list', page=1))


@admin.route("/preview/add", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def preview_add():
    """
    上映预告添加
    """
    form = PreviewForm()
    if form.validate_on_submit():
        data = form.data
        file_logo = os.path.basename(form.logo.data.filename)
        if not os.path.exists(app.config["PREVIEW_UP_DIR"]):
            os.makedirs(app.config["PREVIEW_UP_DIR"])
            os.chmod(app.config["PREVIEW_UP_DIR"], "rw")
        logo = change_filename(file_logo)
        form.logo.data.save(app.config["PREVIEW_UP_DIR"] + logo)
        preview = Preview(
            title=data["title"],
            logo=logo
        )
        db.session.add(preview)
        db.session.commit()
        flash("添加预告成功！", "ok")
        return redirect(url_for('admin.preview_add'))
    return render_template("admin/preview_add.html", form=form)


@admin.route("/preview/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def preview_list(page=None):
    """
    上映预告列表
    """
    if page is None:
        page = 1
    page_data = Preview.query.order_by(
        Preview.addtime.desc()
    ).paginate(page=page, per_page=3)
    return render_template("admin/preview_list.html", page_data=page_data)


# 删除预告
@admin.route("/preview/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def preview_del(id=None):
    """
    预告删除
    """
    preview = Preview.query.get_or_404(id)
    old_logo = preview.logo
    db.session.delete(preview)
    db.session.commit()
    flash("预告删除成功", "ok")
    os.remove(app.config["PREVIEW_UP_DIR"] + old_logo)  # 删除旧预告logo
    return redirect(url_for('admin.preview_list', page=1))


@admin.route("/preview/edit/<int:id>/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def preview_edit(id):
    """
    编辑预告
    """
    form = PreviewForm()
    # 下面这行代码禁用编辑时的提示:封面不能为空
    form.logo.validators = []
    preview = Preview.query.get_or_404(int(id))
    old_logo = preview.logo
    if request.method == "GET":
        form.title.data = preview.title  # 初始化form title
    if form.validate_on_submit():
        data = form.data  ## 提交表单的数据
        if form.logo.data != "":  # 更换logo
            file_logo = secure_filename(form.logo.data.filename)
            preview.logo = change_filename(file_logo)  # 换名字
            form.logo.data.save(app.config["PREVIEW_UP_DIR"] + preview.logo)
        preview.title = data["title"]
        db.session.add(preview)
        db.session.commit()
        flash("修改预告成功！", "ok")
        os.remove(app.config["PREVIEW_UP_DIR"] + old_logo)  # 删除旧预告logo
        return redirect(url_for('admin.preview_edit', id=id))
    return render_template("admin/preview_edit.html", form=form, preview=preview)


@admin.route("/user/list/<int:page>/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def user_list(page=None):
    """
       会员列表
       """
    if page is None:
        page = 1
    page_data = User.query.order_by(
        User.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("admin/user_list.html", page_data=page_data)


@admin.route("/user/view/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def user_view(id=None):
    """
       查看会员详情
       """
    from_page = request.args.get('fp')
    if not from_page:
        from_page = 1
    user = User.query.get_or_404(int(id))
    return render_template("admin/user_view.html", user=user, from_page=from_page)


@admin.route("/user/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def user_del(id=None):
    """
    删除会员
    """
    # # # 因为删除当前页。假如是最后一页，这一页已经不见了。回不到。

    from_page = int(request.args.get('fp')) - 1
    # # 此处考虑全删完了，没法前挪的情况，0被视为false
    if not from_page:
        from_page = 1
    user = User.query.get_or_404(int(id))
    db.session.delete(user)
    db.session.commit()
    flash("删除会员成功！", "ok")
    return redirect(url_for('admin.user_list', page=from_page))


@admin.route("/comment/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def comment_list(page=None):
    """
       评论列表
       """
    if page is None:
        page = 1
    # 通过评论join查询其相关的movie，和相关的用户。
    # 然后过滤出其中电影id等于评论电影id的电影，和用户id等于评论用户id的用户
    page_data = Comment.query.join(Movie).join(User).filter(
        Movie.id == Comment.movie_id,
        User.id == Comment.user_id
    ).order_by(
        Comment.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("admin/comment_list.html", page_data=page_data)


@admin.route("/comment/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def comment_del(id=None):
    """
    删除评论
    """
    # 因为删除当前页。假如是最后一页，这一页已经不见了。回不到。
    from_page = int(request.args.get('fp'))
    # 此处考虑全删完了，没法前挪的情况，0被视为false
    if not from_page:
        from_page = 1
    comment = Comment.query.get_or_404(int(id))
    db.session.delete(comment)
    db.session.commit()
    flash("删除评论成功！", "ok")
    return redirect(url_for('admin.comment_list', page=from_page))


@admin.route("/moviecol/list/<int:page>/")
@admin_log_req
@admin_auth
def moviecol_list(page=None):
    """
        电影收藏
        """
    if page is None:
        page = 1
    page_data = Moviecol.query.join(Movie).join(User).filter(
        Movie.id == Moviecol.movie_id,
        User.id == Moviecol.user_id
    ).order_by(
        Moviecol.addtime.desc()
    ).paginate(page=page, per_page=5)
    return render_template("admin/moviecol_list.html", page_data=page_data)


@admin.route("/moviecol/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def moviecol_del(id=None):
    """
    收藏删除
    """
    # 因为删除当前页。假如是最后一页，这一页已经不见了。回不到。
    from_page = int(request.args.get('fp')) - 1
    # 此处考虑全删完了，没法前挪的情况，0被视为false
    if not from_page:
        from_page = 1
    moviecol = Moviecol.query.get_or_404(int(id))
    db.session.delete(moviecol)
    db.session.commit()
    flash("删除收藏成功！", "ok")
    return redirect(url_for('admin.moviecol_list', page=from_page))


# 操作日志
@admin.route("/oplog/list/<int:page>", methods=["GET"])
@admin_log_req
@admin_auth
def oplog_list(page=None):
    if page is None:
        page = 1
    page_data = Oplog.query.join(Admin).filter(
        Oplog.admin_id == Admin.id,
    ).order_by(
        Oplog.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("admin/oplog_list.html", page_data=page_data)


# 管理员登录日志
@admin.route("/adminloginlog/list")
@admin_log_req
@admin_auth
def adminloginlog_list(page=None):
    """
    管理员登录日志
    """
    if page is None:
        page = 1
    page_data = Adminlog.query.join(
        Admin
    ).filter(
        Admin.id == Adminlog.admin_id,
    ).order_by(
        Adminlog.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("admin/adminloginlog_list.html", page_data=page_data)


# 用户登录日志
@admin.route("/userloginlog/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def userloginlog_list(page=None):
    """
    会员登录日志列表
    """
    if page is None:
        page = 1
    page_data = Userlog.query.join(User).filter(
        User.id == Userlog.user_id,
    ).order_by(
        Userlog.addtime.desc()
    ).paginate(page=page, per_page=5)
    return render_template("admin/userloginlog_list.html", page_data=page_data)


@admin.route("/role/add/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def role_add():
    """
    角色添加
    """
    form = RoleForm()
    if form.validate_on_submit():
        data = form.data
        print("auths", data)
        role = Role(
            name=data["name"],
            auths=",".join(map(lambda v: str(v), data["auths"]))
        )
        db.session.add(role)
        db.session.commit()
        flash("添加角色成功！", "ok")
    return render_template("admin/role_add.html", form=form)


@admin.route("/role/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def role_list(page=None):
    """
    角色列表
    """
    if page is None:
        page = 1
    page_data = Role.query.order_by(
        Role.addtime.desc()
    ).paginate(page=page, per_page=4)
    return render_template("admin/role_list.html", page_data=page_data)


@admin.route("/role/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def role_del(id=None):
    """
    删除角色
    """
    role = Role.query.filter_by(id=id).first_or_404()
    db.session.delete(role)
    db.session.commit()
    flash("删除角色成功！", "ok")
    return redirect(url_for('admin.role_list', page=1))


@admin.route("/role/edit/<int:id>/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def role_edit(id=None):
    """
     编辑角色
    """
    form = RoleForm()
    role = Role.query.get_or_404(id)
    # print(role)
    if request.method == "GET":
        auths = role.auths
        # print(auths)
        # get时进行赋值。应对无法模板中赋初值
        if auths != '':
            form.auths.data = list(map(lambda v: int(v), auths.split(",")))
        else:
            form.auths.data = []
    if form.validate_on_submit():
        data = form.data
        role.name = data["name"]
        # print(data["name"])
        if data["name"] != "超级管理员":
            role.auths = ",".join(map(lambda v: str(v), data["auths"]))
            db.session.add(role)
            db.session.commit()
            flash("修改角色成功！", "ok")
        else:
            flash("超级管理员无法修改！", "err")
    return render_template("admin/role_edit.html", form=form, role=role)


# 权限管理
@admin.route("/auth/add/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def auth_add():
    """
    添加权限
    """
    form = AuthForm()
    if form.validate_on_submit():
        data = form.data
        auth = Auth(
            name=data["name"],
            url=data["url"]
        )
        db.session.add(auth)
        db.session.commit()
        flash("添加权限成功！", "ok")
    return render_template("admin/auth_add.html", form=form)


@admin.route("/auth/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def auth_list(page=None):
    """
    权限列表
    """
    if page is None:
        page = 1
    page_data = Auth.query.order_by(
        Auth.addtime.desc()
    ).paginate(page=page, per_page=4)
    return render_template("admin/auth_list.html", page_data=page_data)


@admin.route("/auth/del/<int:id>/", methods=["GET"])
@admin_log_req
@admin_auth
def auth_del(id=None):
    """
    权限删除
    """
    auth = Auth.query.filter_by(id=id).first_or_404()
    db.session.delete(auth)
    db.session.commit()
    flash("删除权限成功！", "ok")
    return redirect(url_for('admin.auth_list', page=1))


@admin.route("/auth/edit/<int:id>/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def auth_edit(id=None):
    """
    编辑权限
    """
    form = AuthForm()
    auth = Auth.query.get_or_404(id)
    if form.validate_on_submit():
        data = form.data
        auth.url = data["url"]
        auth.name = data["name"]
        db.session.add(auth)
        db.session.commit()
        flash("修改权限成功！", "ok")
        redirect(url_for('admin.auth_edit', id=id))
    return render_template("admin/auth_edit.html", form=form, auth=auth)


# 权限管理
# 添加管理员
@admin.route("/admin/add/", methods=["GET", "POST"])
@admin_log_req
@admin_auth
def admin_add():
    form = AdminForm()
    from werkzeug.security import generate_password_hash
    if form.validate_on_submit():
        data = form.data
        admin = Admin(
            name=data["name"],
            pwd=generate_password_hash(data["pwd"]),
            role_id=data["role_id"],
            is_super=1
        )
        db.session.add(admin)
        db.session.commit()
        flash("添加管理员成功！", "ok")
    return render_template("admin/admin_add.html", form=form)


# 管理员列表
@admin.route("/admin/list/<int:page>/", methods=["GET"])
@admin_log_req
@admin_auth
def admin_list(page=None):
    if page is None:
        page = 1
    page_data = Admin.query.join(
        Role
    ).filter(
        Role.id == Admin.role_id
    ).order_by(
        Admin.addtime.desc()
    ).paginate(page=page, per_page=10)
    return render_template("admin/admin_list.html", page_data=page_data)
