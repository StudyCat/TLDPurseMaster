import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_data_manager.dart';
import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/api.dart';
import 'package:uuid_enhanced/uuid.dart';
import 'package:web3dart/crypto.dart';

class TLDError{
  int code;
  String msg;

  TLDError(int code,String msg){
    this.code = code;
    this.msg = msg;
  }
}

class TLDBaseRequest{
  //47.101.170.209 测试环境
  //192.168.1.120 本地环境
  static String baseUrl = 'http://47.101.170.209:8030/';
  Map pramatersMap;
  String subUrl;
  CancelToken cancelToken;
  bool isNeedSign;
  String walletAddress;

  TLDBaseRequest(Map pramatersMap,String subUrl){
    this.pramatersMap = pramatersMap;
    this.subUrl = subUrl;
    cancelToken = CancelToken();
  }
  
  String _authorizationEncode(String userToken,int time,String uuid){
     var content = new Utf8Encoder().convert(userToken);
     var digest = md5.convert(content);
     String md5Str = hex.encode(digest.bytes);
  

     Map authorizationMap = {'userToken':md5Str,'time':time,'uuid':uuid};
     String jsonStr = jsonEncode(authorizationMap);
     var base64Content = utf8.encode(jsonStr);
     var base64Digest = base64Encode(base64Content);
     return base64Digest;
  }

  void getNetRequest(Function(String) success, Function(TLDError) failure) async{
    try{
      Dio dio = Dio();
      String userToken = await TLDDataManager.instance.getUserToken();
      String acceptanceToken = await TLDDataManager.instance.getAcceptanceToken();
       Options options = Options(
        contentType : 'application/json', 
        receiveDataWhenStatusError: false,
     );
      if (userToken != null){
        int time = DateTime.now().millisecondsSinceEpoch;
        String uuid = Uuid.randomUuid().toString();
        String authorization = _authorizationEncode(userToken, time, uuid);
        options.headers = {'authorization':authorization,'time':time ,'uuid':uuid,'userToken':userToken,'version':'1.0.1'};
      }
      if (acceptanceToken != null){
        options.headers.addEntries({'jwtToken':acceptanceToken}.entries);
      }
     Response response = await dio.get(baseUrl+this.subUrl,queryParameters: this.pramatersMap,options: options,cancelToken: cancelToken);
     String jsonString = response.data;
     Map responseMap = jsonDecode(jsonString);
     String codeStr = responseMap['code'];
     String dataStr = responseMap['data'];
     if(int.parse(codeStr) == 200){
       success(dataStr);
     }else if (int.parse(codeStr) ==  -2){
       TLDDataManager.instance.deleteAcceptanceToken();
       TLDError error = TLDError(int.parse(codeStr),responseMap['msg']);
       failure(error);
     }else{
       TLDError error = TLDError(int.parse(codeStr),responseMap['msg']);
       failure(error);
     }
    }catch(e){
      TLDError error = TLDError(400,'网络接口出错');
       failure(error);
    }
  }

  void postNetRequest(ValueChanged<dynamic> success, Function(TLDError) failure) async{
    try{
      String userToken = await TLDDataManager.instance.getUserToken();
      String acceptanceToken = await TLDDataManager.instance.getAcceptanceToken();
      BaseOptions options = BaseOptions(
        contentType : 'application/json',
        receiveDataWhenStatusError: false
     );
       if (userToken != null){
        int time = DateTime.now().millisecondsSinceEpoch;
        String uuid = Uuid.randomUuid().toString();
        String authorization = _authorizationEncode(userToken, time, uuid);
        options.headers = {'authorization':authorization,'time':time ,'uuid':uuid,'userToken':userToken,'version':'1.0.1'};
      }
      if (acceptanceToken != null){
        options.headers.addEntries({'jwtToken':acceptanceToken}.entries);
      }
      if (this.isNeedSign == true) {
        _sign();
      }
      Dio dio = Dio(options);
     String url = baseUrl + this.subUrl;
     Response response = await dio.post(url,queryParameters: Map<String, dynamic>.from(this.pramatersMap),cancelToken: cancelToken);
     Map responseMap = response.data;
     String codeStr = responseMap['code'];
     dynamic dataStr = responseMap['data'];
     if(int.parse(codeStr) == 200){
       success(dataStr);
     }else{
       TLDError error = TLDError(int.parse(codeStr),responseMap['msg']);
       failure(error);
     }
    }catch(e){
      TLDError error = TLDError(400,'网络接口出错');
       failure(error);
    }
  }


  void _sign(){
    TLDWallet wallet;
    List purseList = TLDDataManager.instance.purseList;
    for (TLDWallet item in purseList) {
      if (item.address == this.walletAddress) {
        wallet = item;
      }
    }
    String pramaterStr = jsonEncode(this.pramatersMap);
    Uint8List privateKey = hexToBytes(wallet.privateKey);
    Uint8List messageHash = keccakUtf8(pramaterStr);
    MsgSignature signature = sign(messageHash, privateKey);
    Map signMap = {'r':signature.r.toString(),'v' : signature.v.toString(),'s':signature.s.toString()};
    String signStr = jsonEncode(signMap);
    this.pramatersMap.addEntries({'sign':signStr,'jsonStr':pramaterStr}.entries);
  } 


  void uploadFile(List datas,Function(List) success,Function(TLDError) failure)async{
      BaseOptions options = BaseOptions(
        contentType : 'application/json',
        receiveDataWhenStatusError: false
     );
     String url = baseUrl + 'common/uploadFile';
      Dio dio = Dio(options);
      List uploadDatas = [];
      for (File item in datas) {
        String path = item.path;
        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        MultipartFile file = await MultipartFile.fromFile(item.path,filename: name);
        uploadDatas.add(file); 
      }
      FormData formData = FormData.fromMap({
        'files' : uploadDatas
      });
      Response response = await dio.post(url,data:formData,cancelToken: cancelToken);
      Map responseMap = response.data;
      String codeStr = responseMap['code'];
     Map dataStr = responseMap['data'];
     List fileUrlList = dataStr['list'];
     if(int.parse(codeStr) == 200){
       success(fileUrlList);
     }else{
       TLDError error = TLDError(int.parse(codeStr),responseMap['msg']);
       failure(error);
     }
  }

  void cancelRequest(){
    cancelToken.cancel();
  } 

}