import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDProtocolMissionCreateMissionPage extends StatefulWidget {
  TLDProtocolMissionCreateMissionPage({Key key}) : super(key: key);

  @override
  _TLDProtocolMissionCreateMissionPageState createState() =>
      _TLDProtocolMissionCreateMissionPageState();
}

class _TLDProtocolMissionCreateMissionPageState
    extends State<TLDProtocolMissionCreateMissionPage> {

  int _selectedType = 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border.all(
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'acceptance_bill_list_page',
        transitionBetweenRoutes: false,
        middle: Text(
          '选择平台',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actionsForegroundColor: Colors.white,
      ),
      body: _getBodyWidget(),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

  Widget _getBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getProtocolNameWidget(),
        _getScrollWidget()
      ],
    );
  }

  Widget _getProtocolNameWidget() {
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(40)),
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:
                'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcambrian-images.cdn.bcebos.com%2F0c68232b8bd06533bc40261989f3a383_1534328757537.jpeg&refer=http%3A%2F%2Fcambrian-images.cdn.bcebos.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614495448&t=9511d211ab7c91e08a2364807f1e552f',
            fit: BoxFit.cover,
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setWidth(60),
          ),
          Padding(
            padding: EdgeInsets.only(left : ScreenUtil().setWidth(36)),
            child: RichText(
              text: TextSpan(text: 'BTC',style: TextStyle(fontSize:ScreenUtil().setSp(36),color : Colors.black),children:[
                TextSpan(text: '/USDT',style: TextStyle(fontSize:ScreenUtil().setSp(26),color : Color.fromARGB(255, 153, 153, 153)))
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _getScrollWidget(){
    return Padding(
      padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children :[
            Padding(
              padding : EdgeInsets.only(left : ScreenUtil().setWidth(30)),
              child: Text('策  略',style: TextStyle(fontSize : ScreenUtil().setSp(30),color: Colors.black),),
            ),
            Padding(
              padding: EdgeInsets.only(left : ScreenUtil().setWidth(28)),
              child: _getSingleChoiceWidget(1, 'Bi乘方', true),
            ),
            Padding(
              padding: EdgeInsets.only(left : ScreenUtil().setWidth(20)),
              child: _getSingleChoiceWidget(2, 'Bi多元', false),
            ),
            Padding(
              padding: EdgeInsets.only(left : ScreenUtil().setWidth(20)),
              child: _getSingleChoiceWidget(3, 'Bi乘方', false),
            )
          ]
        ),
      )
    );
  }

   Widget _getSingleChoiceWidget(int type, String title,bool isHiddeText) {
    return Row(children: <Widget>[
      Offstage(
        offstage: isHiddeText,
        child: Container(
          height: ScreenUtil().setHeight(30),
          width: ScreenUtil().setHeight(30),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            border: Border.all(color : Color.fromARGB(255, 80, 227, 194),width: ScreenUtil().setWidth(2))
          ),
          child : Center(
            child: Text('限',style : TextStyle(fontSize : ScreenUtil().setSp(22),color : Color.fromARGB(255, 80, 227, 194))),
          )
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: isHiddeText ? 0 : ScreenUtil().setWidth(20)),
        child: Container(
        height: ScreenUtil().setHeight(18),
        width: ScreenUtil().setHeight(18),
        child: Radio(
          activeColor: Theme.of(context).hintColor,
          focusColor: Theme.of(context).hintColor,
          hoverColor: Theme.of(context).hintColor,
          value: type,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value;
            });
          },
        ),
      ),
      ),
      Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
          child: GestureDetector(
              onTap: () {
                setState(() {
              _selectedType = type;
            });
              },
              child: Text(
                title,
                style: TextStyle(
                    color: Color.fromARGB(255, 51, 51, 51),
                    fontSize: ScreenUtil().setSp(24)),
              )))
    ]);
  }
  
}
