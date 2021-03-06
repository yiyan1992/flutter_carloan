import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carloan/agreement/RegisterAgreementPageInfo.dart';
import 'package:flutter_carloan/app/DataResponse.dart';
import 'package:flutter_carloan/app/Global.dart';
import 'package:flutter_carloan/common/CodeButton.dart';
import 'package:flutter_carloan/common/CommonButton.dart';
import 'package:flutter_carloan/common/DialogUtils.dart';
import 'package:flutter_carloan/index/RootScene.dart';

///登陆页面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Global global = Global();

  String loginPhone;

  ///登陆方式 0 免密登陆,1 密码登陆 2 密码找回
  var _loginType = 0;

  ///显示密码 true 不显示
  bool _showPwd = true;
  TextEditingController _phone = new TextEditingController();
  TextEditingController _code = new TextEditingController();
  TextEditingController _pwd = new TextEditingController();
  TextEditingController _pwdRepeat = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  int second = 0;

  String htmlInfo = "";

  // 是否已经接受产品说明和合同
  bool _accept = false;

  void _loadLoginPhone() {
    global.getValueByKey("phone").then((value) {
      setState(() {
        _phone.text=value;
      });
    });
  }

  @override
  void initState() {
    _loadLoginPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ///提示是否退出
        DialogUtils.showConfirmDialog(context, "确认要退出应用吗?", "", () {
          exit(0);
        }, null);
      },
      child: Scaffold(
          appBar: AppBar(
            title: _buildTitle(),
            elevation: 0,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: _buildBody(),
            padding: new EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
          )),
    );
  }

  ///创建页面标题
  Widget _buildTitle() {
    const TextStyle textStyle = TextStyle(fontSize: 16);

    switch (_loginType) {
      case 0:
        return Text("免密码登录", style: textStyle);
      case 1:
        return Text("密码登录", style: textStyle);
      case 2:
        return Text("密码找回", style: textStyle);
      default:
        return Text("错误");
    }
  }

  ///创建页面内容
  Widget _buildBody() {
    if (_loginType == 0) {
      return _buildLoginBySms();
    } else if (_loginType == 1) {
      return _buildLoginByPwd();
    } else if (_loginType == 2) {
      return _buildForgetPwd();
    }
    return Text("错误");
  }

  ///免密登录页面
  Widget _buildLoginBySms() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            _buildPhone(),
            _buildSmsCode(),
            _buildAgreement(),
            SizedBox(
              height: 20,
            ),
            _buildLogin(),
            SizedBox(
              height: 10,
            ),
            _buildBottomBySms()
          ],
        ),
      ),
    );
  }

  ///密码登录页面
  Widget _buildLoginByPwd() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            _buildPhone(),
            _buildPwd(),
            _buildAgreement(),
            SizedBox(
              height: 20,
            ),
            _buildLogin(),
            SizedBox(
              height: 10,
            ),
            _buildBottomByPwd()
          ],
        ),
      ),
    );
  }

  ///忘记密码页面
  Widget _buildForgetPwd() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            _buildPhone(),
            _buildSmsCode(),
            _buildPwd(),
            _buildPwdRepeat(),
            SizedBox(
              height: 20,
            ),
            _buildResetPwd(),
            SizedBox(
              height: 10,
            ),
            _buildBottomByForgetPwd()
          ],
        ),
      ),
    );
  }

  ///创建手机号
  Widget _buildPhone() {
    return TextFormField(
      controller: _phone,
      keyboardType: TextInputType.number,
      maxLength: 11,
      decoration: InputDecoration(
          hintText: "请输入手机号",
          icon: Icon(
            Icons.phone_iphone,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          counterText: ""),
    );
  }

  ///创建验证码
  Widget _buildSmsCode() {
    return TextFormField(
      controller: _code,
      maxLength: 4,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "请输入验证码",
          icon: Icon(
            Icons.message,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          suffix: CodeButton(
            callback: _getSmsCode,
          ),
          counterText: ""),
    );
  }

  ///创建密码
  Widget _buildPwd() {
    return TextFormField(
      controller: _pwd,
      maxLength: 50,
      keyboardType: TextInputType.text,
      obscureText: _showPwd,
      decoration: InputDecoration(
          labelText: "密码",
          hintText: "请输入密码",
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _showPwd = !_showPwd;
                });
              }),
          counterText: ""),
    );
  }

  ///创建重复密码
  Widget _buildPwdRepeat() {
    return TextFormField(
      controller: _pwdRepeat,
      maxLength: 50,
      keyboardType: TextInputType.text,
      obscureText: _showPwd,
      decoration: InputDecoration(
          labelText: "确认密码",
          hintText: "请再次输入密码",
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _showPwd = !_showPwd;
                });
              }),
          counterText: ""),
    );
  }

  ///创建登录按钮
  Widget _buildLogin() {
    return CommonButton(text: "登录", onClick: _login);
  }

  ///创建重置密码按钮
  Widget _buildResetPwd() {
    return CommonButton(text: "重置密码", onClick: _resetPwd);
  }

  ///创建免密登录底部
  Widget _buildBottomBySms() {
    var text = Text("未注册手机验证后自动登录",
        style: TextStyle(fontSize: 12, color: Colors.grey));

    var btn = FlatButton(
      child: Text("密码登录", style: TextStyle(color: Colors.blue, fontSize: 14)),
      onPressed: () {
        _setLoginType(1);
      },
    );

    return Row(
      children: <Widget>[
        text,
        Expanded(
          child: Container(),
        ),
        btn
      ],
    );
  }

  ///创建密登录底部
  Widget _buildBottomByPwd() {
    var forgetBtn = FlatButton(
      onPressed: () {
        _setLoginType(2);
      },
      child: Text("忘记密码?", style: TextStyle(color: Colors.blue, fontSize: 14)),
    );
    var btn = FlatButton(
      child: Text("免密登录", style: TextStyle(color: Colors.blue, fontSize: 14)),
      onPressed: () {
        _setLoginType(0);
      },
    );
    return Row(
      children: <Widget>[
        forgetBtn,
        Expanded(
          child: Container(),
        ),
        btn
      ],
    );
  }

  ///创建忘记密码底部
  Widget _buildBottomByForgetPwd() {
    var btn1 = FlatButton(
      onPressed: () {
        _setLoginType(0);
      },
      child: Text("免密登录?", style: TextStyle(color: Colors.blue, fontSize: 14)),
    );
    var btn2 = FlatButton(
      child: Text("密码登录", style: TextStyle(color: Colors.blue, fontSize: 14)),
      onPressed: () {
        _setLoginType(1);
      },
    );
    return Row(
      children: <Widget>[
        btn1,
        Expanded(
          child: Container(),
        ),
        btn2
      ],
    );
  }

  /// 协议行
  Widget _buildAgreement() {
    return Row(
      children: <Widget>[
        new Checkbox(
          value: _accept,
          activeColor: Colors.blue,
          onChanged: (bool val) {
            // val 是布尔值
            this.setState(() {
              this._accept = !this._accept;
            });
          },
        ),
        Container(
          child: Text(
            '我已阅读和理解',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        GestureDetector(
          child: Text(
            '《用户注册协议》',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
          onTap: () {
            _toRegisterAgreement();
          },
        ),
        Text(
          '和',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        GestureDetector(
          child: Text(
            '《隐私政策》',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
          onTap: () {
            _toPrivacyAgreement();
          },
        ),
      ],
    );
  }

  ///发送验证码
  void _getSmsCode() async {
    if (_phone.text.length != 11) {
      DialogUtils.showAlertDialog(context, "提示", "请输入正确的手机号!", null,
          contentStyle: TextStyle(color: Colors.red));
      return;
    }
    var url = "";
    if (_loginType == 0) {
      //免密登录
      url = "login/wxSendSms/" + _phone.text;
    } else if (_loginType == 2) {
      //忘记密码
      url = "login/sendAppSms/" + _phone.text + "/updatePwd";
    }
    var response = await global.post(url);

    DataResponse d = DataResponse.fromJson(response);

    if (d.success()) {
      print("验证码发送成功!");
    }
  }

  ///切换登录方式
  void _setLoginType(int _loginType) {
    setState(() {
      _code.clear();
      _pwd.clear();
      _pwdRepeat.clear();
      this._loginType = _loginType;
    });
  }

  ///登录
  void _login() async {
    if (!_accept) {
      DialogUtils.showAlertDialog(context, "提示", "请阅读并同意《用户注册协议》和《隐私政策》", null,
          contentStyle: TextStyle(color: Colors.red));
      return;
    }

    if (_phone.text.length != 11) {
      DialogUtils.showAlertDialog(context, "提示", "请填写正确的手机号", null,
          contentStyle: TextStyle(color: Colors.red));
      return;
    }
    var url = "";
    var data;
    if (_loginType == 0) {
      //验证码登录
      if (_code.text.length != 4) {
        DialogUtils.showAlertDialog(context, "提示", "请填写正确的验证码", null,
            contentStyle: TextStyle(color: Colors.red));
        return;
      }
      url = "login/appRegister";
      data = {'phone': _phone.text, 'code': _code.text};
    } else if (_loginType == 1) {
      //密码登录
      if (_pwd.text.length < 6) {
        DialogUtils.showAlertDialog(context, "提示", "请填写正确密码", null,
            contentStyle: TextStyle(color: Colors.red));
        return;
      }
      url = "login/appLoginByPwd";
      data = {'phone': _phone.text, 'code': _pwd.text};
    }
    var response = await global.post(url, data);

    DataResponse d = DataResponse.fromJson(response);
    if (d.success()) {
      global.loadTokenAndUserInfo(d);
      _toLoginSuccessPage();
    } else {
      DialogUtils.showAlertDialog(context, "提示", d.msg, () {
        _code.clear();
        _pwd.clear();
      }, titleStyle: TextStyle(color: Colors.red));
    }
  }

  ///重置密码
  void _resetPwd() async {
    if (_phone.text.length != 11) {
      DialogUtils.showAlertDialog(context, "字段校验", "请填写正确的手机号", null,
          titleStyle: TextStyle(color: Colors.red));
      return;
    }
    if (_code.text.length != 4) {
      DialogUtils.showAlertDialog(context, "字段校验", "请填写正确的验证码", null,
          titleStyle: TextStyle(color: Colors.red));
      return;
    }
    if (_pwd.text.length < 6) {
      DialogUtils.showAlertDialog(context, "字段校验", "请填写正确密码", null,
          titleStyle: TextStyle(color: Colors.red));
      return;
    }
    if (_pwd.text != _pwdRepeat.text) {
      DialogUtils.showAlertDialog(context, "字段校验", "两次密码不一致", null,
          titleStyle: TextStyle(color: Colors.red));
      return;
    }
    var url = "login/resetPwd";
    var data = {"phone": _phone.text, "code": _code.text, "pwd": _pwd.text};
    var response = await global.post(url, data);
    DataResponse d = DataResponse.fromJson(response);
    if (d.success()) {
      DialogUtils.showAlertDialog(context, "提示", "重置密码成功", () {
        _code.clear();
        _pwd.clear();
        _pwdRepeat.clear();
        setState(() {
          _loginType = 1;
        });
      });
    } else {
      DialogUtils.showAlertDialog(context, "提示", d.msg, () {
        _code.clear();
        _pwd.clear();
        _pwdRepeat.clear();
      });
    }
  }

  ///去登录成功页面
  void _toLoginSuccessPage() {
    //跳转
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => RootScene()),
        (route) => route == null);
  }

  void _toRegisterAgreement() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return RegisterAgreementInfoPage(
        title: "用户注册协议",
        requestUrl: "agreement/register",
      );
    }));
  }

  void _toPrivacyAgreement() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return RegisterAgreementInfoPage(
        title: "隐私政策",
        requestUrl: "agreement/privacy",
      );
    }));
  }
}
