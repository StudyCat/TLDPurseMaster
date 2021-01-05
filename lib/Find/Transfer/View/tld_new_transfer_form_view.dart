import 'package:dragon_sword_purse/CommonWidget/tld_amount_text_input_fprmatter.dart';
import 'package:dragon_sword_purse/Purse/FirstPage/Model/tld_wallet_info_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDNewTransferFormView extends StatefulWidget {
  TLDNewTransferFormView({Key key, this.infoModel, this.focusNode})
      : super(key: key);

  final TLDWalletInfoModel infoModel;

  final FocusNode focusNode;

  @override
  _TLDNewTransferFormViewState createState() => _TLDNewTransferFormViewState();
}

class _TLDNewTransferFormViewState extends State<TLDNewTransferFormView> {
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = TextEditingController();
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
                  Text('0.11',
                      style: TextStyle(
                          color: Color.fromARGB(255, 102, 102, 102),
                          fontSize: ScreenUtil().setSp(24))),
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: _getChooseWalletWidget(),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: _getUSDTAddressWidget(),
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
                  onPressed: () {}),
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
        Container(
          height: ScreenUtil().setHeight(142),
          width: ScreenUtil().setWidth(120),
          color: Color.fromARGB(255, 242, 242, 242),
          child: Center(
            child: Image.asset('assetss/images/new_transfer_icon.png'),
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
                  Text('   从TLD钱包',
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
                    Text('   提到USDT钱包',
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
      height: ScreenUtil().setHeight(72),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 242, 242, 242),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0.8, 0.6),
            children: <Widget>[
              Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setWidth(48),
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: CupertinoTextField(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 242, 242, 242),
                        border: Border.all(color: Color.fromARGB(0, 0, 0, 0))),
                    enabled: widget.infoModel == null ? false : true,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: ScreenUtil().setSp(24),
                        textBaseline: TextBaseline.alphabetic),
                    controller: _controller,
                    focusNode: widget.focusNode,
                    inputFormatters: [TLDAmountTextInputFormatter()],
                  )),
              Text('TLD',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: ScreenUtil().setSp(24)))
            ],
          ),
          GestureDetector(
              onTap: () {},
              child: Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
                  child: Text(
                    '全部划转',
                    style: TextStyle(
                        color: Color.fromARGB(255, 102, 102, 102),
                        fontSize: ScreenUtil().setSp(24)),
                  )))
        ],
      ),
    );
  }

  Widget _getChooseWalletWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('钱包地址',
            style: TextStyle(
                color: Color.fromARGB(255, 102, 102, 102),
                fontSize: ScreenUtil().setSp(24))),
        Container(
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
                    'fewklfjwelkfwefjlwkfjkwlefjelwjfkwejflwefwfkl;ewfkl;wefw',
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
            ))
      ],
    );
  }
}
