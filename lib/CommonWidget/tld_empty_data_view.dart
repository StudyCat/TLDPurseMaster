import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TLDEmptyDataView extends StatefulWidget {
  TLDEmptyDataView({Key key,@required this.imageAsset,@required this.title}) : super(key: key);

  final String imageAsset;

  final String title;

  @override
  _TLDEmptyDataViewState createState() => _TLDEmptyDataViewState();
}

class _TLDEmptyDataViewState extends State<TLDEmptyDataView> {
  @override
   Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(214),
          ),
          child: Center(
              child: Image.asset(widget.imageAsset,width:ScreenUtil().setWidth(260),height: ScreenUtil().setWidth(260),) 
              ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(68),
          ),
          child: Center(
            child: Text(widget.title,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromARGB(255, 51, 51, 51))),
          ),
        ),
      ],
    );
  }
}