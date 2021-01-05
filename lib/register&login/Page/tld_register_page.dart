
import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_data_manager.dart';
import 'package:dragon_sword_purse/Find/AAA/Page/tld_aaa_tabbar_page.dart';
import 'package:dragon_sword_purse/dataBase/tld_database_manager.dart';
import 'package:dragon_sword_purse/generated/i18n.dart';
import 'package:dragon_sword_purse/register&login/Model/tld_register_model_manager.dart';
import 'package:dragon_sword_purse/register&login/Page/tld_register_invite_code_page.dart';
import 'package:dragon_sword_purse/register&login/View/tld_register_bottom_cell.dart';
import 'package:dragon_sword_purse/register&login/View/tld_register_header_cell.dart';
import 'package:dragon_sword_purse/register&login/View/tld_register_input_cell.dart';
import 'package:dragon_sword_purse/register&login/View/tld_register_verify_code_cell.dart';
import 'package:dragon_sword_purse/tld_not_purse_page.dart';
import 'package:dragon_sword_purse/tld_tabbar_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TLDRegisterView extends StatefulWidget {
  TLDRegisterView({Key key}) : super(key: key);

  @override
  _TLDRegisterViewState createState() => _TLDRegisterViewState();
}

class _TLDRegisterViewState extends State<TLDRegisterView> {
  TLDRegisterPramater _pramater;

  TLDRegisterModelManager _modelManager;

  bool _isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPurseList();

    _pramater = TLDRegisterPramater();

    _modelManager = TLDRegisterModelManager();
  }

  void _getPurseList() async{
    TLDDataBaseManager manager = TLDDataBaseManager();
     await manager.openDataBase();
     List allPurse = await manager.searchAllWallet();
    await manager.closeDataBase();
    allPurse == null ? TLDDataManager.instance.purseList = [] : TLDDataManager.instance.purseList = List.from(allPurse);
  }

  void _sendTelCode(bool isVerify)async{
    var status = await Permission.phone.status;
    if (status == PermissionStatus.denied) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      ].request();
      return;
    }else if(status == PermissionStatus.permanentlyDenied){
      Fluttertoast.showToast(msg: '请开启手机电话权限');
      return;
    }

    try{
    if (isVerify){
    List<SimCard> simCards = await MobileNumber.getSimCards;
    bool allHaveNumber = true;
    if (simCards == null){
       Fluttertoast.showToast(msg: '非法设备，你的手机未插入电话卡，请插入电话卡后再试。');
       return;
    }
    
    if (simCards.length == 0){
       Fluttertoast.showToast(msg: '非法设备，你的手机未插入电话卡，请插入电话卡后再试。');
       return;
    }

    for (SimCard item in simCards) {
        if (item.number == null){
          allHaveNumber = false;
          break;
        }

        if (item.number.length == 0){
          allHaveNumber = false;
          break;
        }
    }

    if (allHaveNumber){
     bool haveNumber = false;
     String cardNumStr= '';
     for (int i = 0; i < simCards.length;i++ ) {
       SimCard simCard = simCards[i];
       if (simCard.number.contains(_pramater.tel)){
         haveNumber = true;
         _pramater.mobileOperators = simCard.carrierName;
       }
       int cardNum = i + 1;
       String sonNumStr = '卡$cardNum :${simCard.number},';
       cardNumStr = cardNumStr + sonNumStr;
     }
     if (haveNumber == false){
       Fluttertoast.showToast(msg: '您当前手机的电话卡为：$cardNumStr  与你输入的不符合，请插入电话卡后再注册或者登录。');
      return;
     }

    }else{
      if (simCards.length == 0){
        Fluttertoast.showToast(msg: '非法设备，你的手机未插入电话卡，请插入电话卡后再试。');
        return;
      }
      }
    }

    setState(() {
      _isLoading = true;
    });
    _modelManager.getMessageCode(_pramater.tel, (){
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      Fluttertoast.showToast(msg: '获取验证码成功，请留意短信或者电话');
    }, (TLDError error){
      Fluttertoast.showToast(msg: error.msg);
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
    });
    }catch(e){
      Fluttertoast.showToast(msg: '非法设备，你的手机未插入电话卡，请插入电话卡后再试。');
    }
  }

  void _register() {
    if (_pramater.tel == null){
      Fluttertoast.showToast(msg: I18n.of(context).pleaseEnterYourCellPhoneNumber);
      return;
    } 
    if (_pramater.telCode == null){
      Fluttertoast.showToast(msg: I18n.of(context).pleaseEnterVerifyCode);
      return;
    }
    if (_pramater.telCode == null){
      Fluttertoast.showToast(msg: I18n.of(context).pleaseEnterYourNickName);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _modelManager.register(_pramater, (String token) async {
      if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
      TLDDataManager.instance.acceptanceToken = token;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('acceptanceToken', token);
      if (TLDDataManager.instance.purseList.length > 0){
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => TLDAAATabbarPage()), (route) => route == null);
      }else{
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => TLDNotPurseHomePage()), (route) => route == null);
      }
    }, (TLDError error){
       if (mounted){
        setState(() {
          _isLoading = false;
        });
      }
     if (error.code == -3){
       Navigator.push(context, MaterialPageRoute(builder: (context) => TLDRegisterInviteCodePage(pramater: _pramater,)));
     }else{
        Fluttertoast.showToast(msg: error.msg);
     }
    });
  }

  void _getSimVerify(){
    _modelManager.openSimVerify((bool isVerify){
      _sendTelCode(isVerify);
    },(TLDError error){
      _sendTelCode(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: LoadingOverlay(isLoading: _isLoading, child: _getBodyWidget()),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      appBar: CupertinoNavigationBar(
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        border: Border.all(
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        heroTag: 'register_page',
        transitionBetweenRoutes: false,
        middle: Text(I18n.of(context).register),
        automaticallyImplyLeading: false,
      ),
    );
  }

  Widget _getBodyWidget(){
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
      if (index == 0){
        return TLDRegisterHeaderCell();
      }else if(index < 3){
        String placeholder;
        if (index == 1){
          placeholder = I18n.of(context).pleaseEnterYourCellPhoneNumber;
        }else{
          placeholder = I18n.of(context).pleaseEnterYourNickName;
        }
        return TLDRegisterInputCell(placeHolder : placeholder,index: index,textDidChangeCallBack: (String text,int index){
          if (index == 1){
            _pramater.tel = text;
          }else{
            _pramater.nickname = text;
          }
        },);
      }else if (index == 3){
        return TLDRegisterVerifyCodeCell(didClickSendCodeBtnCallBack: (){
          _getSimVerify();
        },codeDidChangeCallBack: (str){
          _pramater.telCode = str;
        },
        );
      }
      return TLDRegisterBottomCell(
        didClickNextCallBack: (){
          _register();
        },
      );
     },
    );
  }



}