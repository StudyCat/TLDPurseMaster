import 'dart:convert' show json;

import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';

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
    this.transferStatusColor,
    this.transferStatusDesc,
    this.qrCode,
    this.type
  });

  factory TLDNewTransferListModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : TLDNewTransferListModel(
              logId: asT<int>(jsonRes['logId']),
              acptUserId: asT<int>(jsonRes['acptUserId']),
              tldCount: asT<String>(jsonRes['tldCount']),
              usdtCount: asT<String>(jsonRes['usdtCount']),
              transferStatus: asT<int>(jsonRes['transferStatus']),
              tldWalletAddress: asT<String>(jsonRes['tldWalletAddress']),
              usdtWalletAddress: asT<String>(jsonRes['usdtWalletAddress']),
              transferDesc: asT<String>(jsonRes['transferDesc']),
              createTime: asT<int>(jsonRes['createTime']),
              valid: asT<bool>(jsonRes['valid']),
              transferStatusColor: asT<String>(jsonRes['transferStatusColor']),
              transferStatusDesc: asT<String>(jsonRes['transferStatusDesc']),
              qrCode: asT<String>(jsonRes['qrCode']),
              type: asT<int>(jsonRes['type']), 
            );

  int logId;
  int acptUserId;
  String tldCount;
  String usdtCount;
  int transferStatus; //0处理中 1已完成 -1失败
  String tldWalletAddress;
  String usdtWalletAddress;
  String transferDesc;
  int createTime;
  bool valid;
  String transferStatusColor;
  String qrCode;
  String transferStatusDesc;
  int type; // 1提现 2 充值

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
        'transferStatusColor' : transferStatusColor,
        'transferStatusDesc' : transferStatusDesc,
        'qrCode' : qrCode,
        'type' : type
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class TLDNewTransferPramamter {
  String tldWalletAddress;
  String usdtWalletAddress;
  String amount;
}

class TLDNewTransferModelManager {
  void getTransferList(int page, Function success, Function failure) {
    TLDBaseRequest request = TLDBaseRequest(
        {'pageNo': page, 'pageSize': 10}, 'wallet/usdtTransferLog');
    request.postNetRequest((value) {
      List data = value['list'];
      List result = [];
      for (Map item in data) {
        result.add(TLDNewTransferListModel.fromJson(item));
      }
      Map paritiesMap = value['data'];
      String paritiesStr = paritiesMap['rateDesc'];
      double rate = paritiesMap['rate'];
      TLDWalletInfoModel wallet = TLDWalletInfoModel.fromJson(paritiesMap['walletObj']);
      success(result, paritiesStr, rate,wallet);
    }, (error) => failure(error));
  }

  void withdraw(
      TLDNewTransferPramamter pramamter, Function success, Function failure) {
    TLDBaseRequest request = TLDBaseRequest({
      'tldWalletAddress': pramamter.tldWalletAddress,
      'usdtWalletAddress': pramamter.usdtWalletAddress,
      'tldCount': pramamter.amount
    }, 'wallet/usdtTransfer');
    request.postNetRequest((value) {
      success();
    }, (error) => failure(error));
  }

  void recharge(
      TLDNewTransferPramamter pramamter, Function success, Function failure) {
    TLDBaseRequest request = TLDBaseRequest({
      'tldWalletAddress': pramamter.tldWalletAddress,
      'tldCount': pramamter.amount
    }, 'wallet/usdtRecharge');
    request.postNetRequest((value) {
      String qrCode = value['qrCode'];
      String amount = value['usdtCount'];
      success(qrCode, amount);
    }, (error) => failure(error));
  }

  void getAmount(String amount,int type, Function success, Function failure) {
    TLDBaseRequest request = TLDBaseRequest({
      'tldCount': amount,
      'type': type // 1提现 2 充值
    }, 'wallet/usdtRateCompute');
    request.postNetRequest((value) {
      success(value);
    }, (error) => failure(error));
  }
}
