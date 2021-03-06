import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carloan/agreement/PersonalAgreementPageInfo.dart';
import 'package:flutter_carloan/app/DataResponse.dart';
import 'package:flutter_carloan/app/Global.dart';
import 'package:flutter_carloan/app/SysDict.dart';
import 'package:flutter_carloan/carInfo/CarInfoPage.dart';
import 'package:flutter_carloan/common/DialogUtils.dart';
import 'package:flutter_carloan/common/ShowPhoto.dart';
import 'package:flutter_carloan/userInfo/ClContactInfo.dart';
import 'package:flutter_carloan/userInfo/ClUserInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class UserInfoPage extends StatefulWidget {
  final String bizOrderNo;
  final int channelType;
  final int wxAppConfirm;

  /// 0:app进单 1：订单页查看详情 2：我的页面
  final int fromPage;

  const UserInfoPage(
      {Key key,
      this.bizOrderNo,
      this.channelType,
      this.fromPage,
      this.wxAppConfirm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  bool isReload = false;

  ///判断借款人身份是否为学生
  bool isStudent = false;

  ///专业
  String major = "";

  ///院校
  String college = "";

  String biz_order_no = "";

  String userName = "";
  String idCard = "";
  String idCardAddress = "";
  String residentialAddress = "";
  String phoneNo = "";

  ///婚姻状况
  List maritalList = new List();
  int maritalValue;
  var mariLabel = "";

  ///健康状况
  int healthValue;
  var healthLabel = "";
  List healthList = new List();

  ///身份类型
  int identityTypeValue;
  var identityTypeLabel = "";
  List identityTypeList = new List();

  ///最高学历
  int degreeValue;
  var degreeLabel = "";
  List degreeList = new List();

  ///客户职业信息
  int customerInfoValue;
  var customerInfoLabel = "";
  List customerInfoList = new List();

  ///开户行
  String bankName = "";
  List bankNameList = new List();
  int bankNameValue = 0;

  ///银行卡类型
  int bankCardValue;
  var bankCardLabel = "";
  List bankCardList = new List();

  ///联系人关系
  String contactPhone = "";
  String contactName = "";
  List<ClContactInfo> contractLists = new List();

  int relationShipValue;
  var relationShipLabel = "";
  List relationShipList = new List();

  String companyName = "";
  String companyAddress = "";
  String companyPhone = "";
  String wxNumber = "";
  String personalIncome = "";
  String reservePhoneNo = "";
  String bankAccount = "";

  String _time = "2019-02-22";

  List<String> idCardImageList = new List();

  String openId = "";

  String defaultImageUrl =
      "http://106.14.239.49/group1/M00/04/4D/ag7vMVxuXfyAVvLmAAADgDq1o2k710.png";

  ///附件存在哪张表
  int formType = 0;

  ///控制输入框是否允许输入
  bool canWrite = false;

  String buttonName = "下一步";

  ///借款用途
  List<String> borrowUse = [
    '请选择',
    '消费',
    '汽车',
    '医美',
    '旅游',
    '教育',
    '3C',
    '家装',
    '租房',
    '租赁',
    '农业'
  ];
  String borrowUseLabel = "请选择";
  int borrowUseValue = 0;

  ///是否接受协议
  bool _accept = false;

  @override
  Widget build(BuildContext context) {
    _getUserInfo(widget.bizOrderNo, widget.channelType, widget.fromPage);

    ///婚姻状况
    if (maritalList.length > 0) {
      for (int i = 0; i < maritalList.length; i++) {
        if (maritalValue == int.parse(maritalList[i].value)) {
          mariLabel = maritalList[i].label;
        }
      }
    }

    ///健康状况
    if (healthList.length > 0) {
      for (int i = 0; i < healthList.length; i++) {
        if (healthValue == int.parse(healthList[i].value)) {
          healthLabel = healthList[i].label;
        }
      }
    }

    ///身份类型
    if (identityTypeList.length > 0) {
      for (int i = 0; i < identityTypeList.length; i++) {
        if (identityTypeValue == int.parse(identityTypeList[i].value)) {
          identityTypeLabel = identityTypeList[i].label;
        }
      }
    }

    ///最高学历
    if (degreeList.length > 0) {
      for (int i = 0; i < degreeList.length; i++) {
        if (degreeValue == int.parse(degreeList[i].value)) {
          degreeLabel = degreeList[i].label;
        }
      }
    }

    ///客户职业信息
    if (customerInfoList.length > 0) {
      for (int i = 0; i < customerInfoList.length; i++) {
        if (customerInfoValue == int.parse(customerInfoList[i].value)) {
          customerInfoLabel = customerInfoList[i].label;
          if (customerInfoLabel.length > 10) {
            customerInfoLabel = customerInfoLabel.substring(0, 10) + "....";
          }
        }
      }
    }

    ///银行卡类型
    if (bankCardList.length > 0) {
      for (int i = 0; i < bankCardList.length; i++) {
        if (bankCardValue == int.parse(bankCardList[i].value)) {
          bankCardLabel = bankCardList[i].label;
        }
      }
    }

    ///联系人关系
    if (relationShipList.length > 0) {
      for (int i = 0; i < relationShipList.length; i++) {
        if (relationShipValue == int.parse(relationShipList[i].value)) {
          relationShipLabel = relationShipList[i].label;
        }
      }
    }

    ///银行名
    if (bankNameList.length > 0) {
      if (bankNameValue >= 0) {
        bankName = bankNameList[bankNameValue];
      }
    }

    List<Widget> list = <Widget>[
      new Container(
        height: 24.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('      信息有误请及时联系客户经理修改',
                  style: TextStyle(
                      fontSize: 12.0, color: const Color(0xffAAAAAA))),
            ),
          ],
        ),
      ),

      ///真实姓名
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '真实姓名',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                enabled: canWrite,
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$userName",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  userName = text;
                },
              ),
            ),
          ],
        ),
      ),

      _buildCommonLine(),

      ///身份证号
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '身份证号',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                enabled: canWrite,
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$idCard",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(18),
                ],
                maxLines: 1,
                onChanged: (text) {
                  idCard = text;
                },
              ),
            ),
          ],
        ),
      ),

      _buildCommonLine(),

      ///身份证地址
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '身份证地址',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$idCardAddress",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  idCardAddress = text;
                },
              ),
            ),
          ],
        ),
      ),

      _buildCommonLine(),

      ///现居地址
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '现居地址',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$residentialAddress",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  residentialAddress = text;
                },
              ),
            ),
          ],
        ),
      ),

      _buildCommonLine(),

      ///手机号码
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '手机号码',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                enabled: canWrite,
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$phoneNo",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                maxLines: 1,
                onChanged: (text) {
                  phoneNo = text;
                },
              ),
            ),
          ],
        ),
      ),

      _buildCommonLine(),

      ///健康状况
      new GestureDetector(
        onTap: _showCheckHealDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '健康状况',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$healthLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///身份类型
      new GestureDetector(
        onTap: _showIdentityTypeDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '身份类型',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$identityTypeLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildColleges(),

      _buildCommonLine(),

      _buildMajor(),

      _buildCommonLine(),

      ///最高学历
      new GestureDetector(
        onTap: _showDegreeTypeDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '最高学历',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$degreeLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///公司名称
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '公司名称',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$companyName",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  companyName = text;
                },
              ),
            ),
          ],
        ),
      ),

      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '公司地址',
                style:
                TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$companyAddress",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  companyAddress = text;
                },
              ),
            ),
          ],
        ),
      ),

      _buildCommonLine(),

      ///客户职业信息
      new GestureDetector(
        onTap: _showCustomInfoDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '客户职业信息',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$customerInfoLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///公司电话
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '公司电话',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "$companyPhone",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  maxLines: 1,
                  onChanged: (text) {
                    companyPhone = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///证件到期日期
      new GestureDetector(
        onTap: _showDataPicker,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '证件到期日期',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$_time',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///开户行
      new GestureDetector(
        onTap: _showBankTypeDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '开户行',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$bankName',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///银行卡类型
      new GestureDetector(
        onTap: _showBankCardTypeDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '银行卡类型',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$bankCardLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///银行卡号
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '银行卡号',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "$bankAccount",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19),
                  ],
                  maxLines: 1,
                  onChanged: (text) {
                    bankAccount = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///预留手机号
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '预留手机号',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "$reservePhoneNo",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  onChanged: (text) {
                    reservePhoneNo = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///个人总收入（元/月）
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '个人总收入(元/月)',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "$personalIncome",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  maxLines: 1,
                  onChanged: (text) {
                    personalIncome = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///微信
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '微信',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Expanded(
                child: TextField(
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "$wxNumber",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (text) {
                    wxNumber = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///婚姻状况
      new GestureDetector(
        onTap: _showCheckMarDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '婚姻状况',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$mariLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///借款用途
      new GestureDetector(
        onTap: _showBorrowUseDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '借款用途',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  borrowUse[borrowUseValue],
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      _buildCommonLine(),

      ///联系人
      new Container(
        height: 50.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('      联系人信息',
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ],
        ),
      ),

      _buildContractInfo(),

      ///联系人姓名
      //_buildContractName(),

      _buildCommonLine(),

      ///联系人电话
      //_buildContractPhone(),

      _buildCommonLine(),

      ///联系人关系
      // _buildContractRelationShip(),

      ///分隔阴影
      new Container(
        height: 50.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('      身份证正反面',
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ],
        ),
      ),

      ///身份证正反面
      new Container(
        height: 140.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new GridView.count(
                  physics: new NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 4.0,
                  padding: const EdgeInsets.all(4.0),
                  childAspectRatio: 1.5,
                  children: idCardImageList.map((f) {
                    return new GestureDetector(
                        onTap: () {
                          if (biz_order_no != '' && biz_order_no != null) {
                            var index = idCardImageList.indexOf(f);
                            if (defaultImageUrl == f) {
                              showModalBottomSheetDialog(context, index, f);
                            } else {
                              if (widget.wxAppConfirm == 0) {
                                showModalBottomSheetDialog(context, index, f);
                              } else {
                                showPhoto(context, f, index);
                              }
                            }
                          }
                        },
                        child: new Container(
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                width: 1.0, color: Colors.black38),
                            image: new DecorationImage(
                              image: new NetworkImage(f),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),

      ///分隔阴影
      new Container(
        height: 20.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text("",
                  style: TextStyle(fontSize: 12.0, color: Colors.black)),
            ),
          ],
        ),
      ),

      _buildAgreement(),


      ///按钮
      new Padding(
        padding: new EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  _saveUserInfo();
                },
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                //通过控制 Text 的边距来控制控件的高度
                child: new Padding(
                  padding: new EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                  child: new Text(
                    buttonName,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    ];

    ///_getUserInfo();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '个人信息',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: new Center(
          child: new ListView(children: list),
        ));
  }

  /// 展示选择婚姻状况的弹窗
  _showCheckMarDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(maritalList, "marital_status_flag",
                      maritalValue, context)),
            ),
            /* children: listViewDefault(),*/
          );
        });
  }

  ///展示健康状况的弹窗
  void _showCheckHealDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(
                      healthList, "health_status_flag", healthValue, context)),
            ),
          );
        });
  }

  ///身份类型弹窗
  _showIdentityTypeDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(identityTypeList,
                      "identity_type_flag", identityTypeValue, context)),
            ),
          );
        });
  }

  _showDegreeTypeDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(
                      degreeList, "degree_flag", degreeValue, context)),
            ),
          );
        });
  }

  void _showCustomInfoDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(
                      customerInfoList,
                      "customer_professional_info_flag",
                      customerInfoValue,
                      context)),
            ),
          );
        });
  }

  void _showBankCardTypeDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(bankCardList, "bank_card_type_flag",
                      bankCardValue, context)),
            ),
          );
        });
  }

  void _showBankTypeDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(
                      bankNameList, "bank_name_flag", bankNameValue, context)),
            ),
          );
        });
  }

  void _showBorrowUseDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new ListView(
                  children: listViewDefault(
                      borrowUse, "borrow_use", borrowUseValue, context)),
            ),
          );
        });
  }

  ///时间选择
  _showDataPicker() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2019, 1, 1),
        maxTime: DateTime(2099, 6, 7),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        _time = date.toString().substring(0, 10);
      });
    }, currentTime: DateTime.now(), locale: LocaleType.zh);
  }

  ///公共弹窗
  listViewDefault(
      List sysDictList, String type, int dataValue, BuildContext context) {
    List<Widget> data = new List();
    if (type == "bank_name_flag") {
      for (int i = 0; i < sysDictList.length; i++) {
        data.add(
          new RadioListTile<int>(
            title: new Text(sysDictList[i]),
            value: i,
            groupValue: dataValue,
            onChanged: (int e) => updateDefaultDialogValue(e, type, context),
          ),
        );
      }
    } else if (type == "borrow_use") {
      for (int i = 1; i < sysDictList.length; i++) {
        data.add(
          new RadioListTile<int>(
            title: new Text(sysDictList[i]),
            value: i,
            groupValue: dataValue,
            onChanged: (int e) => updateDefaultDialogValue(e, type, context),
          ),
        );
      }
    } else {
      for (int i = 0; i < sysDictList.length; i++) {
        data.add(
          new RadioListTile<int>(
            title: new Text(sysDictList[i].label),
            value: int.parse(sysDictList[i].value),
            groupValue: dataValue,
            onChanged: (int e) => updateDefaultDialogValue(e, type, context),
          ),
        );
      }
    }

    return data;
  }

  ///公共弹窗返回值
  updateDefaultDialogValue(int e, String type, BuildContext context) {
    setState(() {
      switch (type) {
        case 'health_status_flag':
          this.healthValue = e;
          break;
        case 'identity_type_flag':
          this.identityTypeValue = e;
          break;
        case 'degree_flag':
          this.degreeValue = e;
          break;
        case 'customer_professional_info_flag':
          this.customerInfoValue = e;
          break;
        case 'bank_card_type_flag':
          this.bankCardValue = e;
          break;
        case 'bank_name_flag':
          this.bankNameValue = e;
          break;
        case 'marital_status_flag':
          this.maritalValue = e;
          break;
        case 'contact_relationship_flag':
          this.relationShipValue = e;
          break;
        case 'borrow_use':
          this.borrowUseValue = e;
          break;
      }

      if (this.identityTypeValue == 2) {
        this.isStudent = true;
      } else {
        this.isStudent = false;
        this.major = "";
        this.college = "";
      }
    });
    Navigator.pop(context);
  }

  ///图片预览
  void showPhoto(BuildContext context, f, index) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('图片预览')),
        body: SizedBox.expand(
          child: Hero(
            tag: index,
            child: ShowPhotoPage(url: f),
          ),
        ),
      );
    }));
  }

  Global global = Global();

  ///已存在订单时获取信息
  _getUserInfo(String bizOrderNo, int channelType, int fromPage) async {
    if (!isReload) {
      isReload = true;
      try {
        Map<String, Object> dataMap = new Map();
        List maritalStatusList = new List();
        List healthStatusList = new List();
        List identityTypeStatusList = new List();
        List degreeStatusList = new List();
        List customerInfoStatusList = new List();
        List bankCardStatusList = new List();
        List relationShipStatusList = new List();
        List bankStatusList = new List();
        List contactInfoList = new List();
        List idCraUrlList = new List();
        ClUserInfo clUserInfo;
        var borrow_usage;

        if (fromPage == 2 || fromPage == 1) {
          ///我的页面进入查看个人资料
          biz_order_no = bizOrderNo;
          if (biz_order_no == '' || biz_order_no == null) {
            buttonName = "返回";
            setState(() {
              for (int i = 0; i < 2; i++) {
                idCardImageList.add(defaultImageUrl);
              }
            });
            return;
          }
          var response = await global.postFormData("user/query",
              {"biz_order_no": bizOrderNo, "channel_type": channelType});
          dataMap = response['dataMap'];
          clUserInfo = ClUserInfo.fromJson(dataMap["clUserInfo"]);
          contactInfoList = dataMap["clContactInfoList"];

          Map clBaseInfo = dataMap['clBaseInfo'] as Map;
          borrow_usage = clBaseInfo['borrow_usage'];

          ///此处联系人只取一个展示
          idCraUrlList = dataMap["clAttachmentInfoList"];
          if (fromPage == 2) {
            if (widget.wxAppConfirm == 1) {
              buttonName = "返回";
            } else {
              buttonName = "修改";
            }
          }
        } else {
          canWrite = true;

          ///此处openId使用 token
          openId = global.token.token;
          var response = await global.postFormData(
              "borrow/toBorrow/" + openId + "/" + global.DEVICE.toString());
          dataMap = response['dataMap'];
          bizOrderNo = dataMap['biz_order_no'];
          if (bizOrderNo != "" && bizOrderNo != null) {
            ///第一次进单
            biz_order_no = bizOrderNo;
          } else {
            ///非第一次进单
            clUserInfo = ClUserInfo.fromJson(dataMap["clUserInfo"]);
            biz_order_no = clUserInfo.biz_order_no;
            contactInfoList = dataMap["clContactInfo"];
            idCraUrlList = dataMap["attachmentInfoList"];
            Map riskData = dataMap['clBaseInfo'] as Map;
            borrow_usage = riskData['borrow_usage'].toString();
          }
        }

        ///此处为公用的选择框数据
        degreeStatusList = dataMap["degree"];
        maritalStatusList = dataMap["marital_status"];
        healthStatusList = dataMap["health"];
        identityTypeStatusList = dataMap["identity_type"];
        customerInfoStatusList = dataMap["customerInfo"];
        bankCardStatusList = dataMap["bankCards"];
        relationShipStatusList = dataMap["relationShip"];
        bankStatusList = dataMap["bank_list"];

        setState(() {
          if (clUserInfo != null) {
            userName = clUserInfo.user_name;
            idCard = clUserInfo.idcard;
            idCardAddress = clUserInfo.idcard_address;
            residentialAddress = clUserInfo.residential_address;
            phoneNo = clUserInfo.phone_no;
            companyName = clUserInfo.company_name;
            companyAddress = clUserInfo.company_address;
            companyPhone = clUserInfo.company_phone_no;
            if (clUserInfo.wechat != null) {
              wxNumber = clUserInfo.wechat;
            }
            personalIncome = clUserInfo.personal_income.toString();
            bankAccount = clUserInfo.bank_account;
            reservePhoneNo = clUserInfo.reserve_phone_no;
            bankName = clUserInfo.bank_name;
            _time = clUserInfo.certificate_expiry_date;

            maritalValue = int.parse(clUserInfo.marital_status);
            healthValue = int.parse(clUserInfo.health_status);
            identityTypeValue = int.parse(clUserInfo.identity_type);
            if (identityTypeValue == 2) {
              isStudent = true;
              major = clUserInfo.major;
              college = clUserInfo.colleges;
            }
            degreeValue = int.parse(clUserInfo.degree);
            customerInfoValue =
                int.parse(clUserInfo.customer_professional_info);
            bankCardValue = int.parse(clUserInfo.bank_card_type);
            borrowUseValue = int.parse(borrow_usage);
            borrowUseLabel = borrowUse[borrowUseValue];
          }

          ///联系人
          if (contactInfoList.length > 0) {
            for (int i = 0; i < contactInfoList.length; i++) {
              ClContactInfo contactInfo = new ClContactInfo();
              contactInfo.contactName = contactInfoList[i]["contact_name"];
              contactInfo.contactPhone = contactInfoList[i]["contact_phone"];
              contactInfo.contactRelationship =
                  contactInfoList[i]["contact_relationship"];
              contractLists.add(contactInfo);
            }
          } else {
            ClContactInfo contactInfo = new ClContactInfo();
            contactInfo.contactName = "";
            contactInfo.contactPhone = "";
            contactInfo.contactRelationship = "";
            contractLists.add(contactInfo);
          }

          bankNameList = bankStatusList;
          bankNameValue = bankStatusList.indexOf(bankName);

          ///婚姻状况
          List<SysDict> maritalLists = new List();
          for (int i = 0; i < maritalStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = maritalStatusList[i]["value"];
            sysDict.label = maritalStatusList[i]["label"];
            maritalLists.add(sysDict);
          }
          maritalList = maritalLists;

          ///健康状况
          List<SysDict> healthLists = new List();
          for (int i = 0; i < healthStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = healthStatusList[i]["value"];
            sysDict.label = healthStatusList[i]["label"];
            healthLists.add(sysDict);
          }
          healthList = healthLists;

          ///身份类型
          List<SysDict> identityTypes = new List();
          for (int i = 0; i < identityTypeStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = identityTypeStatusList[i]["value"];
            sysDict.label = identityTypeStatusList[i]["label"];
            identityTypes.add(sysDict);
          }
          identityTypeList = identityTypes;

          ///最高学历
          List<SysDict> degreeLists = new List();
          for (int i = 0; i < degreeStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = degreeStatusList[i]["value"];
            sysDict.label = degreeStatusList[i]["label"];
            degreeLists.add(sysDict);
          }
          degreeList = degreeLists;

          ///银行卡类型
          List<SysDict> bankCards = new List();
          for (int i = 0; i < bankCardStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = bankCardStatusList[i]["value"];
            sysDict.label = bankCardStatusList[i]["label"];
            bankCards.add(sysDict);
          }
          bankCardList = bankCards;

          ///客户职业信息
          List<SysDict> customerInfos = new List();
          for (int i = 0; i < customerInfoStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = customerInfoStatusList[i]["value"];
            sysDict.label = customerInfoStatusList[i]["label"];
            customerInfos.add(sysDict);
          }
          customerInfoList = customerInfos;

          ///联系人关系
          List<SysDict> relationShips = new List();
          for (int i = 0; i < relationShipStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.value = relationShipStatusList[i]["value"];
            sysDict.label = relationShipStatusList[i]["label"];
            relationShips.add(sysDict);
          }
          relationShipList = relationShips;

          ///身份证
          if (idCraUrlList.length == 0) {
            for (int i = 0; i < 2; i++) {
              idCardImageList.add(defaultImageUrl);
            }
          }
          if (idCraUrlList.length == 1) {
            String filePath = idCraUrlList[0]["file_path"];
            idCardImageList.add(filePath);
            idCardImageList.add(defaultImageUrl);
          }
          //只取前两张
          if (idCraUrlList.length > 1) {
            for (int i = 0; i < 2; i++) {
              String filePath = idCraUrlList[i]["file_path"];
              idCardImageList.add(filePath);
            }
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  ///信息保存
  Future _saveUserInfo() async {
    if (widget.wxAppConfirm == 1 || biz_order_no == null) {
      Navigator.of(context).pop();
      return;
    }

    if(!_accept){
      DialogUtils.showAlertDialog(context, "提示", "请阅读并同意《个人信息授权协议》", null);
      return;
    }

    if (userName.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "真实姓名不能为空", null);
      return;
    }

    if (idCard.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "身份证不能为空", null);
      return;
    } else {
      RegExp postalCode = new RegExp(
          r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
      if (!postalCode.hasMatch(idCard)) {
        DialogUtils.showAlertDialog(context, "提示", "身份证格式错误", null);
        return;
      }

      int year = int.parse(idCard.substring(6, 10));
      int currentYear = DateTime.now().year;
      if ((currentYear - year > 55) || (currentYear - year < 23)) {
        DialogUtils.showAlertDialog(context, "提示", "借款年龄大于55或小于23", null);
        return;
      }
    }

    if (idCardAddress.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "身份证地址不能为空", null);
      return;
    }

    if (residentialAddress.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "现居住地址不能为空", null);
      return;
    }

    if (phoneNo.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "手机号码不能为空", null);
      return;
    }

    if (healthLabel.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "健康状况不能为空", null);
      return;
    }

    if (identityTypeLabel.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "身份类型不能为空", null);
      return;
    }

    if (identityTypeValue == 2) {
      if (college.isEmpty) {
        DialogUtils.showAlertDialog(context, "提示", "院校信息不能为空", null);
        return;
      }
      if (major.isEmpty) {
        DialogUtils.showAlertDialog(context, "提示", "专业信息不能为空", null);
        return;
      }
    }

    if (degreeLabel.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "最高学历不能为空", null);
      return;
    }

    if (companyName.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "公司名不能为空", null);
      return;
    }

    if(companyAddress.isEmpty){
      DialogUtils.showAlertDialog(context, "提示", "公司地址不能为空", null);
      return;
    }

    if (customerInfoLabel.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "客户职业信息不能为空", null);
      return;
    }

    if (companyPhone.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "公司号码不能为空", null);
      return;
    }

    if (bankCardLabel.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "银行卡类型不能为空", null);
      return;
    }

    if (bankAccount.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "银行卡号不能为空", null);
      return;
    }

    if (reservePhoneNo.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "预留手机号不能为空", null);
      return;
    }

    if (personalIncome.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "个人收入不能为空", null);
      return;
    }

    if (mariLabel.isEmpty) {
      DialogUtils.showAlertDialog(context, "提示", "婚姻状况不能为空", null);
      return;
    }

    if (idCardImageList.contains(defaultImageUrl)) {
      DialogUtils.showAlertDialog(context, "提示", "请上传身份证正反面", null);
      return;
    }

    if (borrowUseValue <= 0) {
      DialogUtils.showAlertDialog(context, "提示", "请选择贷款用途", null);
      return;
    }

    String url = "user/save";
    if (widget.fromPage == 0) {
      url = "borrow/saveUserInfo";
    }
    var contractList = new List();

    int length = contractLists.length;
    for (int i = 0; i < length; i++) {
      var contractMap = new Map();
      contractMap['biz_order_no'] = biz_order_no;
      contractMap['contact_name'] = contractLists[i].contactName;
      contractMap['contact_phone'] = contractLists[i].contactPhone;
      contractMap['contact_relationship'] =
          contractLists[i].contactRelationship;
      contractList.add(contractMap);
    }

    try {
      var response = await global.postFormData(url, {
        "clUserInfo": {
          "channel_type": widget.channelType,
          "biz_order_no": biz_order_no,
          "user_name": userName,
          "idcard": idCard,
          "idcard_address": idCardAddress,
          "residential_address": residentialAddress,
          "phone_no": phoneNo,
          "health_status": healthValue,
          "identity_type": identityTypeValue,
          "degree": degreeValue,
          "company_name": companyName,
          "company_address": companyAddress,
          "customer_professional_info": customerInfoValue,
          "company_phone_no": companyPhone,
          "certificate_expiry_date": _time,
          "bank_name": bankNameValue,
          "bank_card_type": bankCardValue,
          "bank_account": bankAccount,
          "reserve_phone_no": reservePhoneNo,
          "personal_income": personalIncome,
          "wechat": wxNumber,
          "marital_status": maritalValue,
          "major": major,
          "colleges": college
        },
        "clBaseInfo": {
          "openid": global.token.token,
          "biz_order_no": biz_order_no,
          "borrow_usage": borrowUseValue
        },
        "contactInfo": contractList
      });

      if (response["code"] == 0) {
        setState(() {
          global.user.idCard = idCard;
        });

        ///如果是从我的页面进入就弹出修改成功的提示框
        if (widget.fromPage == 2) {
          DialogUtils.showAlertDialog(context, "提示", "修改成功", null);
        } else {
          ///跳转到车辆信息页面
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return CarInfoPage(
                bizOrderNo: biz_order_no,
                channelType: widget.channelType,
                fromPage: widget.fromPage,
                wxAppConfirm: widget.wxAppConfirm);
          }));
        }
      } else {
        DialogUtils.showAlertDialog(context, "提示", response['msg'], null);
      }
    } catch (e) {
      DialogUtils.showAlertDialog(context, "提示", "保存失败", null);
    }
  }

  ///图片上传公用方法
  void _uploadImage(File imageFile, int index, String f) async {
    if (imageFile == null) {
      return;
    }
    if (widget.fromPage != 0) {
      formType = 1;
    }
    String fileType = "1";
    FormData formData = new FormData.from({
      "biz_order_no": biz_order_no,
      "file_type": fileType,
      "formType": formType,
      "file_path": f,
      "channel_type": widget.channelType
    });
    if (imageFile != null) {
      formData.add("file", new UploadFileInfo(imageFile, "身份证正反面.png"));
    }
    var response =
        await global.postFormData("attachmentInfo/uploadFile", formData);
    DataResponse dataResponse = DataResponse.fromJson(response);
    Map<String, Object> map = dataResponse.entity as Map;
    String filePath = map['file_path'];
    setState(() {
      idCardImageList[index] = filePath;
    });
  }

  showModalBottomSheetDialog(BuildContext context, int index, String f) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text("相机", textAlign: TextAlign.left),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera, imageQuality: global.imageQuality)
                      .then((onValue) {
                    _uploadImage(onValue, index, f);
                  });
                  Navigator.pop(context);
                },
              ),
              new Container(
                height: 1.0,
                color: Colors.grey,
              ),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text("相册", textAlign: TextAlign.left),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: global.imageQuality)
                      .then((onValue) {
                    _uploadImage(onValue, index, f);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _buildColleges() {
    if (this.isStudent) {
      return new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '院校',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$college",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  college = text;
                },
              ),
            ),
          ],
        ),
      );
    }
    return new Container(
      height: 1.0,
      color: Colors.white,
    );
  }

  _buildMajor() {
    if (this.isStudent) {
      return new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '专业',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "$major",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  major = text;
                },
              ),
            ),
          ],
        ),
      );
    }
    return new Container(
      height: 1.0,
      color: Colors.white,
    );
  }

  _buildCommonLine() {
    return new Container(
      margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      height: 1.0,
      color: const Color(0xffebebeb),
    );
  }

  _buildContractName(int index, String contractName) {
    return new GestureDetector(
      child: new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 45.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '联系人' + (index + 1).toString() + '姓名',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: contractName,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  _updateContractList(index, text, "contact_name");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildContractPhone(int index, String contactPhone) {
    return new GestureDetector(
      child: new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 45.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '联系人' + (index + 1).toString() + '电话',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Expanded(
              child: TextField(
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: contactPhone,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                keyboardType: TextInputType.phone,
                maxLines: 1,
                onChanged: (text) {
                  _updateContractList(index, text, "contact_phone");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildContractRelationShip(int index, String contactRelationship) {
    if (contactRelationship != "" && contactRelationship != null) {
      var relationShipValue = int.parse(contactRelationship);
      if (relationShipList.length > 0) {
        for (int i = 0; i < relationShipList.length; i++) {
          if (relationShipValue == int.parse(relationShipList[i].value)) {
            relationShipLabel = relationShipList[i].label;
          }
        }
      }
    }
    return new GestureDetector(
      onTap: () {
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: true,
            builder: (BuildContext context) {
              return new Dialog(
                child: new Container(
                  width: 300.0,
                  height: 230.0,
                  color: Colors.white,
                  child: new ListView(
                      children: showSelectRelationShipDialog(
                          relationShipList,
                          "contact_relationship_flag",
                          relationShipValue,
                          context,
                          index)),
                ),
              );
            });
      },
      child: new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
        height: 45.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '联系人' + (index + 1).toString() + '关系',
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
              child: new Text(
                relationShipLabel,
                style:
                    TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildContractInfo() {
    var height = 200.0;
    if (contractLists.length <= 1) {
      height = 150.0;
    }
    List<Widget> _list = new List();
    int length = contractLists.length;
    for (int i = 0; i < length; i++) {
      _list.add(_buildContent(i));
    }
    return new SizedBox(
      height: height,
      child: new ListView(
        children: _list,
      ),
    );
  }

  _buildContent(int i) {
    return new SizedBox(
      height: 150.0, //设置高度
      child: new Card(
        child: new Column(
          // card只能有一个widget，但这个widget内容可以包含其他的widget
          children: [
            _buildContractName(i, contractLists[i].contactName),
            _buildCommonLine(),
            _buildContractPhone(i, contractLists[i].contactPhone),
            _buildCommonLine(),
            _buildContractRelationShip(i, contractLists[i].contactRelationship),
          ],
        ),
      ),
    );
  }

  void _updateContractList(int index, String text, String type) {
    if (type == "contact_name") {
      setState(() {
        contractLists[index].contactName = text;
      });
    }
    if (type == "contact_phone") {
      setState(() {
        contractLists[index].contactPhone = text;
      });
    }
  }

  showSelectRelationShipDialog(List sysDictList, String type, int dataValue,
      BuildContext context, int index) {
    List<Widget> data = new List();

    for (int i = 0; i < sysDictList.length; i++) {
      data.add(
        new RadioListTile<int>(
          title: new Text(sysDictList[i].label),
          value: int.parse(sysDictList[i].value),
          groupValue: dataValue,
          onChanged: (int e) =>
              updateRelationShipValue(e, type, context, index),
        ),
      );
    }
    return data;
  }

  updateRelationShipValue(int e, String type, BuildContext context, int index) {
    setState(() {
      contractLists[index].contactRelationship = e.toString();
    });
    Navigator.pop(context);
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
            '《个人信息授权协议》',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
          onTap: () {
            _toPersonalAgreement();
          },
        ),
      ],
    );
  }

  void _toPersonalAgreement() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PersonalAgreementInfoPage(idCard: idCard,);
    }));
  }
}
