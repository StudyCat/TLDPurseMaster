import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';
import 'package:dragon_sword_purse/Purse/TransferAccounts/Model/tld_transfer_accounts_model_manager.dart';
import 'package:dragon_sword_purse/ScanQRCode/tld_scan_qrcode_page.dart';
import 'package:dragon_sword_purse/ceatePurse&importPurse/CreatePurse/Page/tld_create_purse_page.dart';
import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../View/tld_transfer_accounts_normal_row_view.dart';
import '../View/tld_transfer_accounts_input_row_view.dart';
import 'dart:async';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';

class TLDTransferAccountsPage extends StatefulWidget {
  TLDTransferAccountsPage({Key key,this.walletInfoModel,this.transferSuccessCallBack}) : super(key: key);

  final TLDWalletInfoModel walletInfoModel;

  final Function(String) transferSuccessCallBack;

  @override
  _TLDTransferAccountsPageState createState() => _TLDTransferAccountsPageState();
}

class _TLDTransferAccountsPageState extends State<TLDTransferAccountsPage> {

  TLDTransferAccountsModelManager _manager;

  TLDTransferAccountsInputRowControl _inputRowControl;

  TLDTranferAmountPramaterModel _pramaterModel;

  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _manager = TLDTransferAccountsModelManager();

    _inputRowControl = TLDTransferAccountsInputRowControl('');

    _pramaterModel = TLDTranferAmountPramaterModel();
    _pramaterModel.chargeWalletAddress = widget.walletInfoModel.chargeWalletAddress;
    _pramaterModel.fromWalletAddress = widget.walletInfoModel.walletAddress;
    _pramaterModel.chargeValue = '0.0';
    _pramaterModel.toWalletAddress = "";
    _pramaterModel.value = '0.0';
  }

  void tranferAmount(){
    if (double.parse(_pramaterModel.value) == 0.0){
      Fluttertoast.showToast(msg: '请填写购买数量',toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1);
                return;
    }
    if (_pramaterModel.toWalletAddress.length == 0){
      Fluttertoast.showToast(msg: '请输入接收地址',toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1);
                return;
    }
    setState(() {
      _loading = true;
    });
    _manager.transferAmount(_pramaterModel, (){
        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(msg: '转账成功',toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1);
        widget.transferSuccessCallBack(_pramaterModel.value);
        Navigator.of(context).pop();
    }, (TLDError error){
      setState(() {
      _loading = false;
      });
      Fluttertoast.showToast(msg: error.msg,toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border.all(
          color : Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'transfer_accounts_page',
        transitionBetweenRoutes: false,
        middle: Text('转账'),
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        actionsForegroundColor: Color.fromARGB(255, 51, 51, 51),
      ),
      body: LoadingOverlay(isLoading: _loading, child: _getBodyWidget(context,size)),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

  Widget _getBodyWidget(BuildContext context,Size size){
    // Size size = MediaQuery.of(context).size;
    String chargeValue = _pramaterModel.chargeValue != null ? _pramaterModel.chargeValue: '0.0';
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left : ScreenUtil().setWidth(30),right : ScreenUtil().setWidth(30)),
        height: size.height - ScreenUtil().setHeight(170),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Container(
            padding: EdgeInsets.only(left : ScreenUtil().setWidth(24),right : ScreenUtil().setWidth(24)),
            color: Colors.white,
            child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children : <Widget>[
              TLDTransferAccountsNormalRowView(title: '数量',content: '当前钱包余额:'+widget.walletInfoModel.value + 'TLD',),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                child: TLDTransferAccountsInputRowView(type : TLDTransferAccountsInputRowViewType.allTransfer,allAmount: widget.walletInfoModel.value,stringEditingCallBack: (String amount){
                  _pramaterModel.value = amount;
                  setState(() {
                    _pramaterModel.chargeValue = (double.parse(amount) * double.parse(widget.walletInfoModel.rate)).toStringAsFixed(2);
                  });
                },),
              ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                child: _getTitleLabel('发送地址'),
              ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                child: TLDTransferAccountsInputRowView(type : TLDTransferAccountsInputRowViewType.normal,
              content: widget.walletInfoModel.walletAddress,enable: false,), ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                child: _getTitleLabel('接收地址'),
              ),
               Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                child: TLDTransferAccountsInputRowView(type : TLDTransferAccountsInputRowViewType.scanCode,didClickScanBtnCallBack: (){
                  _scanPhoto();
                },
                inputRowControl: _inputRowControl,
                stringEditingCallBack: (String str){
                  _pramaterModel.toWalletAddress = str;
                },
              ), ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setWidth(20)),
                child: TLDTransferAccountsNormalRowView(title: '手续费率',content: (double.parse(widget.walletInfoModel.rate) * 100).toString()+'%',),
              ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setWidth(20)),
                child: TLDTransferAccountsNormalRowView(title: '手续费',content:chargeValue + 'TLD',),
              ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(200),),
                child: Container(
                  width: size.width - ScreenUtil().setWidth(108),
                  height: ScreenUtil().setHeight(96),
                  child : CupertinoButton(child: Text('确定'), color: Theme.of(context).primaryColor,onPressed: (){
                    jugeHavePassword(context, (){
                      tranferAmount();
                    }, TLDCreatePursePageType.back, (){
                      tranferAmount();
                    });
                  })
                ),
              )
              ]
          ),
          ),
        ),
      ),
    );
  }

  Widget _getTitleLabel(String title){
    return Text(title,style: TextStyle(fontSize : ScreenUtil().setSp(28),color : Color.fromARGB(255, 51, 51, 51)),);
  }

  Future _scanPhoto() async {
    Navigator.push(context, MaterialPageRoute(builder:(context) => TLDScanQrCodePage(
      scanCallBack: (String result){
        _manager.getAddressFromQrCode(result, (String walletAddress){
        _inputRowControl.value = walletAddress;
        _pramaterModel.toWalletAddress = walletAddress;
      }, (TLDError error){
        Fluttertoast.showToast(msg: error.msg,toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1);
      });
      },
    )));
  }

}