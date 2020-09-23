import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDAAAFriendTeamUnOpenCell extends StatefulWidget {
  TLDAAAFriendTeamUnOpenCell({Key key,this.didClickOpenItem}) : super(key: key);

  final Function didClickOpenItem;

  _TLDAAAFriendTeamUnOpenCellState createState() => _TLDAAAFriendTeamUnOpenCellState();
}

class _TLDAAAFriendTeamUnOpenCellState extends State<TLDAAAFriendTeamUnOpenCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left : ScreenUtil().setWidth(30),right:ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(20)),
      child: Container(
        padding: EdgeInsets.only(bottom:ScreenUtil().setHeight(20)),
        width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(60),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Colors.white
        ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left : ScreenUtil().setWidth(20),right:ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
            child: _getHeaderRowView(),
            ),
          Padding(
            padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
            child: Divider(height: ScreenUtil().setHeight(2),color: Color.fromARGB(255, 219, 218, 216),),
            ),
          GestureDetector(
             onTap:widget.didClickOpenItem,
             child : Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            )
           )
        ],
      ),
      ),
      );
  }

  Widget _getHeaderRowView(){
   return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RichText(text: TextSpan(
          children : <InlineSpan>[
             WidgetSpan(
                    child : CachedNetworkImage(imageUrl: 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3303266263,407158830&fm=26&gp=0.jpg',width: ScreenUtil().setSp(48),height: ScreenUtil().setSp(48),fit: BoxFit.fill,),
                  ),
             TextSpan(
               text : '  团队',
               style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromARGB(255, 51, 51, 51))
             )
          ]
        )),
        Text(
              '100人',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  color: Color.fromARGB(255, 51, 51, 51),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ],
        );
  }
}