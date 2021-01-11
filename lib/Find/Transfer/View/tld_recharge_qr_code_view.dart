import 'dart:typed_data';
import 'dart:ui';
import 'package:dragon_sword_purse/Find/Acceptance/Bill/View/tld_dash_line.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TLDRechargeQRCodeView extends StatefulWidget {
  TLDRechargeQRCodeView({Key key,this.qrCode,this.amount}) : super(key: key);

  final String qrCode;

  final String amount;

  @override
  _TLDRechargeQRCodeViewState createState() => _TLDRechargeQRCodeViewState();
}

class _TLDRechargeQRCodeViewState extends State<TLDRechargeQRCodeView> {
GlobalKey repainKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top : ScreenUtil().setHeight(150)),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RepaintBoundary(
          key : repainKey,
          child: _getQrView()
        ),
        Padding(
          padding: EdgeInsets.only(top : ScreenUtil().setHeight(60)),
          child: Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(480),
          child: CupertinoButton(
            color: Colors.white,
            padding: EdgeInsets.all(0),
            child: Text('保存二维码',style: TextStyle(color : Color.fromARGB(255, 51, 51, 51),fontSize:ScreenUtil().setSp(28)),),
            onPressed: ()async{
              Uint8List bytes = await _capturePng();
              await _saveQrCodeImage(bytes);
            },
          ),
        ),
        )
      ],
    ),
    );
  }

  // Widget _getStackQrCodeView(){
  //   return RepaintBoundary(
  //         key : repainKey,
  //         child:  Stack(
  //     alignment : FractionalOffset(0.5,0.7),
  //     children: <Widget>[
  //       Image.asset('assetss/images/alipay_qrcode.png',width:ScreenUtil().setWidth(584),height: ScreenUtil().setWidth(910),fit: BoxFit.fill,),
  //       _getQRCodeImageAndPriceLabel()
  //     ],
  //   ),
  //       );
  // }

  Widget _getQrView(){
    return Container(
      height: ScreenUtil().setWidth(850),
      width: ScreenUtil().setWidth(584),
      decoration: BoxDecoration(
        borderRadius : BorderRadius.all(Radius.circular(4)),
        color : Colors.white
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.only(top : ScreenUtil().setHeight(48)),
            child: Text('请打开USDT(Omni)钱包\n扫码支付',style: TextStyle(color : Color.fromARGB(255, 51, 51, 51),fontSize : ScreenUtil().setSp(36),decoration: TextDecoration.none),textAlign: TextAlign.center,),
            ),
          Padding(padding: EdgeInsets.only(top : ScreenUtil().setHeight(40)),
          child: TLDDashLine(
            color: Color.fromARGB(255, 242, 242, 242),
          ),
          ),
          Padding(padding: EdgeInsets.only(top : ScreenUtil().setHeight(80)),
          child: _getQRCodeImageAndPriceLabel(),
          )
        ],
      ),
    );
  }



    Widget _getQRCodeImageAndPriceLabel(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        QrImage(data: widget.qrCode,size :ScreenUtil().setWidth(340)),
        Padding(
          padding: EdgeInsets.only(top : ScreenUtil().setHeight(60)),
          child: Text('支付：'+widget.amount + ' USDT',style:TextStyle(color : Color.fromARGB(255, 51, 51, 51),fontSize: ScreenUtil().setSp(32),decoration: TextDecoration.none)),
        )
      ],
    );
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          repainKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format:  ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;//这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future _saveQrCodeImage(Uint8List bytes) async{
    // Map<PermissionStatusGetters>
    var status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      ].request();
      return;
    }else if(status == PermissionStatus.permanentlyDenied){
      Fluttertoast.showToast(msg: I18n.of(navigatorKey.currentContext).PleaseTurnOnTheStoragePermissions);
      return;
    }
    var result = await ImageGallerySaver.saveImage(bytes);
    if (result != null){
      Fluttertoast.showToast(msg: '保存二维码成功',toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1);
    }else{
      Fluttertoast.showToast(msg: '保存二维码失败',toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1);
    }
  }
}