import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_alert_view.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_friend_team_model_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_person_center_model_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_user_info_page.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_friend_team_lock_cell.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_friend_team_open_cell.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_friend_team_unopen_cell.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_friend_team_unupgrade_cell.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_upgrade_action_sheet.dart';
import 'package:dragon_sword_purse/Message/Page/tld_message_page.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/View/message_button.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TLDAAAFriendTeamPage extends StatefulWidget {
  TLDAAAFriendTeamPage({Key key}) : super(key: key);

  @override
  _TLDAAAFriendTeamPageState createState() => _TLDAAAFriendTeamPageState();
}

class _TLDAAAFriendTeamPageState extends State<TLDAAAFriendTeamPage> {

  TLDAAAFriendTeamModelManager _modelManager;

  RefreshController _refreshController;

  List _dataSource;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshController = RefreshController(initialRefresh : true);

    _dataSource = [];
    _modelManager = TLDAAAFriendTeamModelManager();
    _getTeamList();
  }

  void _getTeamList(){
    _modelManager.getTeamInfo((List teamList){
      _refreshController.refreshCompleted();
      if (mounted){
        setState(() {
        _dataSource = teamList;
      });
      }
    }, (TLDError error){
       _refreshController.refreshCompleted();
       Fluttertoast.showToast(msg: error.msg);
    });
  }

    void _getUpgradeInfo(){
        setState(() {
      _isLoading = true;
    });
    _modelManager.getUpgradeInfo((TLDAAAUpgradeInfoModel upgradeInfoModel){
       if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      showModalBottomSheet(context: context, builder: (context){
        return TLDAAAUpgradeActionSheet(
          upgradeInfoModel: upgradeInfoModel,
          didClickUpgrade: (int type,String walletAddress,int paymentType,int ylbType){
            _upgrade(type, walletAddress,paymentType,ylbType);
          },
        );
      });
    }, (TLDError error){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _upgrade(int type,String walletAddress,int paymentType,int ylbType){
      setState(() {
      _isLoading = true;
    });
    _modelManager.upgrade(type, walletAddress,paymentType,ylbType, (){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
       showDialog(context: context,builder : (context) => TLDAlertView(type:TLDAlertViewType.normal,title: '提示',alertString: '升级成功',didClickSureBtn: (){

      },));
      _refreshController.requestRefresh();
      _getTeamList();
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
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border.all(
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'order_list_page',
        transitionBetweenRoutes: false,
        middle: Text('AAA'),
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        actionsForegroundColor: Color.fromARGB(255, 51, 51, 51),
        trailing: MessageButton(
              didClickCallBack: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TLDMessagePage())),
            ),
      ),
      body: LoadingOverlay(isLoading: _isLoading, child: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(
          complete: Text(I18n.of(navigatorKey.currentContext).refreshComplete),
        ),
        child: _getBodyWidget(context),
        onRefresh: () => _getTeamList(),
        )),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        TLDAAATeamModel teamModel = _dataSource[index];
        if (teamModel.lock == false){
          if (teamModel.isOpen == false){
            return TLDAAAFriendTeamUnOpenCell(
              teamModel: teamModel,
              didClickOpenItem: (){
                setState(() {
                  teamModel.isOpen = !teamModel.isOpen;
                });
              },
            );
          }else{
            return TLDAAAFriendTeamOpenCell(
              teamModel: teamModel,
              didClickOpenItem: (){
                setState(() {
                  teamModel.isOpen = !teamModel.isOpen;
                });
              },
              didClickTeamMemberCallBack: (int userId){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TLDAAAUserInfoPage(userId : userId),
                ));
              },
            );
          }
        }else{
          if (teamModel.isNeedUpgrade == false){
            return TLDAAAFriendTeamLockCell(
              teamModel: teamModel,
            );
          }else{
            return TLDAAAFriendTeamUnUpgradeCell(
              teamModel: teamModel,
              didClickUpgradeCallBack: (){
                _getUpgradeInfo();
              },
            );
          }
        }
     },
    );
  }
}