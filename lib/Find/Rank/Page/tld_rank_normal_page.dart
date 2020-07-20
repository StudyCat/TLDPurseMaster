import 'package:dragon_sword_purse/Find/Rank/View/tld_rank_normal_cell.dart';
import 'package:dragon_sword_purse/Find/Rank/View/tld_rank_normal_header_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDRankNormalPage extends StatefulWidget {
  TLDRankNormalPage({Key key}) : super(key: key);

  @override
  _TLDRankNormalPageState createState() => _TLDRankNormalPageState();
}

class _TLDRankNormalPageState extends State<TLDRankNormalPage> {
  @override
  Widget build(BuildContext context) {
    return _getBodyWidget();
  }

  Widget _getBodyWidget(){
    return Padding(
      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(30), ScreenUtil().setHeight(20), ScreenUtil().setWidth(30), ScreenUtil().setHeight(40)),
      child: Container(
         decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white
         ),
         child: ListView.builder(
           itemCount: 11,
           itemBuilder: (BuildContext context, int index) {
           if (index == 0){
             return TLDRankNormalHeaderCell();
           }else{
             return TLDRankNormalCell(rank : index);
           }
          },
         ),
      ), 
      );
  }

}