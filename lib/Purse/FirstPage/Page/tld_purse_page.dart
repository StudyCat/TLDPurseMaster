import 'dart:async';
import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonModelManager/tld_qr_code_model_manager.dart';
import 'package:dragon_sword_purse/Exchange/FirstPage/Page/tld_exchange_choose_wallet.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Login/Page/tld_acceptance_login_page.dart';
import 'package:dragon_sword_purse/Find/RecieveRedEnvelope/Page/tld_deteail_recieve_red_envelope_page.dart';
import 'package:dragon_sword_purse/Find/RecieveRedEnvelope/View/tld_unopen_red_envelope_alert_view.dart';
import 'package:dragon_sword_purse/Find/RedEnvelope/Model/tld_detail_red_envelope_model_manager.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';
import 'package:dragon_sword_purse/ScanQRCode/tld_scan_qrcode_page.dart';
import 'package:dragon_sword_purse/eventBus/tld_envent_bus.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../View/message_button.dart';
import '../View/purse_first_cell.dart';
import '../View/purse_cell.dart';
import '../View/purse_bottom_cell.dart';
import '../../MyPurse/Page/tld_my_purse_page.dart';
import '../../../ceatePurse&importPurse/CreatePurse/Page/tld_create_purse_page.dart';
import '../../../ceatePurse&importPurse/ImportPurse/Page/tld_import_purse_page.dart';
import '../../../Notification/tld_more_btn_click_notification.dart';
import '../../../Message/Page/tld_message_page.dart';
import '../../../CommonWidget/tld_data_manager.dart';
import '../../../ceatePurse&importPurse/CreatePurse/Page/tld_creating_purse_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../CommonFunction/tld_common_function.dart';
import '../Model/tld_purse_model_manager.dart';

class TLDPursePage extends StatefulWidget {
  TLDPursePage({Key key,this.didClickMoreBtnCallBack}) : super(key: key);
  final Function didClickMoreBtnCallBack;

  @override
  _TLDPursePageState createState() => _TLDPursePageState();
}

class _TLDPursePageState extends State<TLDPursePage> with AutomaticKeepAliveClientMixin {
  TLDPurseModelManager _manager;

  List _dataSource;

  double _totalAmount;

  RefreshController _controller;

  // StreamSubscription _unreadSubscription;

  TLDQRCodeModelManager _qrCodeModelManager;

  StreamSubscription _refreshSubscription;

  bool _isLoading = false;

  // bool _haveUnreadMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _manager = TLDPurseModelManager();

    _dataSource = [];

    _totalAmount = 0.0;

    _controller = RefreshController(initialRefresh: true);

    _qrCodeModelManager = TLDQRCodeModelManager();

    // _haveUnreadMessage = TLDIMManager.instance.unreadMessage.length > 0;

    // _registerUnreadMessageEvent();

    _registerRefreshEvent();

    _getPurseInfoList(context);
  }

  // void _registerUnreadMessageEvent(){
  //   _unreadSubscription = eventBus.on<TLDHaveUnreadMessageEvent>().listen((event) {
  //     setState(() {
  //       _haveUnreadMessage = event.haveUnreadMessage;
  //     });
  //   });
  // }

  void _registerRefreshEvent(){
    _refreshSubscription = eventBus.on<TLDRefreshFirstPageEvent>().listen((event) {
      _controller.requestRefresh();
      _getPurseInfoList(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // _unreadSubscription.cancel();

    _refreshSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SmartRefresher(
        controller: _controller,
        child: _getBodyWidget(context),
        header: WaterDropHeader(complete: Text(I18n.of(navigatorKey.currentContext).refreshComplete),),
        onRefresh:()=>_getPurseInfoList(context),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        border: Border.all(
          color : Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'purse_page',
        transitionBetweenRoutes: false,
        middle: Text(I18n.of(context).commonPageTitle,style: TextStyle(color : Colors.white),),
        automaticallyImplyLeading: true,
        trailing: IconButton(icon: Icon(IconData(0xe6fe,fontFamily: 'appIconFonts'),color: Colors.white,), onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (contenxt) => TLDScanQrCodePage(
                  scanCallBack: (String qrCode){
                    _qrCodeModelManager.scanQRCodeResult(qrCode, (TLDQRcodeCallBackModel callBackModel) async {
                      if (callBackModel.type == QRCodeType.redEnvelope){
                        _getRedEnvelopeInfo(callBackModel.data);
                      }else if(callBackModel.type == QRCodeType.transfer){
                        String toWalletAddres = callBackModel.data;
                         navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=> TLDEchangeChooseWalletPage(
                            transferWalletAddress: toWalletAddres,
                            type: TLDEchangeChooseWalletPageType.transfer,
                           ))).then((value) => _getPurseInfoList(context));
                      }else if (callBackModel.type == QRCodeType.inviteCode){
                        String inviteCode = callBackModel.data;
                        String token = await TLDDataManager.instance.getAcceptanceToken();
                        if (token == null){
                          Navigator.push(context, MaterialPageRoute(builder:(context) => TLDAcceptanceLoginPage(inviteCode: inviteCode,)));
                        }else{
                          Fluttertoast.showToast(msg: '您已注册TLD票据');
                        }
                      }
                    }, (TLDError error){
                      Fluttertoast.showToast(msg: error.msg);
                    });
                  },
                )));
        },
      ),
    ));
  }

  Widget _getBodyWidget(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => _getListViewItem(context,index),
      itemCount: _dataSource.length + 2,
    );
  }

  Widget _getListViewItem(BuildContext context, int index) {
    if (index == 0) {
      return TLDPurseHeaderCell(totalAmount:  _totalAmount,
        didClickCreatePurseButtonCallBack: (){
          _createPurse(context);
        },
        didClickImportPurseButtonCallBack: (){
          _importPurse(context);
        },
        );
    } else if (index == _dataSource.length + 1) {
      return TLDPurseFirstPageBottomCell();
    } else {
      TLDWalletInfoModel model = _dataSource[index - 1];
      return TLDPurseFirstPageCell(
        walletInfo: model,
        didClickCallBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return  TLDMyPursePage(wallet: model.wallet,changeNameSuccessCallBack: (String name){
                  setState(() {
                    TLDDataManager.instance.purseList;
                  });
                },);
              },
            ),
          ).then((value) => _getPurseInfoList(context));
        },
      );
    }
  }

  void _createPurse(BuildContext context) async{
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
    jugeHavePassword(context, (){
       Navigator.push(context, MaterialPageRoute(builder: (context)=> TLDCreatingPursePage(type: TLDCreatingPursePageType.create,)));
    },TLDCreatePursePageType.create,null);
  }

  void _importPurse(BuildContext context) async{
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
    jugeHavePassword(context,(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TLDImportPursePage()));
    },TLDCreatePursePageType.import,null);
  }

  void _getPurseInfoList(BuildContext context){
    _manager.getWalletListData((List purseInfoList){
      _totalAmount = 0.0;
      _dataSource = [];
      if (mounted){
              setState(() {
        for (TLDWalletInfoModel item in purseInfoList) {
          _totalAmount = _totalAmount + double.parse(item.value);
        }
        _dataSource = List.from(purseInfoList);
      });
      }
      _controller.refreshCompleted();
    }, (TLDError error){
      _controller.refreshCompleted();
      Fluttertoast.showToast(msg: error.msg, toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1);
    });
  }

  void _getRedEnvelopeInfo(String redEnvelopeId){
    setState(() {
      _isLoading = true;
    });
    _manager.getRedEnvelopeInfo(redEnvelopeId, (TLDDetailRedEnvelopeModel redEnvelopeModel){
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
      showDialog(context: context,builder:(context) => TLDUnopenRedEnvelopeAlertView(
        redEnvelopeModel: redEnvelopeModel,
        didClickOpenButtonCallBack: (String walletAddress){
          _recieveRedEnvelope(walletAddress, redEnvelopeId);
        },
        ));
    }, (TLDError error){
      if(mounted){
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: error.msg);
      }
    });
  }


  void _recieveRedEnvelope(String walletAddress,String redEnvelopeId){
    setState(() {
      _isLoading = true;
    });
    _manager.recieveRedEnvelope(redEnvelopeId, walletAddress, (int recieveLogId){
       if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TLDDetailRecieveRedEnvelopePage(receiveLogId: recieveLogId,)));
    }, (TLDError error){
       if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

    @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  
}
///////