import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDDetailRedEnvelopeHeaderCell extends StatefulWidget {
  TLDDetailRedEnvelopeHeaderCell({Key key}) : super(key: key);

  @override
  _TLDDetailRedEnvelopeHeaderCellState createState() => _TLDDetailRedEnvelopeHeaderCellState();
}

class _TLDDetailRedEnvelopeHeaderCellState extends State<TLDDetailRedEnvelopeHeaderCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: EdgeInsets.only(left : ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(16),bottom: ScreenUtil().setHeight(2)),
       child: Container(
         decoration: BoxDecoration(color : Colors.white,borderRadius : BorderRadius.all(Radius.circular(4))),
         height: ScreenUtil().setHeight(74),
         padding : EdgeInsets.only(left: ScreenUtil().setWidth(20)),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.start,
           children :<Widget> [ Text(I18n.of(context).alreadyReceived + "23/50,"+I18n.of(context).total+"45/100TLD",style: TextStyle(color:Color.fromARGB(255, 153, 153, 153),fontSize: ScreenUtil().setSp(24)),textAlign: TextAlign.start,)]
         ),
       ),
    );
  }
}