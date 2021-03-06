import 'dart:convert';

import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_data_manager.dart';
import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';

class TLDMineRankModel {
  String walletAddress;
  int rankSort;
  String rankProfit;
  int rankType;
  String createTime;

  TLDMineRankModel(
      {this.walletAddress,
      this.rankSort,
      this.rankProfit,
      this.rankType,
      this.createTime});

  TLDMineRankModel.fromJson(Map<String, dynamic> json) {
    walletAddress = json['walletAddress'];
    rankSort = json['rankSort'];
    rankProfit = json['rankProfit'];
    rankType = json['rankType'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletAddress'] = this.walletAddress;
    data['rankSort'] = this.rankSort;
    data['rankProfit'] = this.rankProfit;
    data['rankType'] = this.rankType;
    data['createTime'] = this.createTime;
    return data;
  }
}

class TLDRankMineModelManager {
   void getMineRankList(Function(List) success,Function(TLDError) failure){
     List purseList = TLDDataManager.instance.purseList;
      List addressList = [];
      for (TLDWallet item in purseList) {
        addressList.add(item.address);
      }
      String addressListJson = jsonEncode(addressList);
     TLDBaseRequest request = TLDBaseRequest({'list':addressListJson},'rank/myRankHistory');
     request.postNetRequest((value) {
       List dataList = value;
       List result = [];
       for (Map item in dataList) {
         result.add(TLDMineRankModel.fromJson(item));
       }
       success(result);
     }, (error) => failure(error));

   }
}