import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_alert_view.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_web_page.dart';
import 'package:dragon_sword_purse/Exchange/FirstPage/Page/tld_exchange_choose_wallet.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_change_user_info_model_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_person_center_model_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_person_center_list_page.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_change_user_info_page.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_person_center_header_bottom_view.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_person_center_header_view.dart';
import 'package:dragon_sword_purse/Find/AAA/View/tld_aaa_upgrade_action_sheet.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Sign/Page/tld_acceptance_sign_son_page.dart';
import 'package:dragon_sword_purse/Find/YLB/Model/tld_ylb_choose_type_model_manager.dart';
import 'package:dragon_sword_purse/Message/Page/tld_message_page.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/View/message_button.dart';
import 'package:dragon_sword_purse/ceatePurse&importPurse/CreatePurse/Page/tld_create_purse_page.dart';
import 'package:dragon_sword_purse/eventBus/tld_envent_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TLDAAAPersonCenterPage extends StatefulWidget {
  TLDAAAPersonCenterPage({Key key}) : super(key: key);

  @override
  _TLDAAAPersonCenterPageState createState() => _TLDAAAPersonCenterPageState();
}

class _TLDAAAPersonCenterPageState extends State<TLDAAAPersonCenterPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  TabController _tabController;

  List _tabTitles = ['好友发起', '我的发起'];

  TLDAAAPersonFriendCenterModelManager _modelManager;

  TLDAAAUserInfo _userInfo;

  String _futureProfit = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _modelManager = TLDAAAPersonFriendCenterModelManager();
    _getUserInfo();
    _getFutureProfit();
  }

  void _getUserInfo() {
    setState(() {
      _isLoading = true;
    });
    _modelManager.getUserInfo((TLDAAAUserInfo userInfo) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _userInfo = userInfo;
        });
      }
    }, (TLDError error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _getFutureProfit() {
    _modelManager.getFutureProfit((String profit) {
      setState(() {
        _futureProfit = profit;
      });
    }, (TLDError error) {});
  }

  void _getUpgradeInfo() {
    setState(() {
      _isLoading = true;
    });
    _modelManager.getUpgradeInfo((TLDAAAUpgradeInfoModel upgradeInfoModel) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return TLDAAAUpgradeActionSheet(
              upgradeInfoModel: upgradeInfoModel,
              didClickUpgrade: (int type, String walletAddress, int paymentType,
                  int ylbType) {
                _upgrade(type, walletAddress, paymentType, ylbType);
              },
            );
          });
    }, (TLDError error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _upgrade(int type, String walletAddress, int paymentType, int ylbType) {
    setState(() {
      _isLoading = true;
    });
    _modelManager.upgrade(type, walletAddress, paymentType, ylbType, () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showDialog(
          context: context,
          builder: (context) => TLDAlertView(
                type: TLDAlertViewType.normal,
                title: '提示',
                alertString: '升级成功',
                didClickSureBtn: () {},
              ));
      _getUserInfo();
      eventBus.fire(TLDAAAUpgradeListRefreshEvent());
    }, (TLDError error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _recieve(String walletAddress) {
    setState(() {
      _isLoading = true;
    });
    _modelManager.recieve(walletAddress, () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showDialog(
          context: context,
          builder: (context) => TLDAlertView(
                type: TLDAlertViewType.normal,
                title: '提示',
                alertString: '已领取TLD到钱包内',
                didClickSureBtn: () {},
              ));
      _getUserInfo();
    }, (TLDError error) {
      if (mounted) {
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
      body: LoadingOverlay(
          isLoading: _isLoading,
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[_getAppBar()];
              },
              body: _getBodyWidget())),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

  Widget _getAppBar() {
    return SliverAppBar(
      centerTitle: true,
      expandedHeight: ScreenUtil().setHeight(870),
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[
        IconButton(
            icon: Icon(IconData(0xe80a, fontFamily: 'appIconFonts')),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TLDAAAChangeUserInfoPage(),
                  )).then((value) => _getUserInfo());
            }),
        Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
            child: MessageButton(
              color: Colors.white,
              didClickCallBack: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TLDMessagePage())),
            )),
      ],
      leading: Container(
        height: ScreenUtil().setHeight(34),
        width: ScreenUtil().setHeight(34),
        child: IconButton(
            icon: Icon(
              IconData(0xe614, fontFamily: 'appIconFonts'),
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TLDWebPage(
                            type: TLDWebPageType.aaaUrl,
                            title: 'AAA说明',
                          )));
            }),
      ),
      floating: true, //不随着滑动隐藏标题
      pinned: true, //不固定在顶部
      title: Text('AAA'),
      flexibleSpace: FlexibleSpaceBar(
        background: TLDAAAPersonCenterHeaderView(
          userInfo: _userInfo,
          futureProfit: _futureProfit,
          didClickWithdrawCallBack: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TLDEchangeChooseWalletPage(
                          didChooseWalletCallBack:
                              (TLDWalletInfoModel walletInfoModel) {
                            jugeHavePassword(
                                context,
                                () {
                                  _recieve(walletInfoModel.walletAddress);
                                },
                                TLDCreatePursePageType.back,
                                () {
                                  _recieve(walletInfoModel.walletAddress);
                                });
                          },
                        )));
          },
          didClickUpgradeButtonCallBack: () {
            _getUpgradeInfo();
          },
          didClickSignButton: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TLDAcceptanceSignSonPage(
                    userInfo: _userInfo,
                  ),
                )).then((value) => _getUserInfo());
          },
        ),
      ),
      bottom: _getAppBarBottom(),
    );
  }

  Widget _getAppBarBottom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(ScreenUtil().setHeight(110)),
      child: Container(
        color: Color.fromARGB(255, 242, 242, 242),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(40),
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                  top: ScreenUtil().setHeight(20)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Color.fromARGB(255, 242, 242, 242),
                ),
                height: ScreenUtil().setHeight(90),
                child: TabBar(
                  tabs: _tabTitles.map((title) {
                    return Tab(text: title);
                  }).toList(),
                  labelStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontSize: ScreenUtil().setSp(24)),
                  indicatorColor: Theme.of(context).hintColor,
                  labelColor: Color.fromARGB(255, 51, 51, 51),
                  unselectedLabelColor: Color.fromARGB(255, 153, 153, 153),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getBodyWidget() {
    return TabBarView(
      children: [
        SafeArea(
            child: TLDAAAPersonCenterListPage(
          type: 2,
          refreshCallBack: () {
            _getUserInfo();
          },
        )),
        SafeArea(
            child: TLDAAAPersonCenterListPage(
          type: 1,
        ))
      ],
      controller: _tabController,
    );
  }
}
