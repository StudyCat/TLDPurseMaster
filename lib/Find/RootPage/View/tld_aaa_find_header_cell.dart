import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDAAAFindHeaderCell extends StatefulWidget {
  TLDAAAFindHeaderCell({Key key,this.balance}) : super(key: key);

  final String balance;

  @override
  _TLDAAAFindHeaderCellState createState() => _TLDAAAFindHeaderCellState();
}

class _TLDAAAFindHeaderCellState extends State<TLDAAAFindHeaderCell> {
  bool _isShowMoney = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom : ScreenUtil().setHeight(40)),
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Text('总资产',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(24))),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: _getAmountWidget(),
          ),
          Padding(
            padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
            child: Text('1.00TLD=1.00rmb',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(24))),
          )
        ],
      ),
    );
  }

  Widget _getAmountWidget(){
    return Row(
      children :[ 
          Padding(
            padding: EdgeInsets.only(left : ScreenUtil().setWidth(150)),
            child:  Container(
            width: MediaQuery.of(context).size.width -  ScreenUtil().setWidth(300),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: _isShowMoney ? getMoneyStyleStr(widget.balance) : '***',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(52),
                    color: Colors.white),
                children: <InlineSpan>[
                  TextSpan(
                      text: '  TLD',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          ),
            Padding(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isShowMoney = !_isShowMoney;
                              });
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(80),
                              height: ScreenUtil().setHeight(40),
                              padding: EdgeInsets.only(right: 0, left: 10),
                              child: _isShowMoney
                                  ? Icon(
                                      IconData(0xe60c,
                                          fontFamily: 'appIconFonts'),
                                      color: Colors.white,
                                      size: ScreenUtil().setWidth(40),
                                    )
                                  : Icon(
                                      IconData(0xe648,
                                          fontFamily: 'appIconFonts'),
                                      color: Colors.white,
                                      size: ScreenUtil().setWidth(40)),
                            ),
                          ))
            ]);
  }

}
