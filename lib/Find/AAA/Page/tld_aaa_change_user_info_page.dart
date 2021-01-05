import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_clip_common_cell.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_clip_title_input_cell.dart';
import 'package:dragon_sword_purse/Exchange/FirstPage/Page/tld_exchange_choose_wallet.dart';
import 'package:dragon_sword_purse/Find/AAA/Model/tld_aaa_change_user_info_model_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_tabbar_page.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TLDAAAChangeUserInfoPage extends StatefulWidget {
  TLDAAAChangeUserInfoPage({Key key,this.isFirstLogin = false}) : super(key: key);

  final bool isFirstLogin;

  @override
  _TLDAAAChangeUserInfoPageState createState() => _TLDAAAChangeUserInfoPageState();
}

class _TLDAAAChangeUserInfoPageState extends State<TLDAAAChangeUserInfoPage> {

  bool _loading;

  List titles = [
    '昵称',
    '微信账号',
    '收款钱包'
  ];

  List placeholders = [
    '请输入昵称',
    '请输入微信账号',
    '请选择钱包',
  ];

  TLDAAAUserInfo _userInfo;

  TLDAAAChangeUserInfoModelManager _modelManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _loading = false;

    _userInfo = TLDAAAUserInfo();

    _modelManager = TLDAAAChangeUserInfoModelManager();

    _getUserInfo();
  }

  void _getUserInfo(){
    setState(() {
      _loading = true;
    });
    _modelManager.getUserInfo((TLDAAAUserInfo userInfo){
      if (mounted){
        setState(() {
          _loading = false;
          _userInfo = userInfo;
        });
      }
    }, (TLDError error){
      if (mounted){
        setState(() {
          _loading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }

  void _saveUserInfo(){
    if (_userInfo.nickName == null){
      Fluttertoast.showToast(msg: '请填写昵称');
      return;
    }
    if (_userInfo.wechat == null){
      Fluttertoast.showToast(msg: '请填写微信账号');
      return;
    }
    if (_userInfo.walletAddress == null){
      Fluttertoast.showToast(msg: '请选择钱包');
      return;
    }
    setState(() {
      _loading = true;
    });
    _modelManager.saveUserInfo(_userInfo, (){
      if (mounted){
        setState(() {
          _loading = false;
        });
      }
      Fluttertoast.showToast(msg: '保存成功');
      if (widget.isFirstLogin == true){
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => TLDAAATabbarPage(),));
      }
    }, (TLDError error){
            if (mounted){
        setState(() {
          _loading = false;
        });
      }
      Fluttertoast.showToast(msg: error.msg);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border.all(
          color : Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'bank_card_info_page',
        transitionBetweenRoutes: false,
        middle: Text('个人信息'),
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        actionsForegroundColor: Color.fromARGB(255, 51, 51, 51),
      ),
      body: LoadingOverlay(isLoading: _loading, child: _getBodyWidget(context)),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
    );
  }

   Widget _getBodyWidget(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: titles.length + 1,
      itemBuilder: (BuildContext context, int index){
        if (index < 2) {
          String content;
          if (index == 0){
            content = _userInfo.nickName != null ? _userInfo.nickName : '';
          }else{
            content = _userInfo.wechat != null ? _userInfo.wechat : '';
          }
          return Padding(
          padding: EdgeInsets.only(top:ScreenUtil().setHeight(2),left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
          child: TLDClipTitleInputCell(content: content,title : titles[index],placeholder: placeholders[index],textFieldEditingCallBack: (String string){
             if (index == 0){
               _userInfo.nickName = string;
            }else if(index == 1){
              _userInfo.tel = string;
            }else{
              _userInfo.wechat = string;
           }
        },),
        );
        }else if( index == 2){
          String content = _userInfo.walletAddress != null ? _userInfo.walletAddress : placeholders[index];
          return Padding(
            padding:  EdgeInsets.only(top:ScreenUtil().setHeight(2),left: ScreenUtil().setWidth(30),right: ScreenUtil().setWidth(30)),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TLDEchangeChooseWalletPage(didChooseWalletCallBack:(TLDWalletInfoModel walletInfoModel){
                    setState(() {
                      _userInfo.walletAddress = walletInfoModel.walletAddress;
                    });
                  }),
                ));
              },
              child: TLDClipCommonCell(type: TLDClipCommonCellType.normalArrow,title: titles[index],content: content,titleStyle:  TextStyle(
                    fontSize: ScreenUtil().setSp(24) ,
                    color: Color.fromARGB(255, 51, 51, 51)),contentStyle: TextStyle(
                    color: Color.fromARGB(255, 153, 153, 153),
                    fontSize: ScreenUtil().setSp(24)),),
            ),
            );
        }else{
          return  Padding(
            padding: EdgeInsets.only(top : ScreenUtil().setHeight(80)),
            child: Container(
            margin : EdgeInsets.only(top : ScreenUtil().setHeight(400),left: ScreenUtil().setWidth(100),right: ScreenUtil().setWidth(100)),
            height: ScreenUtil().setHeight(80),
            width:size.width -  ScreenUtil().setWidth(200),
            child: CupertinoButton(child: Text('保存',style: TextStyle(fontSize : ScreenUtil().setSp(28),color : Colors.white),),padding: EdgeInsets.all(0), color: Theme.of(context).primaryColor,onPressed: (){ 
              _saveUserInfo();
            }),
            ),
          ); 
        }
      }
    );
  }
}