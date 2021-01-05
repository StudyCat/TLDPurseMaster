
import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/Find/Transfer/Model/tld_new_transfer_model_manager.dart';
import 'package:dragon_sword_purse/Find/Transfer/View/tld_new_transfer_cell.dart';
import 'package:dragon_sword_purse/Find/Transfer/View/tld_new_transfer_form_view.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = RefreshController(initialRefresh : true);

    _modelManager = TLDNewTransferModelManager();
  }


  void _getTransferList(int page){
     _modelManager.getTransferList(page, (List transferList){
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      if (page == 1){
        _dataSource = [];
      }
      setState(() {
        _dataSource.addAll(transferList);
      });
      _page = page + 1;
    }, (TLDError error){
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: LoadingOverlay(isLoading: _isLoading, child: _getBodyWidget(),),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
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
              TLDNewTransferFormView(),
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
      return TLDNewTransferCell(listModel: _dataSource[index],);
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