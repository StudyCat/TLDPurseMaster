import 'package:dragon_sword_purse/Buy/FirstPage/Model/tld_buy_model_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tld_buy_cell_bottom.dart';
import 'package:dragon_sword_purse/CommonWidget/ltd_sale_buy_cell_header.dart';

class TLDBuyFirstPageCell extends StatefulWidget {
  TLDBuyFirstPageCell({Key key,this.didClickBuyBtnCallBack,this.model}) : super(key: key);

  final TLDBuyListInfoModel model;

  final didClickBuyBtnCallBack;

  @override
  _TLDBuyFirstPageCellState createState() => _TLDBuyFirstPageCellState();
}

class _TLDBuyFirstPageCellState extends State<TLDBuyFirstPageCell> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size; 
    return Container(
       padding: EdgeInsets.only(left : 15 , top : 5 ,right: 15),
       width: screenSize.width - 30,  
       child: ClipRRect(
         borderRadius : BorderRadius.all(Radius.circular(4)),
         child : Container(
           color: Colors.white,
           width: screenSize.width - 30,
           padding: EdgeInsets.only(top : 10,bottom : 17),
           child: Column(
             children : <Widget>[
               TLDCommonCellHeaderView(title: '地址',buttonTitle: '购买',onPressCallBack: widget.didClickBuyBtnCallBack,buttonWidth: 128,buyModel: widget.model,),
                getCellBottomView(widget.model),
             ]
           ),
         ),
       ),
    );
  }
}