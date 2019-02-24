import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carloan/common/Global.dart';
import 'package:flutter_carloan/repayment/bill.dart';

class RepaymentPage extends StatefulWidget {
  RepaymentPage({
    this.bizOrderNo,
    this.isConfirm,
    this.applyAmount,
    this.terms,
    this.method,
  });

  final String bizOrderNo;
  final bool isConfirm;
  final double applyAmount;
  final int terms;
  final int method;

  @override
  State<StatefulWidget> createState() {
    return RepaymentPageState();
  }
}

class RepaymentPageState extends State<RepaymentPage> {
  RepaymentPageState({
    this.bizOrderNo,
    this.isConfirmPage,
    this.applyAmount,
    this.terms,
    this.method,
  });

  Global global = new Global();
  final String bizOrderNo;

  // 是确认界面？（默认是）
  bool isConfirmPage = true;

  // 申请金额
  double applyAmount = 10000;
  int terms;
  int method;

  bool _applyDataChanged = false;

  int itemValue = 1;

  String _requestPath = "bill/billDetail";
  String _updateAndComputingPath = "bill/afterChangeInitBills";

  int repayMethodValue = 1;

  int maxApplyAmount = 100000;

  // 灰色背景
  Color greyBackground = Color.fromRGBO(234, 234, 234, 1);

  // 灰色文字
  Color greyFontColor = Color.fromRGBO(136, 136, 136, 1);

  // 黑色字体
  Color blackFontColor = Color.fromRGBO(16, 16, 16, 1);

  // 蓝色字体
  Color _blueColor = Color.fromRGBO(3, 169, 244, 1);
  Color _redColor = Color.fromRGBO(229, 28, 35, 1);
  Color _whiteColor = Color.fromRGBO(255, 255, 255, 1);
  Color _greenColor = Color.fromRGBO(70, 142, 82, 1);

  // 字体
  String _arial = 'Arial';

  TextStyle _blue18 = TextStyle(
    color: Color.fromRGBO(3, 169, 244, 1),
    fontFamily: 'Arial',
    fontSize: 18,
  );
  TextStyle _black14 = TextStyle(
    color: Color.fromRGBO(16, 16, 16, 1),
    fontFamily: 'Arial',
    fontSize: 14,
  );
  TextStyle _grey14 = TextStyle(
    color: Color.fromRGBO(136, 136, 136, 1),
    fontFamily: 'Arial',
    fontSize: 14,
  );

  // 是否已经初始化
  bool hasInit = false;

  // 显示用的账单列表
  List<Bill> _bills = new List();

  @override
  Widget build(BuildContext context) {
    if (!hasInit) {
      _getRepaymentMsg();
    }
    print('*********');
    DateTime now = DateTime.now();
    print(DateTime(now.year, now.month, now.day));
    print(DateTime(2019, 1, 22));
    print(
        DateTime(now.year, now.month, now.day).isBefore(DateTime(2019, 2, 22)));
    print(
        DateTime(now.year, now.month, now.day).isAfter(DateTime(2019, 2, 22)));
    print(DateTime(now.year, now.month, now.day)
        .isAtSameMomentAs(DateTime(2019, 2, 22)));

    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("订单详情"),
        ),
        body: Container(
          color: greyBackground,
          child: Column(
            children: <Widget>[
              buildRepaymentDetailListView(),
            ],
          ),
        ));
  }

  /// 更新并重新计算账单（预计算，还没有保存）
  void _getUpdateRepaymentMsg() async {
    List data = new List();
    Map request = {
      "bizOrderNo": "QSM20181221092524",
      "applyAmount": 30000,
      "terms": 12,
      "method": 1,
      "origin": 1,
    };

    Map response = await global.postFormData(_updateAndComputingPath, request);
    data = response['entity']['bills'];

    _bills = new List();
    for (int i = 0; i < data.length; i++) {
      Bill bill = new Bill();
      bill.currentTerm = data[i]['currentTerm'];
//      bill.shouldPayDate = data[i]['shouldPayDate'][0].toString() +
//          '-' +
//          data[i]['shouldPayDate'][1].toString() +
//          '-' +
//          data[i]['shouldPayDate'][2].toString();
      bill.amount = data[i]['amount'];
      _bills.add(bill);
    }
    setState(() {
      _applyDataChanged = false;
    });
  }

  /// 贷款服务提供方组件
  Widget _buildLoanEmployerWidget() {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 7),
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Text(
            "由大兴安岭农商银行提供贷款服务",
            style: TextStyle(
              color: greyFontColor,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }

  /// 订单基础信息行
  Widget buildLoanRowWidget() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              child: Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      "申请金额（元）",
                      style: TextStyle(
                        color: blackFontColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    child: _getApplyAmountWidget(),
                  ),
                ],
              ),
            ),
          )),
          Container(
            color: Colors.grey,
            width: 1.0,
            height: 50.0,
          ),
          Container(
            child: Expanded(
              child: Column(
                children: <Widget>[
                  Text("利率"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          "年化",
                          style: _grey14,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          "5.5%",
                          style: _blue18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            width: 1.0,
            height: 50.0,
          ),
          Container(
            child: Expanded(child: _buildLoanRowWidgetColumn()),
          ),
        ],
      ),
    );
  }

  /// 订单信息行里的一列
  Widget _buildLoanRowWidgetColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "期数",
          style: _black14,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getTermWidget(),
            Text(
              "期",
              style: _grey14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _getTermWidget() {
    if (isConfirmPage) {
      List<DropdownMenuItem> terms = new List();
      DropdownMenuItem item1 = new DropdownMenuItem(value: 1, child: Text("1"));
      DropdownMenuItem item2 = new DropdownMenuItem(value: 3, child: Text("3"));
      DropdownMenuItem item3 = new DropdownMenuItem(value: 6, child: Text("6"));
      DropdownMenuItem item4 = new DropdownMenuItem(value: 9, child: Text("9"));
      DropdownMenuItem item5 =
          new DropdownMenuItem(value: 12, child: Text("12"));
      terms.add(item1);
      terms.add(item2);
      terms.add(item3);
      terms.add(item4);
      terms.add(item5);

      return DropdownButton(
          items: terms,
          value: itemValue,
          style: _blue18,
          onChanged: (value) {
            if (itemValue != value) {
              setState(() {
                itemValue = value;
                _applyDataChanged = true;
              });
            }
          });
    } else {
      return Text(
        "3",
        style: _blue18,
      );
    }
  }

  /// 账单明细标题栏
  Widget _buildRepaymentDetailTitle() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "账单明细",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Text(
              "还款方式:",
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0, left: 10.0),
            child: _getRepaymentMethodWidget(),
          ),
        ],
      ),
    );
  }

  /// 构建账单列表（包含头部的基础信息）
  Widget buildRepaymentDetailListView() {
    return Container(
      child: Expanded(
        child: ListView.builder(
          itemCount: _bills.length + 2,
          itemBuilder: (context, i) {
            // 顶部基础信息
            if (i == 0) {
              return Column(
                children: <Widget>[
                  _buildLoanEmployerWidget(),
                  buildLoanRowWidget(),
                  _buildRepaymentDetailTitle(),
                ],
              );
            }

            // 具体的账单列表
            if (i <= _bills.length) {
              return Container(
                margin: EdgeInsets.only(bottom: 6),
                padding:
                    EdgeInsets.only(left: 13, right: 16, top: 10, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    _buildRepaymentTermDateRow(i - 1),
                    _buildRepaymentTermDividerRow(),
                    _buildRepaymentTermAmountRow(i - 1),
                  ],
                ),
              );
            } else {
              return buildRepaymentConfirmButton();
            }
          },
        ),
      ),
    );
  }

  /// 某一期view组件里的第一行（日期）
  Widget _buildRepaymentTermDateRow(int index) {
    int year = _bills[index].shouldPayDate[0];
    int month = _bills[index].shouldPayDate[1];
    int day = _bills[index].shouldPayDate[2];
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(
                  "第",
                  style: _black14,
                ),
                Text(
                  _bills[index].currentTerm.toString(),
                  style: _blue18,
                ),
                Text(
                  "期还款日",
                  style: _black14,
                ),
              ],
            ),
          ),
          Text(
            year.toString() + '-' + month.toString() + '-' + day.toString(),
            style: TextStyle(
              fontFamily: _arial,
              fontSize: 12,
              color: greyFontColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 分割线行
  Widget _buildRepaymentTermDividerRow() {
    return Container(
      color: Color.fromRGBO(234, 234, 234, 1),
      height: 2,
    );
  }

  /// 金额行
  Widget _buildRepaymentTermAmountRow(int index) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Container(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "还款金额",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: _arial,
                      color: greyFontColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      _bills[index].amount.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: _arial,
                        color: _blueColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: _getRepayButton(index),
          ),
        ],
      ),
    );
  }

  Widget _getRepayButton(int index) {
    if (isConfirmPage) {
      // 确认界面不需要还款按钮
      return null;
    } else {
      // 已还清的返回组件
      if (_bills[index].status == 3) {
        return Text(
          "已还清",
          style: TextStyle(
            fontFamily: _arial,
            fontSize: 12,
            color: _blueColor,
          ),
        );
      }

      DateTime current = DateTime.now();
      DateTime today = DateTime(current.year, current.month, current.day);

      int year = _bills[index].shouldPayDate[0];
      int month = _bills[index].shouldPayDate[1];
      int day = _bills[index].shouldPayDate[2];

      DateTime shouldPayDate = DateTime(year, month, day);
      String btnString = '还款';
      // 当前期数还款按钮的颜色，如果是逾期还款为红色，正常还款为蓝色
      Color currentTermRepayButtonColor = _blueColor;

      // 没到还款日
      if (today.isBefore(shouldPayDate)) {
        return null;
      }

      if (today.isAfter(shouldPayDate)) {
        btnString = '逾期还款';
        currentTermRepayButtonColor = _redColor;
      }

      return RaisedButton(
        child: Text(
          btnString,
          style: TextStyle(
            fontFamily: _arial,
            fontSize: 14,
            color: _whiteColor,
          ),
        ),
        color: currentTermRepayButtonColor,
        onPressed: () {
          print("还款按钮被点击了......");
        },
      );
    }
  }

  /// 底部确认按钮
  Widget buildRepaymentConfirmButton() {
    // 是否是确认界面
    if (isConfirmPage) {
      // 确认界面申请数据是否改变
      if (_applyDataChanged) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(
                    "更新并预览",
                    style: TextStyle(
                      fontFamily: _arial,
                      fontSize: 14,
                      color: _whiteColor,
                    ),
                  ),
                  color: _greenColor,
                  onPressed: () {
                    _getUpdateRepaymentMsg();
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(
                    "确认借款",
                    style: TextStyle(
                      fontFamily: _arial,
                      fontSize: 14,
                      color: _whiteColor,
                    ),
                  ),
                  color: _blueColor,
                  onPressed: () {
                    print("确认借款按钮被点击了.......");
                  },
                ),
              ),
            ],
          ),
        );
      }
    } else {
      // 订单详情界面
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text(
                  "确认",
                  style: TextStyle(
                    fontFamily: _arial,
                    fontSize: 14,
                    color: _whiteColor,
                  ),
                ),
                color: _blueColor,
                onPressed: () {
                  print("确认按钮被点击了.......");
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _getRepaymentMethodWidget() {
    if (isConfirmPage) {
      List<DropdownMenuItem> terms = new List();

      DropdownMenuItem item1 =
          new DropdownMenuItem(value: 1, child: Text("等额本息"));
      DropdownMenuItem item2 =
          new DropdownMenuItem(value: 4, child: Text("先息后本"));
      terms.add(item1);
      terms.add(item2);

      return DropdownButton(
        items: terms,
        value: repayMethodValue,
        onChanged: (value) {
          if (repayMethodValue != value) {
            setState(() {
              repayMethodValue = value;
              _applyDataChanged = true;
            });
          }
        },
      );
    } else {
      return Text(
        "等额本息",
        style: TextStyle(
          fontFamily: _arial,
          fontSize: 14,
          color: _blueColor,
        ),
      );
    }
  }

  /// 获取申请金额组件，有两种返回情况（1.确认借款时返回输入框 2.查看账单时返回文本）
  Widget _getApplyAmountWidget() {
    if (isConfirmPage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                style: _blue18,
                decoration: InputDecoration(
                  hintText: applyAmount.toString(),
                  hintStyle: _blue18,
                  suffixStyle: TextStyle(
                    color: blackFontColor,
                  ),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                maxLines: 1,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                onSubmitted: (text) {
                  if (text.isEmpty) {
                    return;
                  }
                  double apply = double.parse(text);
                  if (apply > maxApplyAmount) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text("抱歉，您申请的金额超过上限"),
                          );
                        });
                  } else {
                    if (applyAmount != apply) {
                      setState(() {
                        _applyDataChanged = true;
                        applyAmount = apply;
                      });
                    }
                  }
                },
              ),
            ),
          ),
//          Container(
//            margin: EdgeInsets.only(right: 30),
//            child: Text(
//              "元",
//            ),
//          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            applyAmount.toString(),
            style: _blue18,
          ),
          Text(
            "元",
            style: _grey14,
          ),
        ],
      );
    }
  }

  /// 从后台获取订单详细信息
  void _getRepaymentMsg() async {
//    List data = new List();
//    Map requestData = {"bizOrderNo": "QSM20181213143724"};
//
//    Map response = await global.postFormData(_requestPath, requestData);
//    data = response['entity'];
//
//    _bills = new List();
//    _applyAmount = 0;
//
//    for (int i = 0; i < data.length; i++) {
//      Bill bill = new Bill();
//      bill.currentTerm = data[i]['currentRepaymentTerm'];
//      bill.shouldPayDate = data[i]['shouldPayDate'];
//      bill.amount = data[i]['shouldPayTotal'];
//      bill.status = data[i]['billStatus'];
//      _applyAmount += data[i]['shouldPayPrincipal'];
//      _bills.add(bill);
//    }

    Bill b1 = new Bill();
    b1.currentTerm = 1;
    b1.shouldPayDate = [2019, 1, 24];
    b1.amount = 1000;
    b1.status = 1;

    Bill b2 = new Bill();
    b2.currentTerm = 2;
    b2.shouldPayDate = [2019, 2, 24];
    b2.amount = 1000;
    b2.status = 1;

    Bill b3 = new Bill();
    b3.currentTerm = 3;
    b3.shouldPayDate = [2019, 3, 24];
    b3.amount = 1000;
    b3.status = 1;

    _bills = [b1, b2, b3];
    setState(() {
      hasInit = true;
    });
  }
}