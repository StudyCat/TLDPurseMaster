import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tld_tabbar_page.dart';

class TLDImportPurseSuccessPage extends StatefulWidget {
  TLDImportPurseSuccessPage({Key key}) : super(key: key);

  @override
  _TLDImportPurseSuccessPageState createState() => _TLDImportPurseSuccessPageState();
}

class _TLDImportPurseSuccessPageState extends State<TLDImportPurseSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border.all(
          color : Color.fromARGB(0, 0, 0, 0),
        ),
         leading: Container(
        height: ScreenUtil().setHeight(34),
        width: ScreenUtil().setHeight(34),
        child: CupertinoButton(
          child: Icon(
            IconData(
              0xe600,
              fontFamily: 'appIconFonts',
            ),
           color: Color.fromARGB(255, 51, 51, 51),
          ),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TLDTabbarPage()), (route) => route == null);
          },
        ),
       ),
        heroTag: 'import_purse_success_page',
        transitionBetweenRoutes: false,
        middle: Text('导入钱包'),
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        actionsForegroundColor: Color.fromARGB(255, 51, 51, 51),
      ),
      body: SingleChildScrollView(
        child: _getBodyWidget(context),
      ),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(250)),
          child:  Center(
              child:Image.asset('assetss/images/purse_success.png')),
        ),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(68)),
          child: Text('导入成功',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Color.fromARGB(255, 51, 51, 51))),
        ),
        Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(200),
              left: ScreenUtil().setWidth(100),
              right: ScreenUtil().setWidth(100)),
          height: ScreenUtil().setHeight(80),
          width: size.width - ScreenUtil().setWidth(200),
          child: CupertinoButton(
              child: Text(
                '确定',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Colors.white),
              ),
              padding: EdgeInsets.all(0),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TLDTabbarPage()), (route) => route == null);
              }),
        ),
      ],
    ));
  }
}
