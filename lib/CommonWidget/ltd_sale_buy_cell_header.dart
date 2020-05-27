import 'package:dragon_sword_purse/Sale/FirstPage/Model/tld_sale_list_info_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../Buy/FirstPage/View/tld_buy_button.dart';
import '../Buy/FirstPage/View/tld_buy_info_label.dart';

class TLDCommonCellHeaderView extends StatefulWidget {
  TLDCommonCellHeaderView({Key key,this.title,this.buttonTitle,this.onPressCallBack,this.buttonWidth,this.saleModel}) : super(key: key);

  final String title;
  final String buttonTitle; 
  final Function onPressCallBack;
  final double buttonWidth;
  final TLDSaleListInfoModel saleModel;
  @override
  _TLDCommonCellHeaderViewState createState() => _TLDCommonCellHeaderViewState();
}

class _TLDCommonCellHeaderViewState extends State<TLDCommonCellHeaderView> {
  @override
  Widget build(BuildContext context) {
    String contentString = widget.saleModel != null ? widget.saleModel.sellNo : 'fwefwefewfwefwef';
    return Column(
             children : <Widget>[
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 mainAxisSize: MainAxisSize.max,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(left : 10),
                     child: Text(widget.title +'：' + contentString ,style : TextStyle(fontSize : ScreenUtil().setSp(24) ,color : Color.fromARGB(255, 153, 153, 153))),
                   ),
                   picAndTextButton('assetss/images/firspage_buy.png', widget.buttonTitle, widget.onPressCallBack,widget.buttonWidth)
                 ],
               ),
               Container(
                 padding: EdgeInsets.only(top : ScreenUtil().setHeight(14)),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: <Widget>[
                     getBuyInfoLabel('总量', widget.saleModel != null ?  widget.saleModel.totalCount + 'TLD' :'1839TLD'),
                     getBuyInfoLabel('限额', widget.saleModel != null ?  widget.saleModel.max + 'TLD' :'1839TLD'),
                     getBuyInfoLabel('剩余', widget.saleModel != null ?  widget.saleModel.currentCount + 'TLD' :'1839TLD'),
                   ],
                 ),)]
             );
  }
}

