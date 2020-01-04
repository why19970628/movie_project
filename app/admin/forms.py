# coding:utf-8
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, FileField, TextAreaField, SelectField
from wtforms.validators import DataRequired, ValidationError, EqualTo  # 验证器,错误返回
from app.models import Admin, Tag

tags = Tag.query.all()


class LoginForm(FlaskForm):
    '''管理员登录表单'''
    account = StringField(
        label="账号",
        validators=[DataRequired("账号不能为空")],
        description='账号',
        render_kw={
            "class": "form-control",
            "placeholder": "请输入账号！",
            # 注释此处显示forms报错errors信息
            # "required":"required" #必须项
        }
    )
    pwd = PasswordField(
        label="密码",
        validators=[
            DataRequired("密码不能为空")
        ],
        description="密码",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入密码！",
            # "required": "required"
        }
    )
    submit = SubmitField(
        "登录",
        render_kw={
            "class": "btn btn-primary btn-block btn-flat"
        }
    )

    def validate_account(self, field):
        account = field.data
        admin = Admin.query.filter_by(name=account).count()
        if admin == 0:
            raise ValidationError("账号不存在! ")
            # raise 当程序出现错误,python会自动引发异常,也可以通过raise显示地引发异常。
            # 一旦执行了raise语句,raise后面的语句将不能执行


class TagForm(FlaskForm):
    name = StringField(
        label="名称",
        validators=[
            DataRequired("标签名不能为空")
        ],
        description="标签",
        render_kw={
            "class": "form-control",
            "id": "input_name",
            "placeholder": "请输入标签名称!!",
        })
    submit = SubmitField(
        "添加",
        render_kw={
            "class": "btn btn-primary",
        }
    )


class MovieForm(FlaskForm):
    title = StringField(
        label="片名",
        validators=[
            DataRequired("片名不能为空")
        ],
        description="片名",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入片名!!",
        })
    url = FileField(
        label="文件",
        # validators=[
        #     DataRequired("请上传文件")
        # ],
        description="文件",
    )
    info = TextAreaField(
        label="简介",
        validators=[
            DataRequired("简介不能为空")
        ],
        description="简介",
        render_kw={
            "class": "form-control",
            "rows": "10"
        })
    logo = FileField(
        label="封面",
        # validators=[
        #     DataRequired("请上传封面")
        # ],
        description="封面",
    )
    star = SelectField(
        label="星级",
        validators=[
            DataRequired("请选择星级")
        ],
        coerce=int,
        choices=[(1, "1星"), (2, "2星"), (3, "3星"), (4, "4星"), (5, "5星")],
        description="星级",
        render_kw={
            "class": "form-control",
        }
    )
    tag_id = SelectField(
        label="标签",
        validators=[
            DataRequired("请选择标签")
        ],
        coerce=int,
        choices=[(v.id, v.name) for v in tags],
        description="标签",
        render_kw={
            "class": "form-control",
        }
    )
    area = StringField(
        label="片名",
        validators=[
            DataRequired("地区不能为空")
        ],
        description="地区",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入地区!!",
        })

    length = StringField(
        label="片长",
        validators=[
            DataRequired("片长不能为空")
        ],
        description="片长",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入片长!!",
        })
    release_time = StringField(
        label="上映时间",
        validators=[
            DataRequired("请选择上映时间")
        ],
        description="片长",
        render_kw={
            "class": "form-control",
            "placeholder": "请选择上映时间!!",
            "id": "input_release_time",
        })
    submit = SubmitField(
        "添加",
        render_kw={
            "class": "btn btn-primary",
        }
    )

class PreviewForm(FlaskForm):
    title = StringField(
        label="预告标题",
        validators=[
            DataRequired("预告标题不能为空！")
        ],
        description="预告标题",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入预告标题！"
        }
    )
    logo = FileField(
        label="预告封面",
        validators=[
            DataRequired("预告封面不能为空！")
        ],
        description="预告封面",
    )
    submit = SubmitField(
        '编辑',
        render_kw={
            "class": "btn btn-primary",
        }
    )

class PwdForm(FlaskForm):
    old_pwd = PasswordField(
        label="旧密码",
        validators=[
            DataRequired("旧密码不能为空！")
        ],
        description="旧密码",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入旧密码！",
        }
    )
    new_pwd = PasswordField(
        label="新密码",
        validators=[
            DataRequired("新密码不能为空！")
        ],
        description="新密码",
        render_kw={
            "class": "form-control",
            "placeholder": "请输入新密码！",
        }
    )
    submit = SubmitField(
        '编辑',
        render_kw={
            "class": "btn btn-primary",
        }
    )

    def validate_old_pwd(self, field):
        from flask import session
        pwd = field.data
        name = session["admin"]
        admin = Admin.query.filter_by(
            name=name
        ).first()
        if not admin.check_pwd(pwd):
            raise ValidationError("旧密码错误！")

