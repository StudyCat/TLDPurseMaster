import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';
import 'package:dragon_sword_purse/Find/YLB/Model/tld_ylb_balance_son_model_manager.dart';
import 'package:dragon_sword_purse/Find/YLB/View/tld_ylb_roll_in_action_sheet.dart';
import 'package:dragon_sword_purse/Find/YLB/View/tld_ylb_roll_out_action_sheet.dart';
import 'package:dragon_sword_purse/ceatePurse&importPurse/CreatePurse/Page/tld_create_purse_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TLDYLBBalanceSonPage extends StatefulWidget {
  TLDYLBBalanceSonPage({Key key,this.type}) : super(key: key);

  final int type;

  @override
  _TLDYLBBalanceSonPageState createState() => _TLDYLBBalanceSonPageState();
}

class _TLDYLBBalanceSonPageState extends State<TLDYLBBalanceSonPage> {
  TLDYLBBalanceSonModelManager _modelManager;

  TLDYLBDetailProfitModel _detailProfitModel;

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _modelManager = TLDYLBBalanceSonModelManager();
    _getDetailProfitInfo();
  }


  void _getDetailProfitInfo(){
    setState(() {
      _isLoading = true;
    });
    _modelManager.getDetailProfitInfo(widget.type, (TLDYLBDetailProfitModel detailProfitModel){
      if (mounted){
        setState(() {
          _isLoading = false;
          _detailProfitModel = detailProfitModel;
        });
      }
    }, (TLDError error){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _rollIn(int type,String walletAddress,String amount){
    setState(() {
      _isLoading = true;
    });
    _modelManager.rollIn(type, walletAddress, amount, (){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      _getDetailProfitInfo();
      Fluttertoast.showToast(msg: '转入余利宝成功');
    }, (TLDError error){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

    void _rollOut(int type,String walletAddress,String amount){
    setState(() {
      _isLoading = true;
    });
    _modelManager.rollOut(type, walletAddress, amount, (){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      _getDetailProfitInfo();
      Fluttertoast.showToast(msg: '转出余利宝成功');
    }, (TLDError error){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(isLoading: _isLoading, child: _getBodyWidget());
  }

  Widget _getBodyWidget(){
    return Padding(
      padding: EdgeInsets.only(left : ScreenUtil().setWidth(50),right : ScreenUtil().setWidth(50),top: ScreenUtil().setHeight(20)),
      child: Container(
        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), ScreenUtil().setHeight(30), ScreenUtil().setWidth(40), ScreenUtil().setHeight(30)),
        decoration : BoxDecoration(
          color : Colors.white,
          borderRadius : BorderRadius.circular(8)
        ),
        child: Column(
          children: <Widget>[
            _getTotalWidget(),
            Padding(
              padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
              child: _getProfitRowWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
              child: _getButtonRowWidget(),
            )
          ],
        ),
      ),
      );
  }

  Widget _getTotalWidget(){
    return Column(
      children: <Widget>[
        Text('总金额(TLD)',style : TextStyle(color: Color.fromARGB(255, 51, 51, 51),fontSize: ScreenUtil().setSp(30))),
        Padding(
          padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
          child: Text(_detailProfitModel != null ? _detailProfitModel.totalCount : '0',style : TextStyle(color: Theme.of(context).hintColor,fontSize: ScreenUtil().setSp(48))),
        ),
        Padding(
          padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
          child: Container(
            height: ScreenUtil().setHeight(52),
            width: ScreenUtil().setWidth(260),
            decoration : BoxDecoration(
            color : Color.fromARGB(255, 242, 242, 242),
            borderRadius : BorderRadius.circular( ScreenUtil().setHeight(26))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_detailProfitModel != null ? '上次收益${_detailProfitModel.lastProfit}TLD' : '上次收益0TLD',textAlign: TextAlign.center,style : TextStyle(color: Color.fromARGB(255, 51, 51, 51),fontSize: ScreenUtil().setSp(24)))
              ],
            ),
          )
        )
      ],
    );
  }

  Widget _getProfitRowWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _getProfitWidget('累计收益(TLD)', _detailProfitModel != null ? _detailProfitModel.totalProfit : '0'),
        _getProfitWidget('7日年化收益(%)', _detailProfitModel != null ? _detailProfitModel.profitRate : '0')
      ],
    );
  }

  Widget _getProfitWidget(String title,String content){
    return Column(
      children: <Widget>[
         Text(title,style : TextStyle(color: Color.fromARGB(255, 51, 51, 51),fontSize: ScreenUtil().setSp(24))),
         Padding(
           padding: EdgeInsets.only(top : ScreenUtil().setHeight(10)),
           child: Text(content,style : TextStyle(color: Theme.of(context).hintColor,fontSize: ScreenUtil().setSp(36))),
         )
      ],
    );
  }

  Widget _getButtonRowWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width : (MediaQuery.of(context).size.width - ScreenUtil().setWidth(220)) / 2,
          height: ScreenUtil().setHeight(80),
          child: CupertinoButton(child: Text('转入',style : TextStyle(color: Theme.of(context).hintColor,fontSize: ScreenUtil().setSp(30))),padding: EdgeInsets.zero,color: Theme.of(context).primaryColor, onPressed: (){
            showModalBottomSheet(context: context, builder: (context){
              return TLDYLBRollInActionSheet(
                profitRate: _detailProfitModel.profitRate,
                didClickRollIn: (int type,String walletAddress, String amount){
                  jugeHavePassword(context, (){
                    _rollIn(type, walletAddress, amount);
                  }, TLDCreatePursePageType.back, (){
                    _rollIn(type, walletAddress, amount);
                  });
                },
              );
            });
          }),
        ),
        Container(
          width : (MediaQuery.of(context).size.width - ScreenUtil().setWidth(220)) / 2,
          height: ScreenUtil().setHeight(80),
          child: CupertinoButton(child: Text('转出',style : TextStyle(color: Theme.of(context).primaryColor,fontSize: ScreenUtil().setSp(30))),padding: EdgeInsets.zero,color: Theme.of(context).hintColor, onPressed: (){
            showModalBottomSheet(context: context, builder: (context){
              return TLDYLBRollOutActionSheet(
                maxValue: _detailProfitModel.totalCount,
                type: widget.type,
                 didClickRollOut: (int type,String walletAddress, String amount){
                  jugeHavePassword(context, (){
                    _rollOut(type, walletAddress, amount);
                  }, TLDCreatePursePageType.back, (){
                    _rollOut(type, walletAddress, amount);
                  });
                },
              );
            });
          }),
        )
      ],
    );
  }

}