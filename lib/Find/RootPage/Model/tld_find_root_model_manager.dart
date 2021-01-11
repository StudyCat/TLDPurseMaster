import 'dart:convert';

import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_data_manager.dart';
import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/main.dart';

class TLDBannerModel {
  int bannerId;
  String bannerUrl;
  String bannerHref;
  int bannerSort;
  int createTime;
  bool valid;
  bool isNeedNavigation;

  TLDBannerModel(
      {this.bannerId,
      this.bannerUrl,
      this.bannerHref,
      this.bannerSort,
      this.createTime,
      this.valid,
      this.isNeedNavigation});

  TLDBannerModel.fromJson(Map<String, dynamic> json) {
    bannerId = json['bannerId'];
    bannerUrl = json['bannerUrl'];
    bannerHref = json['bannerHref'];
    bannerSort = json['bannerSort'];
    createTime = json['createTime'];
    valid = json['valid'];
    isNeedNavigation = json['isNeedNavigation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerId'] = this.bannerId;
    data['bannerUrl'] = this.bannerUrl;
    data['bannerHref'] = this.bannerHref;
    data['bannerSort'] = this.bannerSort;
    data['createTime'] = this.createTime;
    data['valid'] = this.valid;
    data['isNeedNavigation'] = this.isNeedNavigation;
    return data;
  }
}

class TLD3rdWebInfoModel{
  String url;
  String iconUrl;
  String name;
  bool isNeedHideNavigation;
  int appType;

   TLD3rdWebInfoModel(
      {this.url,
      this.iconUrl,
      this.name,
      this.isNeedHideNavigation,
      this.appType
      });

  TLD3rdWebInfoModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    iconUrl = json['iconUrl'];
    name = json['name'];
    isNeedHideNavigation = json["isNeedHideNavigation"];
    appType = json["appType"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['iconUrl'] = this.iconUrl;
    data['name'] = this.name;
    data["isNeedHideNavigation"] = this.isNeedHideNavigation;
    data["appType"] = this.appType;
    return data;
  }
}

class TLDFindRootCellUIModel {
  String title;
  List items;
  bool isHaveNotice;
  TLDFindRootCellUIModel({this.title, this.items,this.isHaveNotice});
}

class TLDFindRootCellUIItemModel {
  String title;
  String imageAssest;
  bool isPlusIcon;
  String url; //第三方应用地址
  bool isNeedHideNavigation; //第三方应用是否需要导航栏
  String iconUrl;
  int appType;
  TLDFindRootCellUIItemModel({this.imageAssest='', this.title='', this.isPlusIcon=false,this.url='',this.iconUrl='',this.isNeedHideNavigation = false,this.appType = 1});
}

class TLDFindRootModelManager {
  static List get uiModelList {
    return [
      TLDFindRootCellUIModel(title: '功能', isHaveNotice: true, items: [
        TLDFindRootCellUIItemModel(title: '钱包', imageAssest: 'assetss/images/find_wallet_icon.png',isPlusIcon: false),
        TLDFindRootCellUIItemModel(title: '购买', imageAssest: 'assetss/images/find_buy_icon.png',isPlusIcon: false),
        TLDFindRootCellUIItemModel(title: '出售', imageAssest: 'assetss/images/find_sale_icon.png',isPlusIcon: false),
        TLDFindRootCellUIItemModel(title: '划转', imageAssest: 'assetss/images/find_transfer_icon.png',isPlusIcon: false),
        TLDFindRootCellUIItemModel(title: '', imageAssest: '',isPlusIcon: true),
      ])
    ];
  }

  void getBannerInfo(Function success,Function(TLDError) failure){
    TLDBaseRequest request = TLDBaseRequest({},'banner/bannerList');
    request.postNetRequest((value) {
      List dataList = value;
      List result = [];
      for (Map item in dataList) {
        result.add(TLDBannerModel.fromJson(item));
      }
      success(result);
    }, (error) => failure(error));
  }

  void get3rdWebInfo(String qrCodeStr,Function(TLD3rdWebInfoModel) success,Function(TLDError) failure){
     try {
       if (qrCodeStr.contains('isTLD=true')){
        Uri uri = Uri.parse(qrCodeStr);
       String path = uri.path;
       String origin = uri.origin;
       if (uri.queryParameters.length == 0){
          TLDError error = TLDError(400,'无效的二维码');
          failure(error);
          return;
       }
       String iconUrl = uri.queryParameters['iconUrl'];
       String name = uri.queryParameters['name'];
       String url = origin + path;
       if (iconUrl == null || name == null || url == null){
         TLDError error = TLDError(400,'无效的二维码');
        failure(error);
        return;
       }
       TLD3rdWebInfoModel infoModel = TLD3rdWebInfoModel();
       infoModel.url = origin + path;
       infoModel.iconUrl = iconUrl;
       infoModel.isNeedHideNavigation = false;
       infoModel.appType = 0;
       if (uri.queryParameters["isNeedHideNavigation"] != null){
         if (uri.queryParameters["isNeedHideNavigation"] == "true"){
           infoModel.isNeedHideNavigation = true;
         }
       }
       infoModel.name = name;
       success(infoModel);
       }else{
         TLDError error = TLDError(400,'无效的二维码');
        failure(error);
       }
     }catch(e){
       TLDError error = TLDError(400,'二维码解析失败');
       failure(error);
     }
  }
  

  void save3rdPartWeb(TLD3rdWebInfoModel infoModel ,Function success,Function(TLDError) failure){
    TLDBaseRequest request = TLDBaseRequest({'appUrl':infoModel.url,'iconUrl':infoModel.iconUrl,"appName":infoModel.name,"isNeedHideNavigation":infoModel.isNeedHideNavigation},"play/saveApp");
    request.postNetRequest((value) {
      success();
    }, (error){
      failure(error);
    } );
  }


  void getPlatform3rdWeb(Function success,Function(TLDError) failure){
    TLDBaseRequest request = TLDBaseRequest({},"play/appList");
    request.postNetRequest((value) {
      List result = [];
      for (var item in value) {
        result.add(TLD3rdWebInfoModel.fromJson(item));
      }
      success(result);
    }, (error){
      failure(error);
    } );
  }


  void isOpenMission(Function success,Function(TLDError) failure){
    TLDBaseRequest request = TLDBaseRequest({},"common/isOpenTask");
    request.postNetRequest((value) {
      success(value);
    }, (error){
      failure(error);
    } );
  }



  void getGamePageInfo(Function success,Function failure){
    TLDBaseRequest request = TLDBaseRequest({},'play/gameAppList');

    request.postNetRequest((value) {
      List bannerStrList = value['gameBannerList'];
      List gameStrList = value['gameList'];
      List bannerList = [];
      List gameList = [];
      for (var item in bannerStrList) {
        bannerList.add(TLDBannerModel.fromJson(item));
      }
      for (var item in gameStrList) {
        gameList.add(TLD3rdWebInfoModel.fromJson(item));
      }
      success(bannerList,gameList);
    }, (error) => failure(error));
  }

  void haveAcceptanceUser(Function success,Function failure){
     TLDBaseRequest request = TLDBaseRequest({},'acpt/user/existAcptAccount');
    request.postNetRequest((value) {
      String walletAddress = value['walletAddress'];
      bool isExist = value['isExist'];
      bool needBinding = false;
      bool haveSameWallet = false;
      List purseList = TLDDataManager.instance.purseList;
      for (TLDWallet wallet in purseList) {
        if (wallet.address == walletAddress){
          haveSameWallet = true;
          break;
        }
      }
      if (isExist == true ){
        if (haveSameWallet == false){
          needBinding = true;
        }
      }else{
        needBinding = true;
      }
      success(needBinding);
    }, (error) => failure(error));
  }

    void getAllAmount(Function(String) success,Function(TLDError) failure){
      List purseList = TLDDataManager.instance.purseList;
      List addressList = [];
      for (TLDWallet item in purseList) {
        addressList.add(item.address);
      }
      String addressListJson = jsonEncode(addressList);
      TLDBaseRequest request = TLDBaseRequest({"list":addressListJson}, 'wallet/queryAccountTotal');
      request.postNetRequest((value) {
        Map data = value;
        success(data['total']);
      }, (error) => failure(error));
  }


  void haveAAAUserInfo(Function success,Function failure){
      TLDBaseRequest request = TLDBaseRequest({},'aaa/isExistAccount');
    request.postNetRequest((value) {
      success(value);
    }, (error) => failure(error));
  }

}
