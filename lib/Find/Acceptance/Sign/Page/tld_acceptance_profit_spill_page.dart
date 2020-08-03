import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_alert_view.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_web_page.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Sign/Model/tld_acceptance_profit_spill_model_manager.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Sign/View/tld_acceptance_profit_spill_cell.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Sign/View/tld_acceptance_profit_spill_unopen_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class TLDAcceptanceProfitSpillPage extends StatefulWidget {
  TLDAcceptanceProfitSpillPage({Key key,this.walletAddress}) : super(key: key);

  final String walletAddress;

  @override
  _TLDAcceptanceProfitSpillPageState createState() => _TLDAcceptanceProfitSpillPageState();
}

class _TLDAcceptanceProfitSpillPageState extends State<TLDAcceptanceProfitSpillPage> {

  RefreshController _refreshController;

  TLDAcceptanceProfitSpillModelManager _modelManager;

  bool _isLoading = false;

  List _dataSource = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = RefreshController(initialRefresh: true);

    _modelManager = TLDAcceptanceProfitSpillModelManager();
    _getSpillListInfo();
  }

  void _getSpillListInfo(){
    _modelManager.getSpillList((List spillList){
      _refreshController.refreshCompleted();
      _dataSource = [];
      if (mounted) {
        setState(() {
          _dataSource.addAll(spillList);
        });
      }
    }, (TLDError error){
      _refreshController.refreshCompleted();
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _getProfit(int overflowId){
    setState(() {
      _isLoading = true;
    });
    _modelManager.getProfit(overflowId, (){
      _refreshController.requestRefresh();
      Fluttertoast.showToast(msg: '领取成功');
      if (mounted) {
        setState(() {
      _isLoading = false;
    });
      }
      _getSpillListInfo();
    },(TLDError error){
      if (mounted) {
        setState(() {
      _isLoading = false;
    });
      }
      _refreshController.refreshCompleted();
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border.all(
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'acceptance_sign_page',
        transitionBetweenRoutes: false,
        middle: Text('收益溢出池',),
        trailing: IconButton(icon: Icon(IconData(0xe614,fontFamily : 'appIconFonts')), onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder : (context) => TLDWebPage(urlStr: 'http://128.199.126.189:8080/desc/overflow_profit_desc.html',title: '收益溢出池说明',)));
        }),
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        actionsForegroundColor: Color.fromARGB(255, 51, 51, 51)
      ),
      body: _getRefresWidget(),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

  Widget _getRefresWidget(){
    return SmartRefresher(
      // enablePullUp: true,
      enablePullDown: true,
      controller: _refreshController,
      child: LoadingOverlay(isLoading: _isLoading, child: _getBodyWidget()),
      header: WaterDropHeader(
        complete : Text('刷新完成'),
      ),
      onRefresh: (){
        _getSpillListInfo();
      },
    );
  }


  Widget _getBodyWidget(){
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        TLDAcceptanceProfitSpillListModel model = _dataSource[index];
        if (model.lock == false) {
          return TLDAcceptanceProfitSpillOpenCell(
          listModel: model,
          didClickwithdrawButtonCallBack: (){
            _getProfit(model.overflowId);
          },
        );
        }else{
          return TLDAcceptanceProfitSpillUnopenCell(
            listModel: model,
            didClickItemCallBack: (){
               showDialog(
               context: context,
             builder: (context) => TLDAlertView(alertString: model.tip,title: '温馨提示',didClickSureBtn: (){
             },),
      );
            },
          );
        }
     },
    );
  }

}