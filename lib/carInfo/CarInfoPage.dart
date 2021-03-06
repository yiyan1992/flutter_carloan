import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carloan/app/DataResponse.dart';
import 'package:flutter_carloan/app/SysDict.dart';
import 'package:flutter_carloan/common/DialogUtils.dart';
import 'package:flutter_carloan/common/ShowPhoto.dart';
import 'package:flutter_carloan/carInfo/ClCarInfo.dart';
import 'package:flutter_carloan/app/Global.dart';
import 'package:flutter_carloan/faceValidate/faceValidatePage.dart';
import 'package:flutter_carloan/sign/SignPage.dart';
import 'package:image_picker/image_picker.dart';

class CarInfoPage extends StatefulWidget {
  final String bizOrderNo;
  final int channelType;
  final int wxAppConfirm;

  /// 0:app进单 1：订单页查看详情 2：我的页面
  final int fromPage;

  const CarInfoPage(
      {Key key,
      this.bizOrderNo,
      this.channelType,
      this.fromPage,
      this.wxAppConfirm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _CarInfoPageState();
  }
}

class _CarInfoPageState extends State<CarInfoPage> {
  bool isReload = false;
  bool isSubmit = false;
  String carNo = "";
  String carBrand = "";
  String carModel = "";
  String carModelSub = "";
  String carColor = "";
  String carFrameNo = "";
  String carEngineNo = "";
  String carServiceLife = "";
  String carDrivingMileage = "";
  String carCost = "";

  int majorAccident;
  String majorAccidentLabel = "";

  int accidentTypeValue;
  String accidentTypeLabel = "";
  List accidentTypeList = new List();

  List<String> carImageList = new List();
  List<String> registerImageList = new List();
  List<String> driveImageList = new List();

  String defaultImageUrl =
      "http://106.14.239.49/group1/M00/04/4D/ag7vMVxuXfyAVvLmAAADgDq1o2k710.png";

  ///0： 保存到微信表 1：保存temp表
  int formType = 0;

  String buttonName = "下一步";

  @override
  Widget build(BuildContext context) {
    _getCarInfo(widget.bizOrderNo, widget.channelType);

    ///事故类型
    if (accidentTypeList.length > 0) {
      for (int i = 0; i < accidentTypeList.length; i++) {
        if (accidentTypeValue == int.parse(accidentTypeList[i].value)) {
          accidentTypeLabel = accidentTypeList[i].label;
        }
      }
    }

    List<Widget> list = <Widget>[
      new Container(
        height: 4.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('',
                  style: TextStyle(
                      fontSize: 12.0, color: const Color(0xffAAAAAA))),
            ),
          ],
        ),
      ),

      ///车牌号码
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '车牌号码',
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
                  hintText: "$carNo",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  carNo = text;
                },
              ),
            ),
          ],
        ),
      ),

      ///车辆品牌
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '车辆品牌',
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
                    hintText: "$carBrand",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (text) {
                    carBrand = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        height: 1.0,
        color: const Color(0xffebebeb),
      ),

      ///车辆型号
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '车辆型号',
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
                  hintText: "$carModelSub",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  carModel = text;
                },
              ),
            ),
          ],
        ),
      ),

      new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        height: 1.0,
        color: const Color(0xffebebeb),
      ),

      ///车辆估值(元)
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '车辆估值(元)',
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
                  hintText: "$carCost",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                maxLines: 1,
                onChanged: (text) {
                  carCost = text;
                },
              ),
            ),
          ],
        ),
      ),

      new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        height: 1.0,
        color: const Color(0xffebebeb),
      ),

      ///车身颜色
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '车身颜色',
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
                  hintText: "$carColor",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  carColor = text;
                },
              ),
            ),
          ],
        ),
      ),

      new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        height: 1.0,
        color: const Color(0xffebebeb),
      ),

      ///车架号
      new Container(
        margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        height: 48.0,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '车架号',
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
                  hintText: "$carFrameNo",
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.text,
                maxLines: 1,
                onChanged: (text) {
                  carFrameNo = text;
                },
              ),
            ),
          ],
        ),
      ),

      ///分割阴影
      new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        height: 1.0,
        color: const Color(0xffebebeb),
      ),

      ///发动机号
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '发动机号',
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
                    hintText: "$carEngineNo",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onChanged: (text) {
                    carEngineNo = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      ///车辆使用年限
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '车辆使用年限',
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
                    hintText: "$carServiceLife",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (text) {
                    carServiceLife = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      ///行驶里程
      new GestureDetector(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '行驶里程',
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
                    hintText: "$carDrivingMileage",
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  maxLines: 1,
                  onChanged: (text) {
                    carDrivingMileage = text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      ///是否有重大事故
      new GestureDetector(
        onTap: _showMajorAccidentDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '是否有过重大事故',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  //majorAccident == 1 ? '有' : '无',
                  '$majorAccidentLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      ///事故类型
      new GestureDetector(
        onTap: _showCheckAccidentTypeDialog,
        child: new Container(
          margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          height: 48.0,
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  '事故类型',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xffAAAAAA)),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child: new Text(
                  '$accidentTypeLabel',
                  style:
                      TextStyle(fontSize: 16.0, color: const Color(0xff353535)),
                ),
              ),
            ],
          ),
        ),
      ),

      new Container(
        margin: new EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        height: 1.0,
        color: const Color(0xffebebeb),
      ),

      ///车辆照片
      new Container(
        height: 50.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('      车辆照片',
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ],
        ),
      ),

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
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  childAspectRatio: 0.67,
                  children: carImageList.map((f) {
                    return new GestureDetector(
                        onTap: () {
                          //以下图片使用车辆实体中某属性来判断，确认是否已经完成车辆信息填写，若填写根据是否确认来判断图片操作
                          if (widget.bizOrderNo != '' &&
                              widget.bizOrderNo != null) {
                            var index = carImageList.indexOf(f);
                            if (defaultImageUrl == f) {
                              showModalBottomSheetDialog(context, index, f, 7);
                            } else {
                              if (widget.wxAppConfirm == 0) {
                                showModalBottomSheetDialog(context, index, f, 7);
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

      ///机动车登记证/抵押证
      new Container(
        height: 50.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('      机动车登记证/抵押证',
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ],
        ),
      ),

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
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 0.67,
                  children: registerImageList.map((f) {
                    return new GestureDetector(
                        onTap: () {
                          if (widget.bizOrderNo != '' &&
                              widget.bizOrderNo != null) {
                            var index = registerImageList.indexOf(f);
                            if (defaultImageUrl == f) {
                              showModalBottomSheetDialog(context, index, f, 4);
                            } else {
                              if (widget.wxAppConfirm == 0) {
                                showModalBottomSheetDialog(context, index, f, 4);
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

      ///行驶证
      new Container(
        height: 50.0,
        color: const Color(0xffebebeb),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('      行驶证',
                  style: TextStyle(fontSize: 14.0, color: Colors.black)),
            ),
          ],
        ),
      ),

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
                  children: driveImageList.map((f) {
                    return new GestureDetector(
                        onTap: () {
                          if (widget.bizOrderNo != '' &&
                              widget.bizOrderNo != null) {
                            var index = driveImageList.indexOf(f);
                            if (defaultImageUrl == f) {
                              showModalBottomSheetDialog(context, index, f, 14);
                            } else {
                              if (widget.wxAppConfirm == 0) {
                                showModalBottomSheetDialog(context, index, f, 14);
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
              child: new Text('',
                  style: TextStyle(fontSize: 12.0, color: Colors.black)),
            ),
          ],
        ),
      ),

      ///按钮
      new Padding(
        padding: new EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  _saveCarInfo();
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

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '车辆信息',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: new Center(
          child: new ListView(children: list),
        ));
  }

  Global global = Global();

  _getCarInfo(String bizOrderNo, int channelType) async {
    if (!isReload) {
      isReload = true;
      String url = "";
      try {
        Map<String, Object> dataMap = new Map();
        ClCarInfo clCarInfo;
        List carList = new List();
        List registerList = new List();
        List accidentStatusList = new List();
        List carDriveList = new List();
        FormData formData = new FormData.from({});
        if (widget.fromPage == 2 || widget.fromPage == 1) {
          //用户第一次登录从我的页面进入查看车辆信息
          if (widget.bizOrderNo == null) {
            buttonName = "返回";
            addDefaultImageUrl();
            return;
          }

          ///我的页面进入车辆信息页
          var response = await global.postFormData("car/query",
              {"biz_order_no": bizOrderNo, "channel_type": channelType});
          dataMap = response['dataMap'];
          //判断是否 未完成车辆信息填写 直接从我的页面进入车辆信息页
          if (dataMap['clCarInfo'] != null) {
            clCarInfo = ClCarInfo.fromJson(dataMap['clCarInfo']);
          }
          carDriveList = dataMap['cardriveListList'];
          accidentStatusList = dataMap['accidentTypes'];
          carList = dataMap["carList"];
          registerList = dataMap['registerList'];
          if (widget.fromPage == 2) {
            if (widget.wxAppConfirm == 1) {
              buttonName = "返回";
            } else {
              if (clCarInfo == null) {
                buttonName = "返回";
              } else {
                buttonName = "修改";
              }
            }
          }
        } else {
          ///app进单
          url = "borrow/toCarBorrow/" + widget.bizOrderNo;
          var response = await global.postFormData(url, formData);
          dataMap = response['dataMap'];
          accidentStatusList = dataMap['accidentTypes'];
          carList = dataMap["carList"];
          registerList = dataMap['registerList'];
          carDriveList = dataMap['driveList'];
          if (dataMap["biz_order_no"] != null &&
              dataMap["biz_order_no"] != '') {
            ///区分新增还是修改
            clCarInfo = ClCarInfo.fromJson(dataMap['clCarInfo']);
          }
        }

        setState(() {
          if (clCarInfo != null) {
            carNo = clCarInfo.car_no;
            carBrand = clCarInfo.car_brand;
            carModel = clCarInfo.car_model;
            if (carModel.length > 8) {
              carModelSub = carModel.substring(0, 8) + "....";
            }else{
              carModelSub = carModel;
            }
            carColor = clCarInfo.car_color;
            carFrameNo = clCarInfo.car_frame_no;
            carEngineNo = clCarInfo.car_engine_no;
            carDrivingMileage = clCarInfo.car_driving_mileage;
            carServiceLife = clCarInfo.car_service_life;
            accidentTypeValue = int.parse(clCarInfo.accident_type);
            majorAccident = int.parse(clCarInfo.major_accident);
            if(majorAccident == 0){
              majorAccidentLabel = "无";
            }else{
              majorAccidentLabel = "有";
            }
            Map riskData = dataMap['clRiskInfo'] as Map;
            carCost = riskData['car_cost'].toString();
          }

          ///车辆照片
          if (carList != null && carList.length > 0) {
            for (int i = 0; i < carList.length; i++) {
              String filePath = carList[i]['file_path'];
              carImageList.add(filePath);
            }
          } else {
            for (int i = 0; i < 2; i++) {
              carImageList.add(defaultImageUrl);
            }
          }

          ///登记证，抵押证
          if (registerList != null && registerList.length > 0) {
            for (int i = 0; i < registerList.length; i++) {
              String filePath = registerList[i]['file_path'];
              registerImageList.add(filePath);
            }
          } else {
            for (int i = 0; i < 2; i++) {
              registerImageList.add(defaultImageUrl);
            }
          }

          ///行驶证, 只显示两张，如果库只有一张 就添加
          if (carDriveList != null && carDriveList.length > 0) {
            if (carDriveList.length == 1) {
              String filePath = carDriveList[0]['file_path'];
              driveImageList.add(filePath);
              driveImageList.add(defaultImageUrl);
            }
            if (carDriveList.length > 1) {
              for (int i = 0; i < 2; i++) {
                String filePath = carDriveList[i]['file_path'];
                driveImageList.add(filePath);
              }
            }
          } else {
            for (int i = 0; i < 2; i++) {
              driveImageList.add(defaultImageUrl);
            }
          }

          ///事故类型
          List<SysDict> accidents = new List();
          for (int i = 0; i < accidentStatusList.length; i++) {
            SysDict sysDict = new SysDict();
            sysDict.label = accidentStatusList[i]["label"];
            sysDict.value = accidentStatusList[i]["value"];
            accidents.add(sysDict);
          }
          accidentTypeList = accidents;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  /// 展示选择事故类型的弹窗
  _showCheckAccidentTypeDialog() {
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
                  children: listViewDefault(accidentTypeList,
                      "accident_type_flag", accidentTypeValue, context)),
            ),
            /* children: listViewDefault(),*/
          );
        });
  }

  ///是否有无事故
  void _showMajorAccidentDialog() {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new Dialog(
            child: new Container(
              width: 300.0,
              height: 230.0,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new RadioListTile<int>(
                    title: const Text('无'),
                    value: 0,
                    groupValue: majorAccident,
                    onChanged: (int e) => updateDefaultDialogValue(
                        e, 'major_accident_flag', context),
                  ),
                  new RadioListTile<int>(
                    title: const Text('有'),
                    value: 1,
                    groupValue: majorAccident,
                    onChanged: (int e) => updateDefaultDialogValue(
                        e, "major_accident_flag", context),
                  ),
                ],
              ),
            ),
          );
        }); /* children: listViewDefault(),*/
  }

  ///公共弹窗
  listViewDefault(
      List sysDictList, String type, int dataValue, BuildContext context) {
    List<Widget> data = new List();
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

    return data;
  }

  ///公共弹窗返回值
  updateDefaultDialogValue(int e, String type, BuildContext context) {
    Navigator.pop(context);
    setState(() {
      switch (type) {
        case 'accident_type_flag':
          this.accidentTypeValue = e;
          break;
        case 'major_accident_flag':
          this.majorAccident = e;
          if ( e == 0){
            this.majorAccidentLabel = "无";
          }else{
            this.majorAccidentLabel = "有";
          }
          break;
      }
    });
  }

  ///图片预览
  void showPhoto(BuildContext context, String f, index) {
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

  ///公用图片上传方法
  Future _uploadImage(File imageFile, int index, int fileType, String f) async {
    if (widget.fromPage != 0) {
      formType = 1;
    }
    FormData formData = new FormData.from({
      "biz_order_no": widget.bizOrderNo,
      "file_type": fileType,
      "formType": formType,
      "file_path": f,
      "channel_type": widget.channelType
    });
    String fileName = "";
    if (fileType == 7) {
      fileName = "车辆照片.png";
    } else if (fileType == 4) {
      fileName = "机动车登记证书、抵押登记证.png";
    } else if (fileType == 14) {
      fileName = "行驶证.png";
    }
    if (imageFile != null) {
      formData.add("file", new UploadFileInfo(imageFile, fileName));
    }
    var response =
        await global.postFormData("attachmentInfo/uploadFile", formData);
    DataResponse dataResponse = DataResponse.fromJson(response);
    Map<String, Object> map = dataResponse.entity as Map;
    String filePath = map['file_path'];
    setState(() {
      if (fileType == 7) {
        carImageList[index] = filePath;
      } else if (fileType == 4) {
        registerImageList[index] = filePath;
      } else if (fileType == 14) {
        driveImageList[index] = filePath;
      }
    });
  }

  ///车辆信息保存
  Future _saveCarInfo() async {

    if (buttonName == "返回") {
      Navigator.of(context).pop();
      return;
    }
    if (carNo == '' || carNo == null) {
      DialogUtils.showAlertDialog(context, "提示", "车牌号码不能为空", null);
      return;
    }

    if (carBrand == '' || carBrand == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆品牌不能为空", null);
      return;
    }

    if (carModel == '' || carModel == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆型号不能为空", null);
      return;
    }

    if (carCost == '' || carCost == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆估值不能为空", null);
      return;
    }

    if (carColor == '' || carColor == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆颜色不能为空", null);
      return;
    }

    if (carFrameNo == '' || carFrameNo == null) {
      DialogUtils.showAlertDialog(context, "提示", "车架号不能为空", null);
      return;
    }
    if (carEngineNo == '' || carEngineNo == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆发动机号不能为空", null);
      return;
    }

    if (carServiceLife == '' || carServiceLife == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆使用年限不能为空", null);
      return;
    }
    if (carDrivingMileage == '' || carDrivingMileage == null) {
      DialogUtils.showAlertDialog(context, "提示", "车辆行驶里程不能为空", null);
      return;
    }

    if (accidentTypeLabel == '' || accidentTypeLabel == null) {
      DialogUtils.showAlertDialog(context, "提示", "事故类型不能为空", null);
      return;
    }

    if (carImageList.contains(defaultImageUrl)) {
      DialogUtils.showAlertDialog(context, "提示", "请上传车辆照片", null);
      return;
    }

    if (registerImageList.contains(defaultImageUrl)) {
      DialogUtils.showAlertDialog(context, "提示", "请上传机动车登记证/抵押证", null);
      return;
    }

    if (driveImageList.contains(defaultImageUrl)) {
      DialogUtils.showAlertDialog(context, "提示", "请上传行驶证", null);
      return;
    }

    String url = "car/save";
    if (widget.fromPage == 0) {
      url = "borrow/saveCarInfo";
    }
    try {
      var response = await global.postFormData(url, {
        "data": {
          "biz_order_no": widget.bizOrderNo,
          "car_no": carNo,
          "car_brand": carBrand,
          "car_model": carModel,
          "car_color": carColor,
          "car_frame_no": carFrameNo,
          "car_engine_no": carEngineNo,
          "car_driving_mileage": carDrivingMileage,
          "car_service_life": carServiceLife,
          "major_accident": majorAccident,
          "accident_type": accidentTypeValue,
          "channel_type": widget.channelType,
          "car_cost": carCost
        },
      });
      bool isVerify = false;
      if (response["msg"] == "1") {
        isVerify = true;
      }
      if (response["code"] == 0) {
        ///如果是从我的页面进入就弹出修改成功的提示框
        if (widget.fromPage == 2) {
          DialogUtils.showAlertDialog(context, "提示", "修改成功", null);
        } else {
          ///先判断是否通过人脸识别
          if (isVerify) {
            ///跳转到签约代扣页面
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return SignPage(
                bizOrderNo: widget.bizOrderNo,
                channelType: widget.channelType,
              );
            }));
          } else {
            ///跳转到人脸识别页面
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return faceValidatePage(bizOrderNo: widget.bizOrderNo);
            }));
          }
        }
      }
    } catch (e) {
      print(e);
      DialogUtils.showAlertDialog(context, "提示", "保存失败", null);
    }
  }

  void addDefaultImageUrl() {
    setState(() {
      for (int i = 0; i < 2; i++) {
        carImageList.add(defaultImageUrl);
      }
      for (int i = 0; i < 2; i++) {
        registerImageList.add(defaultImageUrl);
      }
      for (int i = 0; i < 2; i++) {
        driveImageList.add(defaultImageUrl);
      }
    });
  }

  showModalBottomSheetDialog(BuildContext context, int index, String f, int type){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text("相机", textAlign: TextAlign.left),
                onTap: () {
                  ImagePicker.pickImage(
                      source: ImageSource.camera, imageQuality: global.imageQuality)
                      .then((onValue) {
                    _uploadImage(onValue, index, type, f);
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
                  ImagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: global.imageQuality)
                      .then((onValue) {
                    _uploadImage(onValue, index, type, f);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

}
