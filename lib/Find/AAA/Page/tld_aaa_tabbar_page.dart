import 'dart:async';
import 'dart:convert';

import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_data_manager.dart';
import 'package:dragon_sword_purse/Exchange/FirstPage/Page/tld_exchange_choose_wallet.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_friend_team_page.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_person_center_page.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_plus_star_page.dart';
import 'package:dragon_sword_purse/Find/Acceptance/Login/Page/tld_acceptance_login_page.dart';
import 'package:dragon_sword_purse/Find/RecieveRedEnvelope/Model/tld_revieve_red_envelope_model_manager.dart';
import 'package:dragon_sword_purse/Find/RecieveRedEnvelope/Page/tld_deteail_recieve_red_envelope_page.dart';
import 'package:dragon_sword_purse/Find/RecieveRedEnvelope/View/tld_unopen_red_envelope_alert_view.dart';
import 'package:dragon_sword_purse/Find/RedEnvelope/Model/tld_detail_red_envelope_model_manager.dart';
import 'package:dragon_sword_purse/Find/RootPage/Page/tld_find_root_page.dart';
import 'package:dragon_sword_purse/Socket/tld_new_im_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';


class TLDAAATabbarPage extends StatefulWidget {
  TLDAAATabbarPage({Key key}) : super(key: key);

  @override
  _TLDAAATabbarPageState createState() => _TLDAAATabbarPageState();
}

class _TLDAAATabbarPageState extends State<TLDAAATabbarPage> with WidgetsBindingObserver {
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      activeIcon: Image.asset('assetss/images/aaa_person_center.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      icon: Image.asset('assetss/images/aaa_person_center_unsel.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      title: Text('AAA',
          style: TextStyle(
            fontSize: 10,
          )),
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset('assetss/images/icon_aaa_plus_star.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      icon: Image.asset('assetss/images/icon_aaa_plus_star_unsel.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      title: Text('团队升星',
          style: TextStyle(
            fontSize: 10,
          )),
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset('assetss/images/icon_friend_team.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      icon: Image.asset('assetss/images/icon_friend_team_unsel.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      title: Text(
        '好友圈',
        style: TextStyle(fontSize: 10),
      ),
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset('assetss/images/icon_find.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      icon: Image.asset('assetss/images/icon_find_unsel.png',width: ScreenUtil().setWidth(60),height: ScreenUtil().setWidth(60),fit: BoxFit.cover,),
      title: Text('我的',
          style: TextStyle(
            fontSize: 10,
          ))
    )
  ];

  List pages;

  
  int currentIndex;

  PageController _pageController;

  
  TLDRecieveRedEnvelopeModelManager _redEnvelopeModelManager;

  bool _isLoading = false;

  StreamSubscription<String> _sub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentIndex = 0;

    _pageController = PageController();

    pages =  [
      TLDAAAPersonCenterPage(),
      TLDAAAPlusStarPage(),
      TLDAAAFriendTeamPage(),
      TLDFindRootPage()
      ];

    _redEnvelopeModelManager = TLDRecieveRedEnvelopeModelManager();

    WidgetsBinding.instance.addObserver(this);
    currentIndex = 0;
    _pageController = PageController();
    
    _loginIM();

    _initPlatformStateForStringUniLinks();

    _initUniLinks();
  }

  _loginIM()async{
    String username = await TLDDataManager.instance.getUserName();
    String password = await TLDDataManager.instance.getPassword();
    if (username != null && password != null){
          TLDNewIMManager().loginJpush(username, password);
    }
  }

   Future<Null> _initUniLinks() async {
    print('------获取参数--------');
    // Platform messages may fail, so we use a try/catch PlatformException.
      _sub = getLinksStream().listen((String link) async {
       Uri uri = Uri.parse(link);
       Map queryParameter = uri.queryParameters;
      if (queryParameter.containsKey('type')) {
        int type = int.parse(queryParameter['type']);
        String dataJson = queryParameter['data'];
        Map data = jsonDecode(dataJson);
        if (type == 1){
          String redEnvelopeId = data['redEnvelopeId'];
          _getRedEnvelopeInfo(redEnvelopeId);
        }else if (type == 2){
          String toWalletAddres = data['walletAddress'];
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TLDEchangeChooseWalletPage(
            transferWalletAddress: toWalletAddres,
            type: TLDEchangeChooseWalletPageType.transfer,
          )));
        }else if (type == 3){
           String inviteCode = data['inviteCode'];
           String token = await TLDDataManager.instance.getAcceptanceToken();
           if (token == null){
             Navigator.push(context, MaterialPageRoute(builder:(context) => TLDAcceptanceLoginPage(inviteCode: inviteCode,)));
           }else{
             Fluttertoast.showToast(msg: '您已注册TLD票据');
           }
        }
      }
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
   }
  
  //处理外部应用调起TLD
   _initPlatformStateForStringUniLinks() async {
    // Get the latest link
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      if (initialLink == null) {
        return;
      }
      if (initialLink == TLDDataManager.instance.lastLink) {
        return;
      }
      TLDDataManager.instance.lastLink = initialLink;
      Uri uri = Uri.parse(initialLink);
      Map queryParameter = uri.queryParameters;
      if (queryParameter.containsKey('type')) {
        int type = int.parse(queryParameter['type']);
        String dataJson = queryParameter['data'];
        Map data = jsonDecode(dataJson);
        if (type == 1){
          String redEnvelopeId = data['redEnvelopeId'];
          _getRedEnvelopeInfo(redEnvelopeId);
        }else if (type == 2){
          String toWalletAddres = data['walletAddress'];
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TLDEchangeChooseWalletPage(
            transferWalletAddress: toWalletAddres,
            type: TLDEchangeChooseWalletPageType.transfer,
          )));
        }else if (type == 3){
           String inviteCode = data['inviteCode'];
           String token = await TLDDataManager.instance.getAcceptanceToken();
           if (token == null){
             Navigator.push(context, MaterialPageRoute(builder:(context) => TLDAcceptanceLoginPage(inviteCode: inviteCode,)));
           }else{
             Fluttertoast.showToast(msg: '您已注册TLD票据');
           }
        }
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }
  }

    void _getRedEnvelopeInfo(String redEnvelopeId){
    _redEnvelopeModelManager.getRedEnvelopeInfo(redEnvelopeId, (TLDDetailRedEnvelopeModel redEnvelopeModel){
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
        Fluttertoast.showToast(msg: error.msg);
      }
    });
  }

    void _recieveRedEnvelope(String walletAddress,String redEnvelopeId){
    setState(() {
      _isLoading = true;
    });
    _redEnvelopeModelManager.recieveRedEnvelope(redEnvelopeId, walletAddress, (int recieveLogId){
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
  Widget build(BuildContext context) {
     return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        items: items,
        currentIndex: currentIndex,
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Color.fromARGB(255, 153, 153, 153),
        iconSize: 26,
        onTap: (index) => _getPage(index),
      ),
      body: Builder(builder: (BuildContext context) {
        return PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              return pages[index];
            },
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            onPageChanged: (int index) {
              // eventBus.fire(TLDAcceptanceTabbarClickEvent(index));
              setState(() {
                currentIndex = index;
              });
            },
          );
      }),
    );
  }

  void _getPage(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
    });
  }
}