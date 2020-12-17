import 'dart:async';

import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_alert_view.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_person_center_list_model_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_person_center_list_cell.dart';
import 'package:dragon_sword_purse/eventBus/tld_envent_bus.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TLDAAAPersonCenterListPage extends StatefulWidget {
  TLDAAAPersonCenterListPage({Key key,this.type,this.refreshCallBack}) : super(key: key);

  final Function refreshCallBack;

  final int type;

  @override
  _TLDAAAPersonCenterListPageState createState() => _TLDAAAPersonCenterListPageState();
}

class _TLDAAAPersonCenterListPageState extends State<TLDAAAPersonCenterListPage> {

  TLDAAAPersonCenterListModelManager _modelManager;

  List _dataSource;

  int _page = 1;

  RefreshController _refreshController;

  StreamSubscription _refreshSubscription;

  bool _isLoading = false;

  @override
  void initState() { 
    super.initState();

    _dataSource = [];

    _refreshController = RefreshController(initialRefresh: false);

    _refreshSubscription = eventBus.on<TLDAAAUpgradeListRefreshEvent>().listen((event) {
        _page = 1;
        _getUpgradeList(_page); 
    });

    _modelManager = TLDAAAPersonCenterListModelManager();
    _getUpgradeList(_page);  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _refreshSubscription.cancel();
    _refreshSubscription = null;
  }

  void _getUpgradeList(int page){
    _modelManager.getUpgradeList(widget.type, page, (List upgradeList){
       _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      if(page == 1){
        _dataSource = [];
      }
      if(mounted){
        setState(() {
          _dataSource.addAll(upgradeList);
        });
      }
      if(upgradeList.length > 0){
        _page = page + 1;
      }
    }, (TLDError error){
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _receiveEarnings(int upgradeLogId){
    setState(() {
      _isLoading = true;
    });
    _modelManager.getEarningWithId(upgradeLogId, (){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: '领取成功');
      widget.refreshCallBack();
    }, (TLDError error){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      if (error.code == 333){
        showDialog(context: context,builder : (context) {
          return TLDAlertView(title: '温馨提示',alertString: error.msg,sureTitle:  '确定',didClickSureBtn: (){
          });
        });
      }else{
        Fluttertoast.showToast(msg: error.msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(isLoading: _isLoading, child: _getRefreshWidget());
  }

  Widget _getRefreshWidget(){
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      controller: _refreshController,
      child: _getBodyWidget(),
      header: WaterDropHeader(
        complete : Text(I18n.of(navigatorKey.currentContext).refreshComplete),
      ),
      footer: CustomFooter(
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
      onRefresh: (){
        _page = 1;
        _getUpgradeList(_page);
      },
      onLoading: (){
        _getUpgradeList(_page);
      },
    );
  }

  Widget _getBodyWidget(){
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        TLDAAAUpgradeListModel model = _dataSource[index];
      return TLDAAAPersonCenterListCell(index: index,type: widget.type,listModel: model,didClickRecieveBtn: (){
        _receiveEarnings(model.upgradeLogId);
      },);
     },
    );
  }

}