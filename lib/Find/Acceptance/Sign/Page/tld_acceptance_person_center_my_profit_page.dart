import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Sign/Model/tld_acceptance_person_center_model_manager.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Sign/View/tld_acceptance_person_center_my_profit_cell.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TLDAcceptancePersonCenterMyProfitPage extends StatefulWidget {
  TLDAcceptancePersonCenterMyProfitPage({Key key}) : super(key: key);

  @override
  _TLDAcceptancePersonCenterMyProfitPageState createState() => _TLDAcceptancePersonCenterMyProfitPageState();
}

class _TLDAcceptancePersonCenterMyProfitPageState extends State<TLDAcceptancePersonCenterMyProfitPage> {
  TLDAcceptancePersonCenterProfitModelManager _modelManager;

  int _page = 1;

  RefreshController _refreshController;

  List _dataSource = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = RefreshController(initialRefresh : true);

    _modelManager = TLDAcceptancePersonCenterProfitModelManager();
    _getSignList();
  }

   void _getSignList(){
      _modelManager.getMyProfit((List profitList){
        _refreshController.refreshCompleted();
        _dataSource = [];
        if (mounted){ 
          setState(() {
            _dataSource.addAll(profitList);
          });
        }
      }, (TLDError error){
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        Fluttertoast.showToast(msg: error.msg);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      child: _getBodyWidget(),
      header: WaterDropHeader(
        complete : Text(I18n.of(context).refreshComplete),
      ),
      onRefresh: (){
        _getSignList();
      }
    );
  }

    Widget _getBodyWidget(){
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
      return TLDAcceptancePersonCenterMyProfitCell(profitModel: _dataSource[index],);
     },
    );
  }
}