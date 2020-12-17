import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'dart:convert' show json;


T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class TLDAAAUpgradeListModel {
  TLDAAAUpgradeListModel({
    this.fromNickName,
    this.toNickName,
    this.curLevelIcon,
    this.nextLevelIcon,
    this.tldCount,
    this.createTime,
    this.isAdd,
    this.upgradeLogId,
    this.receiveCount,
    this.isReceive
  });

  factory TLDAAAUpgradeListModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : TLDAAAUpgradeListModel(
              fromNickName: asT<String>(jsonRes['fromNickName']),
              toNickName: asT<String>(jsonRes['toNickName']),
              curLevelIcon: asT<String>(jsonRes['curLevelIcon']),
              nextLevelIcon: asT<String>(jsonRes['nextLevelIcon']),
              tldCount: asT<String>(jsonRes['tldCount']),
              createTime: asT<int>(jsonRes['createTime']),
              isAdd:  asT<bool>(jsonRes['isAdd']),
              upgradeLogId : asT<int>(jsonRes['upgradeLogId']),
              receiveCount : asT<String>(jsonRes['receiveCount']),
              isReceive :   asT<bool>(jsonRes['isReceive'])
            );

  String fromNickName;
  String toNickName;
  String curLevelIcon;
  String nextLevelIcon;
  String tldCount;
  int createTime;
  bool isAdd;
  int upgradeLogId;
  String receiveCount;
  bool isReceive;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fromNickName': fromNickName,
        'toNickName': toNickName,
        'curLevelIcon': curLevelIcon,
        'nextLevelIcon': nextLevelIcon,
        'tldCount': tldCount,
        'createTime': createTime,
        'isAdd' : isAdd,
        'upgradeLogId' : upgradeLogId,
        'receiveCount' : receiveCount,
        'isReceive' : isReceive
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class TLDAAAPersonCenterListModelManager {
  void getUpgradeList(int type, int page, Function success, Function failure) {
    TLDBaseRequest request = TLDBaseRequest(
        {'type': type, 'pageNo': page, 'pageSize': 10}, 'aaa/upgradeLog');
    request.postNetRequest((value) {
      List upgradeList = value['list'];
      List result = [];
      for (Map item in upgradeList) {
        TLDAAAUpgradeListModel pramaterModel = TLDAAAUpgradeListModel.fromJson(item);
        result.add(pramaterModel);
      }
      success(result);
    }, (error) => failure(error));
  }


  void getEarningWithId(int upgradeLogId, Function success, Function failure) {
    TLDBaseRequest request = TLDBaseRequest(
        {'upgradeLogId': upgradeLogId}, 'aaa/receiveUpgradeLevelProfit');
    request.postNetRequest((value) {
      success();
    }, (error) => failure(error));

  }

}
