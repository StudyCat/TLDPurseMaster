import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_person_center_list_model_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TLDAAAPersonCenterListCell extends StatefulWidget {
  TLDAAAPersonCenterListCell({Key key,this.index,this.listModel,this.didClickRecieveBtn,this.type}) : super(key: key);

  final int type;

  final int index;

  final TLDAAAUpgradeListModel listModel;

  final Function didClickRecieveBtn;

  @override
  _TLDAAAPersonCenterListCellState createState() => _TLDAAAPersonCenterListCellState();
}

class _TLDAAAPersonCenterListCellState extends State<TLDAAAPersonCenterListCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left : ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
      child: Container(
        color : Colors.white,
        padding: EdgeInsets.only(top :widget.index == 0 ? ScreenUtil().setHeight(30) : ScreenUtil().setHeight(5),bottom :ScreenUtil().setHeight(5),left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
        child : _getContentWidget()
      ),
    );
  }

  Widget _getBottomRowWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
                children : <Widget>[
                   CachedNetworkImage(imageUrl: widget.listModel.curLevelIcon,width: ScreenUtil().setSp(80),height: ScreenUtil().setSp(80),),
                   Padding(
                    padding: EdgeInsets.only(left : ScreenUtil().setWidth(20)),
                    child : Icon(IconData(0xe632,fontFamily: 'appIconFonts'),color: Color.fromARGB(255, 102, 102, 102),size: ScreenUtil().setSp(24)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left : ScreenUtil().setWidth(20)),
                    child : CachedNetworkImage(imageUrl: widget.listModel.nextLevelIcon ,width: ScreenUtil().setSp(80),height: ScreenUtil().setSp(80),),
                  ),
              ]
            ),
        _getBottomRightWidget()
      ],
    );
  }

  Widget _getBottomRightWidget(){
    String plusString = widget.listModel.isAdd ? '+' : '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
         Text(plusString + '${widget.listModel.tldCount}TLD',style: TextStyle(fontSize: ScreenUtil().setSp(36),color: widget.listModel.isAdd ? Color.fromARGB(255, 65, 117, 5) : Color.fromARGB(255, 220, 59, 79))),
         Padding(
            padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
            child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(widget.listModel.createTime),[yyyy,'.',mm,'.',dd,' ',HH,':',nn,':',ss])
            ,style: TextStyle(fontSize: ScreenUtil().setSp(24),color: Color.fromARGB(255, 153, 153, 153))),
          ),
      ],
    );
  }

  Widget _getContentWidget(){
    return Container(
      padding:  EdgeInsets.only(top :ScreenUtil().setHeight(20),bottom :ScreenUtil().setHeight(20),left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color : Color.fromARGB(255, 242, 242, 242),
        borderRadius : BorderRadius.all(Radius.circular(4))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: ScreenUtil.screenWidth - ScreenUtil().setWidth(140),
            child: Text('${widget.listModel.fromNickName}升级向${widget.listModel.toNickName}馈赠',style: TextStyle(fontSize: ScreenUtil().setSp(28),color: Color.fromARGB(255, 51, 51, 51))),
          ),
          Padding(
            padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
            child: _getBottomRowWidget(),
          ),
          Offstage(
            offstage: widget.type == 1,
            child: Padding(
              padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
              child: _getRevieveInfoWidget(),
            ),
          )
        ],
      ),
    );
  }

  Widget _getRevieveInfoWidget(){
    return Container(
            width: ScreenUtil.screenWidth - ScreenUtil().setWidth(140),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
             Text('可领取收益:' + '${widget.listModel.tldCount}TLD',style: TextStyle(fontSize: ScreenUtil().setSp(28),color: widget.listModel.isAdd ? Color.fromARGB(255, 65, 117, 5) : Color.fromARGB(255, 220, 59, 79))),
             Container(
               height: ScreenUtil().setHeight(60),
               width: ScreenUtil().setWidth(150),
               child: CupertinoButton(child: Text(widget.listModel.isReceive ? '已领取': '领取收益',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(28)),),color: widget.listModel.isReceive ? Color.fromARGB(255, 153, 153, 153) :Theme.of(context).hintColor, padding: EdgeInsets.zero,onPressed: (){
                 if ( !widget.listModel.isReceive){
                   widget.didClickRecieveBtn();
                 }
               })),
              ])
            );
  }

}