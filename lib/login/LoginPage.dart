import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_carloan/common/DataResponse.dart';
import 'package:flutter_carloan/common/Global.dart';
import 'package:flutter_carloan/common/Token.dart';
import 'package:flutter_carloan/common/User.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => LoginPageStateful();
}

class LoginPageStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPageStateful> {
  Global global = Global();

  ///手机号
  TextEditingController phone = TextEditingController();
  TextEditingController code = TextEditingController();
  int seconds = 0;
  Timer timer;

  ///验证码
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登陆"),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        TextField(
            controller: phone,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "请输入手机号",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey))),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: code,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: "请输入短信验证码",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            CodeBotton(
              onPressed: getSmsCode,
              coldDownSeconds: seconds,
            )
          ],
        ),
        FlatButton(
          onPressed: login,
          child: Text(
            "登陆",
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
        )
      ],
    );
  }

  Future login() async {
    if (phone.text.length == 11 && code.text.length == 4) {
      var response = await global.post("login/appRegister",
          {'phone': phone.text, 'invitation_code': code.text});
      print(response);
      DataResponse d = DataResponse.fromJson(json.decode(response));
      if (d.success()) {
        Map<String, String> map = d.entity as Map;
        //将用户信息写入global
        User user = User.fromJson(map);
        global.user = user;
        //将token信息写入global
        Token token = Token.parseToken(map['token'] + map['expire']);
        token.writeToken();
        global.token = token;
        //跳转

      }
    }
  }

  void getSmsCode() async {
    if (phone.text.length != 11) {
      return;
    }
    var response = await global.post("login/wxSendSms/" + phone.text);

    DataResponse d = DataResponse.fromJson(json.decode(response));

    if (d.success()) {
      setState(() {
        seconds = 10;
      });
      secondUpdate();
    }
  }

  void secondUpdate() {
    timer = Timer(Duration(seconds: 1), () {
      setState(() {
        --seconds;
      });
      secondUpdate();
    });
  }
}

class CodeBotton extends StatelessWidget {
  final VoidCallback onPressed;

  final int coldDownSeconds;

  const CodeBotton({Key key, this.onPressed, this.coldDownSeconds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (coldDownSeconds > 0) {
      return Container(
        width: 95,
        child: Center(
          child: Text('${coldDownSeconds}',
              style: TextStyle(fontSize: 14, color: Colors.black)),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 95,
        child: Text(
          "获取验证码",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.green),
        ),
      ),
    );
  }
}
