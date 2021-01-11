
import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/Find/Transfer/Model/tld_new_transfer_model_manager.dart';
import 'package:dragon_sword_purse/Find/Transfer/View/tld_new_transfer_cell.dart';
import 'package:dragon_sword_purse/Find/Transfer/View/tld_new_transfer_form_view.dart';
import 'package:dragon_sword_purse/Find/Transfer/View/tld_recharge_qr_code_view.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class TLDNewTransferPage extends StatefulWidget {
  TLDNewTransferPage({Key key}) : super(key: key);

  @override
  _TLDNewTransferPageState createState() => _TLDNewTransferPageState();
}

class _TLDNewTransferPageState extends State<TLDNewTransferPage> {

  bool _isLoading = false;

  int _page = 1;

  List _dataSource = [];

  RefreshController _refreshController;

  TLDNewTransferModelManager _modelManager;

  double _rate = 0;

  String _paritiesStr = '获取汇率中';

  TLDNewTransferFormControl _formControl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = RefreshController(initialRefresh : true);

    _modelManager = TLDNewTransferModelManager();

    _formControl = TLDNewTransferFormControl(false);
  }


  void _getTransferList(int page){
     _modelManager.getTransferList(page, (List transferList,String paritiesStr,double rate){
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      if (page == 1){
        _dataSource = [];
      }
      setState(() {
        _dataSource.addAll(transferList);
        _paritiesStr = paritiesStr;
        _rate = rate;
      });
      _page = page + 1;
    }, (TLDError error){
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _withdraw(TLDNewTransferPramamter pramamter){
    setState(() {
      _isLoading = true;
    });
    _modelManager.withdraw(pramamter, (){
      setState(() {
        if(mounted){
          _isLoading = false;
        }
      });
      Fluttertoast.showToast(msg: '划转请求成功，等待工作人员审核');
      _formControl.value = false;
      _formControl.value = true;
      _refreshController.requestRefresh();
    }, (TLDError error){
      setState(() {
        if(mounted){
          _isLoading = false;
        }
      });
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _recharge(TLDNewTransferPramamter pramamter){
    setState(() {
      _isLoading = true;
    });
    _modelManager.recharge(pramamter, (String qrCode,String amount){
      setState(() {
        if(mounted){
          _isLoading = false;
        }
      });
      _refreshController.requestRefresh();
      _formControl.value = false;
      _formControl.value = true;
      showDialog(context: context,builder : (context){
        return TLDRechargeQRCodeView(
          qrCode: qrCode,
          amount: amount,
        );
      });
    }, (TLDError error){
      setState(() {
        if(mounted){
          _isLoading = false;
        }
      });
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: LoadingOverlay(isLoading: _isLoading, child: _getBodyWidget(),),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      resizeToAvoidBottomInset : false,
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        actionsForegroundColor: Colors.white,
        border: Border.all(
          color : Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'find_root_page',
        transitionBetweenRoutes: false,
        middle: Text('划转',style: TextStyle(color : Colors.white),),
        automaticallyImplyLeading: true,
      ),
    );
  }


  Widget _getBodyWidget(){
    return _geHeaderWidget();
  }

  Widget _geHeaderWidget(){
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: ScreenUtil().setHeight(60),
          color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: EdgeInsets.only(top : ScreenUtil().setHeight(0),left : ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                child : TLDNewTransferFormView(paritiesStr: _paritiesStr,control: _formControl,rate: _rate,didClickSureBtnCallBack: (TLDNewTrasferType type,TLDNewTransferPramamter transferPramamter){
                if (type == TLDNewTrasferType.usdtTotldType){
                  _recharge(transferPramamter);
                }else {
                  _withdraw(transferPramamter);
                }
              },)
              ),
              Padding(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                child: Text('兑换单',style: TextStyle(color : Color.fromARGB(255, 102, 102, 102),fontSize : ScreenUtil().setSp(28)),),
              ),
              Expanded(child: _refreshWidget())
            ],
          )
        )
      ],
    );
  }

  Widget _getListView(){
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
      TLDNewTransferListModel listModel = _dataSource[index];
      return TLDNewTransferCell(listModel: listModel,didClickQrCodeCallBack: (){
        showDialog(context: context,builder : (context){
        return TLDRechargeQRCodeView(
          qrCode: listModel.qrCode,
          amount: listModel.usdtCount,
        );
      });
      },);
     },
    );
  }

  Widget _refreshWidget(){
    return  SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
        controller: _refreshController,
        child: _getListView(),
        header: WaterDropHeader(
          complete: Text(I18n.of(navigatorKey.currentContext).refreshComplete),
        ),
        onRefresh: () {
          _page = 1;
          _getTransferList(_page);
        }, 
        footer : CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text(I18n.of(context).pullUpToLoad);
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.canLoading){
                body = Text(I18n.of(context).dropDownToLoadMoreData);
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        onLoading: ()=> _getTransferList(_page),);
  }

}