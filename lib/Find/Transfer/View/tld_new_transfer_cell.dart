import 'package:date_format/date_format.dart';
import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';
import 'package:dragon_sword_purse/Find/Transfer/Model/tld_new_transfer_model_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDNewTransferCell extends StatefulWidget {
  TLDNewTransferCell({Key key,this.listModel,this.didClickQrCodeCallBack}) : super(key: key);

  final TLDNewTransferListModel listModel;

  final Function didClickQrCodeCallBack;

  @override
  _TLDNewTransferCellState createState() => _TLDNewTransferCellState();
}

class _TLDNewTransferCellState extends State<TLDNewTransferCell> {
  @override
  Widget build(BuildContext context) {
    String symbolStr = widget.listModel.type == 2 ? '+' : '-';
    Color amountColor = widget.listModel.type == 2 ? Color.fromARGB(255, 85, 184, 43) : Color.fromARGB(255, 185, 46, 43);
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(4)),
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20),
            top: ScreenUtil().setHeight(20),
            bottom: ScreenUtil().setHeight(20)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getAddressRowWidget('钱包地址',
                widget.listModel.tldWalletAddress),
            Offstage(
              offstage: widget.listModel.type == 2,
              child: Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                child: _getAddressRowWidget('USDT地址',
                    widget.listModel.usdtWalletAddress)),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Container(
                    height: ScreenUtil().setHeight(40),
                    width: ScreenUtil().setWidth(80),
                    decoration: BoxDecoration(
                      color: widget.listModel.type == 1 ? Color.fromARGB(255, 211, 117, 129) : Color.fromARGB(255, 85, 184, 43),
                      borderRadius: BorderRadius.all(Radius.circular(2))
                    ),
                    child: Center(
                      child: Text(widget.listModel.type == 1 ? '提现' : '充值',style: TextStyle(color : Colors.white,fontSize : ScreenUtil().setSp(24)),),
                    ),
                  ),
                  Container(
                child: Text('$symbolStr${widget.listModel.tldCount}TLD',style : TextStyle(color : amountColor,fontSize : ScreenUtil().setSp(36),),textAlign: TextAlign.end,),
              )
                ]
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Text(formatDate(DateTime.fromMillisecondsSinceEpoch(widget.listModel.createTime), [yyyy,'-',mm,'-',dd,' ',HH,':',nn]),style: TextStyle(fontSize :ScreenUtil().setSp(24),color : Color.fromARGB(255, 102, 102, 102)),),
                  Text(widget.listModel.transferStatusDesc,style :TextStyle(color :HexColor(widget.listModel.transferStatusColor),fontSize :ScreenUtil().setSp(24))),
                ]
              ),
            ),
            Offstage(
              offstage: widget.listModel.qrCode.length == 0,
              child: _getRechargeQrCode(),
            ),
            Offstage(
              offstage : widget.listModel.transferDesc.length == 0,
              child : Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                child: Text('失败原因：${widget.listModel.transferDesc}',style: TextStyle(color : Color.fromARGB(255, 185, 46, 43),fontSize: ScreenUtil().setSp(24)),),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _getRechargeQrCode(){
    return GestureDetector(
      onTap: (){
        widget.didClickQrCodeCallBack();
      },
      child: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Text('充值二维码',style: TextStyle(fontSize :ScreenUtil().setSp(24),color : Color.fromARGB(255, 102, 102, 102)),),
                  Row(
                    children: <Widget>[
                      Image.asset('assetss/images/transfer_qrcode.png',width: ScreenUtil().setHeight(28),height: ScreenUtil().setHeight(28),),
                      Icon(Icons.keyboard_arrow_right,size: ScreenUtil().setHeight(28),)
                    ],
                  )
                ]
              ),
    ),
    );
  }

  Widget _getAddressRowWidget(String title, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        width: ScreenUtil().setWidth(130),
        child: Text('$title:',
          maxLines: 1,
          style: TextStyle(
              color: Color.fromARGB(255, 102, 102, 102),
              fontSize: ScreenUtil().setSp(24))),
      ),
      Container(
        width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(250),
        child: Text(
          '$address',
          maxLines: 2,
          style: TextStyle(
              color: Color.fromARGB(255, 102, 102, 102),
              fontSize: ScreenUtil().setSp(24)),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      )
    ]);
  }
}
