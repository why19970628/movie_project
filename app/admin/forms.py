# coding:utf-8
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired, ValidationError, EqualTo  # 验证器,错误返回
from app.models import Admin


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
        validators=[DataRequired("密码不能为空")],
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
            #raise 当程序出现错误,python会自动引发异常,也可以通过raise显示地引发异常。
            # 一旦执行了raise语句,raise后面的语句将不能执行
