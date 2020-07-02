import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../CommonFunction/tld_common_function.dart';

class TLDPurseHeaderCell extends StatefulWidget {
  TLDPurseHeaderCell({Key key,this.didClickCreatePurseButtonCallBack,this.didClickImportPurseButtonCallBack,this.totalAmount = 0.0}) : super(key: key);

  final Function didClickCreatePurseButtonCallBack;
  final Function didClickImportPurseButtonCallBack;
  final double totalAmount;

  @override
  _TLDPurseHeaderCellState createState() => _TLDPurseHeaderCellState();
}

class _TLDPurseHeaderCellState extends State<TLDPurseHeaderCell> {
  bool _isShowMoney;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isShowMoney = true;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size; 
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
      width: screenSize.width - 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('总积分',style: TextStyle(color:Theme.of(context).hintColor,fontSize: 12),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: screenSize.width - ScreenUtil().setWidth(150),
                child: Text(_isShowMoney ? getMoneyStyleStr(widget.totalAmount.toString()) :'***',style : TextStyle(fontSize : 26,color : Theme.of(context).hintColor)),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _isShowMoney = !_isShowMoney;
                  });
                },
                child: Container(
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setHeight(40),
                padding : EdgeInsets.only(right : 0,left: 10),
                child:  _isShowMoney ? Icon(IconData(0xe60c,fontFamily: 'appIconFonts'),color: Theme.of(context).hintColor,size: ScreenUtil().setWidth(50),) : Icon(IconData(0xe648,fontFamily: 'appIconFonts'),color: Theme.of(context).hintColor,size: ScreenUtil().setWidth(50)),
              ),
              )
            ],
          ),
          
          Container(
            padding: EdgeInsets.only(left : 0 ,top : 6),
            child: Text('1.00TLD=1.00CNY',style: TextStyle(color:Theme.of(context).hintColor,fontSize: 12),),
          ),

          Container(
            padding: EdgeInsets.only(top : 10),
            height: ScreenUtil().setHeight(80),
            child: Row(
              mainAxisAlignment : MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getButton(()=>widget.didClickCreatePurseButtonCallBack(), '创建钱包', screenSize.width),
                getButton(()=>widget.didClickImportPurseButtonCallBack(), '导入钱包', screenSize.width),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getButton(Function didClickCallBack,String title, double scrrenWidth){
      return Container(
                 width : scrrenWidth / 2.0 - 30,
                  child: CupertinoButton(
                  color: Theme.of(context).hintColor,
              onPressed: () => didClickCallBack(),
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setHeight(40))),
                  child: Text(
                           title,
                           textAlign: TextAlign.center,
                           style : TextStyle(color: Colors.white,fontSize: 14)),
                      ),
              );
  } 
}