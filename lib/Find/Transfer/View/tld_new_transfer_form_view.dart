import 'package:dragon_sword_purse/Base/tld_base_request.dart';
import 'package:dragon_sword_purse/CommonWidget/tld_amount_text_input_fprmatter.dart';
import 'package:dragon_sword_purse/Exchange/FirstPage/Page/tld_exchange_choose_wallet.dart';
import 'package:dragon_sword_purse/Find/Transfer/Model/tld_new_transfer_model_manager.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';
import 'package:dragon_sword_purse/Purse/TransferAccounts/Model/tld_transfer_accounts_model_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
enum TLDNewTrasferType{
  usdtTotldType,
  tldTousdtType
}


class TLDNewTransferFormControl extends ValueNotifier<TLDWalletInfoModel>{
  TLDNewTransferFormControl(TLDWalletInfoModel isSuccess) : super(isSuccess);
}

class TLDNewTransferFormUSDTAmountControl extends ValueNotifier<String>{
  TLDNewTransferFormUSDTAmountControl(String amount) : super(amount);
}

class TLDNewTransferFormView extends StatefulWidget {
  TLDNewTransferFormView({Key key, this.focusNode,this.paritiesStr,this.didClickSureBtnCallBack,this.rate,this.control,this.amountControl,this.walletInfoModel,this.inputAmountCallBack})
      : super(key: key);

  final FocusNode focusNode;

  final String paritiesStr;

  final Function didClickSureBtnCallBack;

  final double rate;

  final TLDNewTransferFormControl control;

  final TLDNewTransferFormUSDTAmountControl amountControl;

  final Function inputAmountCallBack;

  TLDWalletInfoModel walletInfoModel;

  @override
  _TLDNewTransferFormViewState createState() => _TLDNewTransferFormViewState();
}

class _TLDNewTransferFormViewState extends State<TLDNewTransferFormView> {
  TextEditingController _amountController;

  TextEditingController _addressController;

  TLDNewTransferPramamter _amountPramaterModel;

  TLDNewTrasferType _type = TLDNewTrasferType.usdtTotldType;

  TLDNewTransferModelManager _modelManager;

  String _usdtAmount = '0';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _modelManager = TLDNewTransferModelManager();

    _amountController = TextEditingController();

    _addressController = TextEditingController();

    _amountPramaterModel = TLDNewTransferPramamter();
    _amountPramaterModel.amount = '';
    _amountPramaterModel.tldWalletAddress = widget.walletInfoModel != null ? widget.walletInfoModel.walletAddress : '';

    widget.control.addListener(() {
      setState(() {
        if (widget.control.value != null){
          _amountController.text = '';
          _addressController.text = '';
          widget.walletInfoModel = widget.control.value;
          _amountPramaterModel = TLDNewTransferPramamter();
          _amountPramaterModel.amount = '';
          _amountPramaterModel.tldWalletAddress = widget.walletInfoModel.walletAddress;
        }
      });
    });

    widget.amountControl.addListener(() {
      setState(() {
        _usdtAmount = widget.amountControl.value;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Colors.white),
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(50),
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30),
          bottom: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          _getHeaderView(),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: _getTransferAmountWidget(),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('实时汇率',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                  Text(widget.paritiesStr,
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_type == TLDNewTrasferType.usdtTotldType ? '预计花费' : '预计到账',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                  Text(_usdtAmount + ' USDT',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                ]),
          ),
         Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('钱包余额',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                  Text(widget.walletInfoModel == null ? '' : widget.walletInfoModel.value + ' TLD',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: _getChooseWalletWidget(),
          ),
          Offstage(
            offstage: _type == TLDNewTrasferType.usdtTotldType,
            child: Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: _getUSDTAddressWidget(),
          ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Container(
              height: ScreenUtil().setHeight(80),
              width: MediaQuery.of(context).size.width -
                  ScreenUtil().setWidth(120),
              child: CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setHeight(40))),
                  child: Text('确认',
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: ScreenUtil().setSp(28))),
                  onPressed: () {
                    if (_type == TLDNewTrasferType.tldTousdtType){
                      if (_amountPramaterModel.amount.length == 0){
                        Fluttertoast.showToast(msg: '请输入提现数量');
                        return;
                      }else if (_amountPramaterModel.tldWalletAddress == null){
                        Fluttertoast.showToast(msg: '请选择TLD钱包');
                        return;
                      }else if (_amountPramaterModel.usdtWalletAddress == null){
                        Fluttertoast.showToast(msg: '请输入USDT钱包地址');
                        return;
                      }
                    }else {
                      if (_amountPramaterModel.amount.length == 0){
                        Fluttertoast.showToast(msg: '请输入充值数量');
                        return;
                      }else if (_amountPramaterModel.tldWalletAddress == null){
                        Fluttertoast.showToast(msg: '请选择TLD钱包');
                        return;
                      }
                    }
                    widget.didClickSureBtnCallBack(_type,_amountPramaterModel);
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _getHeaderView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            setState(() {
              if (_type == TLDNewTrasferType.usdtTotldType){
                _type = TLDNewTrasferType.tldTousdtType;
              }else {
                _type = TLDNewTrasferType.usdtTotldType;
              }
            });
            widget.inputAmountCallBack(_type,_amountPramaterModel.amount);
          },
          child: Container(
          height: ScreenUtil().setHeight(142),
          width: ScreenUtil().setWidth(120),
          color: Color.fromARGB(255, 242, 242, 242),
          child: Center(
            child: Image.asset(_type == TLDNewTrasferType.usdtTotldType ? 'assetss/images/usdt_tld.png' : 'assetss/images/tld_usdt.png',width: ScreenUtil().setWidth(100),height: ScreenUtil().setWidth(100),),
          ),
        ),
        ),
        Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(2)),
          child: Column(children: [
            Container(
              height: ScreenUtil().setHeight(70),
              width: MediaQuery.of(context).size.width -
                  ScreenUtil().setWidth(242),
              color: Color.fromARGB(255, 242, 242, 242),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_type == TLDNewTrasferType.usdtTotldType ? '   从USDT(Omni)钱包':'   从TLD钱包',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24)))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(2)),
              child: Container(
                height: ScreenUtil().setHeight(70),
                width: MediaQuery.of(context).size.width -
                    ScreenUtil().setWidth(242),
                color: Color.fromARGB(255, 242, 242, 242),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_type == TLDNewTrasferType.usdtTotldType ? '   充值到TLD钱包' : '   提到USDT(Omni)钱包',
                        style: TextStyle(
                            color: Color.fromARGB(255, 102, 102, 102),
                            fontSize: ScreenUtil().setSp(24)))
                  ],
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget _getTransferAmountWidget() {
    return Container(
      height: ScreenUtil().setHeight(100),
      decoration: BoxDecoration(color: Color.fromARGB(255, 242, 242, 242),borderRadius: BorderRadius.all(Radius.circular(4))),
      child: 
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
          // Divider(indent: 0,endIndent: 0,height: ScreenUtil().setHeight(4),color: Color.fromARGB(255, 228, 228, 228),),
          _getTransferAmountRowWidget(),
          // Divider(indent: 0,endIndent: 0,height: ScreenUtil().setHeight(4),color: Color.fromARGB(255, 228, 228, 228),),
      //   ],
      // ),
    );
  }

  Widget _getTransferAmountRowWidget(){
    return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            // alignment: FractionalOffset(0.8, 0.6),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left : ScreenUtil().setWidth(20)),
                child: Text('TLD',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: ScreenUtil().setSp(44))),
              ),
              Container(
                  width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(400),
                  height: ScreenUtil().setWidth(100),
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: CupertinoTextField(
                    enabled: widget.walletInfoModel == null ? false : true,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 242, 242, 242),
                      border : Border.all(color :Color.fromARGB(0, 0, 0, 0))
                    ),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: ScreenUtil().setSp(44),
                        textBaseline: TextBaseline.alphabetic),
                    controller: _amountController,
                    placeholder: _type == TLDNewTrasferType.usdtTotldType ? '请输入充值数量' : '请输入提现数量',
                    placeholderStyle: TextStyle(
                        color: Color.fromARGB(255, 153, 153, 153),
                        fontSize: ScreenUtil().setSp(30),
                        textBaseline: TextBaseline.alphabetic),
                    focusNode: widget.focusNode,
                    inputFormatters: [TLDAmountTextInputFormatter()],
                    onChanged: (String text){
                      _amountPramaterModel.amount = text;
                      widget.inputAmountCallBack(_type,text);
                    },
                  )),
            ],
          ),
          Offstage(
            offstage: _type == TLDNewTrasferType.usdtTotldType,
            child: Container(
              height: ScreenUtil().setWidth(100),
              child: Row(
            children: <Widget>[
              VerticalDivider(indent: 2,endIndent: 2,width: ScreenUtil().setHeight(6),color: Color.fromARGB(255, 228, 228, 228),),
              GestureDetector(
              onTap: () {
                if (widget.walletInfoModel != null){
                  setState(() {
                    _amountPramaterModel.amount = widget.walletInfoModel.value;
                    _amountController.text = widget.walletInfoModel.value;
                  });
                  widget.inputAmountCallBack(_type,_amountPramaterModel.amount);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right : ScreenUtil().setWidth(20),left:ScreenUtil().setWidth(20)),
                child: Container(
                height: ScreenUtil().setHeight(100),
                width: ScreenUtil().setWidth(100),
                child: Center(
                  child: Text(
                    '全部',
                    style: TextStyle(
                        color: Color.fromARGB(255, 51, 51, 51),
                        fontSize: ScreenUtil().setSp(44)),
                  )),
                ),
              ),
              )
            ],
          ),
            ),
          )
        ]);
  }

  Widget _getChooseWalletWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('钱包地址',
            style: TextStyle(
                color: Color.fromARGB(255, 102, 102, 102),
                fontSize: ScreenUtil().setSp(24))),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder : (context){
              return TLDEchangeChooseWalletPage(didChooseWalletCallBack: (TLDWalletInfoModel infoModel){
                setState(() {
                  widget.walletInfoModel = infoModel;
                  _amountPramaterModel.tldWalletAddress = infoModel.walletAddress;
                });
              },);
            }));
          },
          child:Container(
          height: ScreenUtil().setHeight(60),
          width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(250),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 242, 242, 242),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setHeight(30))),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setHeight(30)),
              child: Container(
                width: MediaQuery.of(context).size.width -
                    ScreenUtil().setWidth(310) -
                    ScreenUtil().setHeight(60),
                child: Text(
                    widget.walletInfoModel == null ? '请选择钱包' : widget.walletInfoModel.walletAddress,
                    maxLines: 2,
                    style: TextStyle(
                        color: Color.fromARGB(255, 102, 102, 102),
                        fontSize: ScreenUtil().setSp(24))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setHeight(20)),
              child: Icon(
                IconData(0xe61c, fontFamily: 'appIconFonts'),
                color: Colors.white,
              ),
            )
          ]),
        ),
        )
      ],
    );
  }

  Widget _getUSDTAddressWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('USDT地址',
            style: TextStyle(
                color: Color.fromARGB(255, 102, 102, 102),
                fontSize: ScreenUtil().setSp(24))),
        Container(
            height: ScreenUtil().setHeight(100),
            width:
                MediaQuery.of(context).size.width - ScreenUtil().setWidth(250),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: CupertinoTextField(
              controller: _addressController,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 242, 242, 242),
                border: Border.all(color: Color.fromARGB(0, 0, 0, 0)),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              maxLines: 3,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: ScreenUtil().setSp(24),
                  textBaseline: TextBaseline.alphabetic),
              placeholder: '请输入USDT地址',
              placeholderStyle: TextStyle(
                  color: Color.fromARGB(255, 203, 203, 203),
                  fontSize: ScreenUtil().setSp(24),
                  textBaseline: TextBaseline.alphabetic),
              onChanged: (String text){
                _amountPramaterModel.usdtWalletAddress = text;
              },
            ))
      ],
    );
  }
}
