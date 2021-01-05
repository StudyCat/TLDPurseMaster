import 'package:date_format/date_format.dart';
import 'package:dragon_sword_purse/Find/Transfer/Model/tld_new_transfer_model_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDNewTransferCell extends StatefulWidget {
  TLDNewTransferCell({Key key,this.listModel}) : super(key: key);

  final TLDNewTransferListModel listModel;

  @override
  _TLDNewTransferCellState createState() => _TLDNewTransferCellState();
}

class _TLDNewTransferCellState extends State<TLDNewTransferCell> {
  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusStr = '';
    if (widget.listModel.transferStatus == -1){
      statusColor = Color.fromARGB(255, 185, 46, 43);
      statusStr = '划转失败';
    }else if (widget.listModel.transferStatus == 0){
      statusColor = Color.fromARGB(255, 245, 219, 162);
      statusStr = '处理中';
    }else {
      statusColor = Color.fromARGB(255, 65, 117, 5);
      statusStr = '划转成功';
    }
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
          children: <Widget>[
            _getAddressRowWidget('钱包地址',
                widget.listModel.tldWalletAddress),
            Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                child: _getAddressRowWidget('USDT地址',
                    widget.listModel.usdtWalletAddress)),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Container(
                width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(100),
                child: Text('-${widget.listModel.tldCount}TLD',style : TextStyle(color : Color.fromARGB(255, 185, 46, 43),fontSize : ScreenUtil().setSp(36),),textAlign: TextAlign.end,),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  Text(formatDate(DateTime.fromMillisecondsSinceEpoch(widget.listModel.createTime), [yyyy,'-',mm,'-',dd,' ',HH,':',nn]),style: TextStyle(fontSize :ScreenUtil().setSp(24),color : Color.fromARGB(255, 102, 102, 102)),),
                  Text(statusStr,style :TextStyle(color :statusColor,fontSize :ScreenUtil().setSp(24))),
                ]
              ),
            ),
            Offstage(
              offstage : widget.listModel.transferDesc.length > 0,
              child : Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                child: Text('失败原因：${widget.listModel.transferDesc}',style: TextStyle(color : statusColor = Color.fromARGB(255, 185, 46, 43),fontSize: ScreenUtil().setSp(24)),),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _getAddressRowWidget(String title, String address) {
    return Row(children: [
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
          maxLines: 1,
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
