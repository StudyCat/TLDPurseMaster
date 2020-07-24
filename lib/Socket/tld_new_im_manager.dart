import 'dart:io';
import 'package:dragon_sword_purse/eventBus/tld_envent_bus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:platform/platform.dart';

class TLDNewMessageModel{
  String text;
  File imageFile;
  int contentType;//1.文本 2.图片
  String toUserName;
}

MethodChannel channel = MethodChannel('jmessage_flutter');

/// 极光 IM 初始化
JmessageFlutter JMessage = new JmessageFlutter.private(channel, const LocalPlatform());

class TLDNewIMManager{
    void init() {
     JMessage.init(isOpenMessageRoaming: true, appkey:'fbc4ec1832b255c5dcb7944c',isProduction: true);

     JMessage.setDebugMode(enable: true);

     JMessage.applyPushAuthority(
        new JMNotificationSettingsIOS(
            sound: true,
            alert: true,
            badge: true)
      );
    }

    Future<bool> loginJpush(String userName,String password) async {
      JMUserInfo userInfo = await JMessage.login(username: userName, password: password);
      if (userInfo != null){
        return true;
      }else{
        return false;
      }
    }

    //会话列表监听接收消息
    void conversationRecieveMessageCallBack(Function(dynamic) receiveMessageCallBack){
      JMessage.addReceiveMessageListener((message) {
        receiveMessageCallBack(message);
      });
    }

    void conversationRemoveRecieveMessageCallBack(){
      JMessage.removeReceiveMessageListener((message) {
        
      });
    }

    void getReciveeMessageCallBack(String userName ,Function(dynamic) receiveMessageCallBack) async{
      await getConversation(userName);
      JMessage.addReceiveMessageListener((message) {
        JMNormalMessage normalMessage = message;
        JMUserInfo formUserInfo = normalMessage.from;
        if (formUserInfo.username == userName){
          receiveMessageCallBack(message);
        } 
      });
    }

    void removeRecieveMessageCallBack(String userName)async {
      JMSingle single = JMSingle.fromJson({'username':userName,'appKey':'fbc4ec1832b255c5dcb7944c'});
      await JMessage.exitConversation(target: single);
      JMessage.removeReceiveMessageListener((message) {
        
      });
    }

    void getHistoryMessage(String userName,int pageFrom,Function(List) success)async {
      JMSingle single = JMSingle.fromJson({'username':userName,'appKey':'fbc4ec1832b255c5dcb7944c'});
      List result = await JMessage.getHistoryMessages(type: single, from: pageFrom, limit: 10,isDescend: false);
      success(result);
    }

    Future<dynamic> sendMessage(TLDNewMessageModel messageModel) async{
      JMMessageType messageType;
      var message;
      JMSingle single = JMSingle.fromJson({'username':messageModel.toUserName,'appKey':'fbc4ec1832b255c5dcb7944c'});
      if (messageModel.contentType == 1){
        messageType = JMMessageType.text;
        message = await JMessage.createMessage(type: messageType, targetType: single,text: messageModel.text);
      }else{
        messageType = JMMessageType.image;
        message = await JMessage.createMessage(type: messageType, targetType: single,path: messageModel.imageFile.path);
      }
      var sendMessage = await JMessage.sendMessage(message: message,
        sendOption: JMMessageSendOptions.fromJson({
              'isShowNotification': true, 
              'isRetainOffline': true,
            }));
      return sendMessage;
    }

    Future getConversation(String userName) async{
      eventBus.fire(TLDInIMPageEvent());
       JMSingle single = JMSingle.fromJson({'username': userName,'appKey':'fbc4ec1832b255c5dcb7944c'});
      List dataList = await JMessage.getConversations();
      for (JMConversationInfo item in dataList) {
        JMUserInfo userInfo = item.target; 
        if (userInfo.username == userName){
          await JMessage.enterConversation(target: single);
          return;
        }
      }
      await JMessage.createConversation(target: single);
      await JMessage.enterConversation(target: single);
    }

    Future<List> getMessageConversationList()async{
      List dataList = await JMessage.getConversations();
      List resultList = [];
      for (JMConversationInfo item in dataList) {
        JMUserInfo userInfo = item.target;
        if (item.latestMessage != null && userInfo.username != 'TLDSystem'){
          resultList.add(item);
        }
      }
      return resultList;
    }

    Future<String> downloadImage(String messageId,String userName) async{
       JMSingle single = JMSingle.fromJson({'username': userName,'appKey':'fbc4ec1832b255c5dcb7944c'});
      Map map = await JMessage.downloadThumbImage(target: single, messageId: messageId);
      return map['filePath'];
    }

    Future<num> getUnreadMessageCount()async{
      num unreadCount = await JMessage.getAllUnreadCount();
      return unreadCount;
    }

    void getSystemMessageList(int pageFrom,Function(List) success) async{
      JMSingle single = JMSingle.fromJson({'username':'TLDSystem','appKey':'fbc4ec1832b255c5dcb7944c'});
      List result = await JMessage.getHistoryMessages(type: single, from: pageFrom, limit: 10,isDescend: true);
      success(result);
    }

    Future deleteSystemMessage(String messageId) async{
      JMSingle single = JMSingle.fromJson({'username':'TLDSystem','appKey':'fbc4ec1832b255c5dcb7944c'});
      await JMessage.deleteMessageById(type: single, messageId: messageId);
    }

    void addSystemMessageReceiveCallBack(Function(dynamic) callBack) {
      JMessage.addReceiveMessageListener((message) {
        JMNormalMessage normalMessage = message;
        if (normalMessage.from.username == 'TLDSystem'){
          callBack(message);
        }  
      });
    }

    void exitSystemConversation() async{
        JMSingle single = JMSingle.fromJson({'username':'TLDSystem','appKey':'fbc4ec1832b255c5dcb7944c'});
        await JMessage.exitConversation(target: single);
    }

    void removeSystemMessageReceiveCallBack(){
      JMessage.removeReceiveMessageListener((message) {
        
      });
    }
}