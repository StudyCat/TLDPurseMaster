import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDProtocolMissionChoosePlatformChoiceView extends StatefulWidget {
  TLDProtocolMissionChoosePlatformChoiceView({Key key}) : super(key: key);

  @override
  _TLDProtocolMissionChoosePlatformChoiceViewState createState() => _TLDProtocolMissionChoosePlatformChoiceViewState();
}

class _TLDProtocolMissionChoosePlatformChoiceViewState extends State<TLDProtocolMissionChoosePlatformChoiceView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius : BorderRadius.all(Radius.circular(4)),
          color: Colors.white,
          boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                            blurRadius: 15.0, //阴影模糊程度
                            spreadRadius: 1.0 //阴影扩散程度
                            )
                      ]),
       child: Column(
         children: <Widget>[
           _choiceWidget(),
           _centerLogoWidget(),
           _nameWidget()
         ],
       ),
    );
  }

  Widget _choiceWidget(){
    return Padding(
      padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
      child: Offstage(
        offstage: false,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children : [
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
            child: Icon(IconData(0xe64d,fontFamily: 'appIconFonts'),size: ScreenUtil().setWidth(60),color: Theme.of(context).hintColor,),
          )
        ]
      ),
      ),
    );
  }

  Widget _centerLogoWidget(){
    return Padding(
      padding: EdgeInsets.only(top : ScreenUtil().setHeight(6)),
      child: CachedNetworkImage(
        imageUrl: 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcambrian-images.cdn.bcebos.com%2F0c68232b8bd06533bc40261989f3a383_1534328757537.jpeg&refer=http%3A%2F%2Fcambrian-images.cdn.bcebos.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614495448&t=9511d211ab7c91e08a2364807f1e552f',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width / 5.5,
        height: MediaQuery.of(context).size.width / 5.5,
      ),
    );
  }

  Widget _nameWidget(){
    return Padding(
      padding: EdgeInsets.only(top : ScreenUtil().setHeight(30)),
      child: Text('火币',style: TextStyle(fontSize:ScreenUtil().setSp(36),color : Colors.black)),
    );
  }

}