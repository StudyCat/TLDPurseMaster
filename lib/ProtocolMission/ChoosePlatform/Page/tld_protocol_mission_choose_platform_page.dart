import 'package:dragon_sword_purse/ProtocolMission/ChoosePlatform/View/tld_protocol_choose_platform_choice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDProtocolMissionChoosePlatformPage extends StatefulWidget {
  TLDProtocolMissionChoosePlatformPage({Key key}) : super(key: key);

  @override
  _TLDProtocolMissionChoosePlatformPageState createState() =>
      _TLDProtocolMissionChoosePlatformPageState();
}

class _TLDProtocolMissionChoosePlatformPageState
    extends State<TLDProtocolMissionChoosePlatformPage> {
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
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: ScreenUtil().setHeight(40),
        color: Theme.of(context).primaryColor,
      ),
      Padding(
        padding: EdgeInsets.only(left : ScreenUtil().setWidth(30),right : ScreenUtil().setWidth(30)),
        child :  GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: ScreenUtil().setWidth(30),
              mainAxisSpacing: ScreenUtil().setHeight(30)),
          itemCount: 4,
          itemBuilder: (BuildContext context,int index){
            return TLDProtocolMissionChoosePlatformChoiceView();
          })
        )
    ]);
  }
}
