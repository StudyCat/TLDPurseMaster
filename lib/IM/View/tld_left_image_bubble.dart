import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TLDLeftImageBubbleView extends StatefulWidget {
  TLDLeftImageBubbleView({Key key,this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  _TLDLeftImageBubbleViewState createState() => _TLDLeftImageBubbleViewState();
}

class _TLDLeftImageBubbleViewState extends State<TLDLeftImageBubbleView> {
  @override
  Widget build(BuildContext context) {
   return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      decoration: BoxDecoration(
        color : Colors.white,
        borderRadius : BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
      ),
       child: CachedNetworkImage(imageUrl: widget.imageUrl,fit: BoxFit.fill,),
    );
  }
}