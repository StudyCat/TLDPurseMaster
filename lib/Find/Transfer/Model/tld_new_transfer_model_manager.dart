
import 'dart:convert' show json;

import 'package:dragon_sword_purse/Base/tld_base_request.dart';

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}     
 

class TLDNewTransferListModel {
    TLDNewTransferListModel({
this.logId,
this.acptUserId,
this.tldCount,
this.usdtCount,
this.transferStatus,
this.tldWalletAddress,
this.usdtWalletAddress,
this.transferDesc,
this.createTime,
this.valid,
    });


  factory TLDNewTransferListModel.fromJson(Map<String, dynamic> jsonRes)=>jsonRes == null? null:TLDNewTransferListModel(logId : asT<int>(jsonRes['logId']),
acptUserId : asT<int>(jsonRes['acptUserId']),
tldCount : asT<String>(jsonRes['tldCount']),
usdtCount : asT<String>(jsonRes['usdtCount']),
transferStatus : asT<int>(jsonRes['transferStatus']),
tldWalletAddress : asT<String>(jsonRes['tldWalletAddress']),
usdtWalletAddress : asT<String>(jsonRes['usdtWalletAddress']),
transferDesc : asT<String>(jsonRes['transferDesc']),
createTime : asT<int>(jsonRes['createTime']),
valid : asT<bool>(jsonRes['valid']),
);

  int logId;
  int acptUserId;
  String tldCount;
  String usdtCount;
  int transferStatus;//0处理中 1已完成 -1失败
  String tldWalletAddress;
  String usdtWalletAddress;
  String transferDesc;
  int createTime;
  bool valid;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'logId': logId,
        'acptUserId': acptUserId,
        'tldCount': tldCount,
        'usdtCount': usdtCount,
        'transferStatus': transferStatus,
        'tldWalletAddress': tldWalletAddress,
        'usdtWalletAddress': usdtWalletAddress,
        'transferDesc': transferDesc,
        'createTime': createTime,
        'valid': valid,
};

  @override
String  toString() {
    return json.encode(this);
  }
}

class TLDNewTransferModelManager{

  void getTransferList(int page ,Function success,Function failure){
    TLDBaseRequest request = TLDBaseRequest({'pageNo' : page,'pageSize' : 10},'wallet/usdtTransferLog');
    request.postNetRequest((value) {
      List data = value['list'];
      List result = [];
      for (Map item in data) {
        result.add(TLDNewTransferListModel.fromJson(item));
      }
      success(result);
    }, (error) => failure(error));
  }

  void transfer(String tldWalletAddress,String usdtWalletAddress,String tldCount,Function success,Function failure){
    TLDBaseRequest request = TLDBaseRequest({'tldWalletAddress':tldWalletAddress,'usdtWalletAddress':usdtWalletAddress,'tldCount':tldCount},'wallet/usdtTransfer');
    request.postNetRequest((value) {
      success();
    }, (error) => failure(error));
  }

}