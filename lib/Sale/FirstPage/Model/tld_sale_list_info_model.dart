

import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';

class TLDSaleListInfoModel {
  int sellId;
  String sellNo;
  String walletAddress;
  String currentCount;
  String payMethod;
  int createTime;
  String max;
  String totalCount;
  TLDWallet wallet;
  String realCount;
  String tmpWalletAddress;

  TLDSaleListInfoModel(
      {this.sellId,
      this.sellNo,
      this.walletAddress,
      this.currentCount,
      this.payMethod,
      this.createTime,
      this.max,
      this.totalCount,
      this.realCount,
      this.tmpWalletAddress,
      this.wallet});

  TLDSaleListInfoModel.fromJson(Map<String, dynamic> json) {
    sellId = json['sellId'];
    sellNo = json['sellNo'];
    walletAddress = json['walletAddress'];
    currentCount = json['currentCount'];
    payMethod = json['payMethod'];
    createTime = json['createTime'];
    max = json['max'];
    totalCount = json['totalCount'];
    realCount = json['realCount'];
    tmpWalletAddress = json['tmpWalletAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sellId'] = this.sellId;
    data['sellNo'] = this.sellNo;
    data['walletAddress'] = this.walletAddress;
    data['currentCount'] = this.currentCount;
    data['payMethod'] = this.payMethod;
    data['createTime'] = this.createTime;
    data['max'] = this.max;
    data['totalCount'] = this.totalCount;
    data['realCount'] = this.realCount;
    data['tmpWalletAddress'] = this.tmpWalletAddress;
    return data;
  }
}