import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dragon_sword_purse/CommonFunction/tld_common_function.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_alert_view.dart';
import 'package:dragon_sword_purse/IMUI/Page/tld_im_page.dart';
import 'package:dragon_sword_purse/Message/Page/tld_just_notice_page.dart';
import 'package:dragon_sword_purse/Order/Page/tld_detail_order_page.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Page/tld_purse_page.dart';
import 'package:dragon_sword_purse/Purse/MyPurse/Page/tld_my_purse_page.dart';
import 'package:dragon_sword_purse/Socket/tld_im_manager.dart';
import 'package:dragon_sword_purse/ceatePurse&importPurse/CreatePurse/Page/tld_create_purse_page.dart';
import 'package:dragon_sword_purse/ceatePurse&importPurse/CreatePurse/Page/tld_create_purse_success_page.dart';
import 'package:dragon_sword_purse/ceatePurse&importPurse/CreatePurse/Page/tld_creating_purse_page.dart';
import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';
import 'package:dragon_sword_purse/eventBus/tld_envent_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tld_tabbar_page.dart';
import 'Purse/Settings/Page/tld_purse_setting_page.dart';
import 'Purse/Settings/Page/tld_purse_backup_word_success_page.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'CommonWidget/tld_data_manager.dart';
import 'tld_home_page.dart';
import 'dart:io';
import 'package:uni_links/uni_links.dart';

void main(){
  final JPush jPush = JPush();

  Future<void> initPlatformState() async {

    jPush.setup(
      appKey: 'fbc4ec1832b255c5dcb7944c',
      channel: "developer-default",
      production: false,
      debug: true,
    );

     jPush.getRegistrationID().then((rid)  {
      TLDDataManager _manager = TLDDataManager.instance;
      _manager.registrationID = rid;
    });

    jPush.applyPushAuthority(
        NotificationSettingsIOS(sound: true, alert: true, badge: true)
    );

    try {

      jPush.addEventHandler(
          onReceiveNotification: (Map<String,dynamic>message) async {
            
          },
          onOpenNotification: (Map<String,dynamic>message) async {
            if (Platform.isAndroid){
            Map extras = message['extras'];
            Map dataMap = jsonDecode(extras['cn.jpush.android.EXTRA']);
            int type  = int.parse(dataMap['contentType']);
            if (type == 100 || type == 101 || type == 102 || type == 103 || type == 104 || type == 107){
            bool isBuyer = false;
            String buyerAddress = dataMap['buyerAddress'];
            List purseList = TLDDataManager.instance.purseList;
            List addressList = [];
            for (TLDWallet item in purseList) {
                addressList.add(item.address);
            }
            if (addressList.contains(buyerAddress)){
               isBuyer = true;
            }
              navigatorKey.currentState.push( MaterialPageRoute(builder: (context) => TLDDetailOrderPage(orderNo: dataMap['orderNo'],isBuyer: isBuyer,)));
            }else if (type == 105){
              String walletAddress = dataMap['toAddress'];
                List purseList = TLDDataManager.instance.purseList;
                TLDWallet wallet;
                for (TLDWallet item in purseList) {
                  if (item.address == walletAddress){
                    wallet = item;
                    break;
                  }
                }
              navigatorKey.currentState.push( MaterialPageRoute(builder: (context) => TLDMyPursePage(wallet: wallet,changeNameSuccessCallBack: (str){},)));
            }else if (type == 106){
              String appealId = dataMap['appealId'];
              navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => TLDJustNoticePage(appealId: int.parse(appealId))));
            }
          }
          }
      );
    } on Exception {
      print("---->获取平台版本失败");
    }
  }

  runApp(MyApp());

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initPlatformState();
  }

  
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  StreamSubscription _messageSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _registerEvent();  
  }


  void _registerEvent(){
    _messageSubscription = eventBus.on<TLDMessageEvent>().listen((event) {
        List messageList = event.messageList;
        for (TLDMessageModel item in messageList) {
          if (item.messageType == 2){
            _incrementCounter(item);
          }
        }
    });
  }

    void _incrementCounter(TLDMessageModel model) async {
       bool isFromOther = false; //是否为别人发的消息
       String fromAddress = model.fromAddress;
       List purseList = TLDDataManager.instance.purseList;
       List addressList = [];          
       for (TLDWallet item in purseList) {
           addressList.add(item.address);
       }
      if (!addressList.contains(fromAddress)){
          isFromOther = true;
       }
      if (isFromOther){
       String content;
       if (model.contentType == 1){
         content = model.content;
       }else{
         content = '[图片]';
       }
       Map map = model.toJson();
       String mapJson = jsonEncode(map);
       String title = '来自订单号'+ model.orderNo + '的聊天消息'; 
       var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
       );
       var iOS = new IOSNotificationDetails();
       var platform = new NotificationDetails(android, iOS);
       await flutterLocalNotificationsPlugin.show(
         0, title, content, platform,
         payload:mapJson);
       }
    }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
   
  }

  Future<void> onSelectNotification(String playload) async {
    Map message = jsonDecode(playload);
    TLDMessageModel model =  TLDMessageModel.fromJson(message);
    navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => TLDIMPage(otherGuyWalletAddress: model.fromAddress,selfWalletAddress: model.toAddress,orderNo: model.orderNo,)));
  }

  @override
  void dispose() { 
    _messageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : '屠龙刀',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primaryColor : Color.fromARGB(255, 57, 57, 57),
        hintColor: Color.fromARGB(255, 217, 176, 123)
      ),
      home: TLDHomePage(),
      // home: PlatformChannel(),
    );
  }
}








