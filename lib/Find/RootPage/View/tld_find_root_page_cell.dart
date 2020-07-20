import 'package:dragon_sword_purse/Find/RootPage/Model/tld_find_root_model_manager.dart';
import 'package:dragon_sword_purse/Find/RootPage/View/tld_find_root_page_grid_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TLDFindRootPageCell extends StatefulWidget {
  TLDFindRootPageCell({Key key, this.uiModel,this.didClickItemCallBack}) : super(key: key);

  final TLDFindRootCellUIModel uiModel;

  final Function(String) didClickItemCallBack;

  @override
  _TLDFindRootPageCellState createState() => _TLDFindRootPageCellState();
}

class _TLDFindRootPageCellState extends State<TLDFindRootPageCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10),
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30)),
      child: Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(20),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(children: <InlineSpan>[
                  WidgetSpan(
                    child: Container(
                      color: Theme.of(context).hintColor,
                      height: ScreenUtil().setHeight(28),
                      width: ScreenUtil().setWidth(6),
                    ),
                  ),
                  TextSpan(
                      text: ' ' + widget.uiModel.title,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 51, 51, 51)))
                ]),
              ),
              Container(
                padding: EdgeInsets.only(top : ScreenUtil().setHeight(20)),
                height: ScreenUtil().setHeight(200),
                  child: GridView.builder(
                      physics: new NeverScrollableScrollPhysics(), //增加
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: ScreenUtil().setWidth(60),
                          mainAxisSpacing: ScreenUtil().setHeight(10)),
                      itemCount: widget.uiModel.items.length,
                      itemBuilder: (context, index) {
                        TLDFindRootCellUIItemModel itemModel =
                            widget.uiModel.items[index];
                        return GestureDetector(
                          onTap : (){
                            widget.didClickItemCallBack(itemModel.title);
                          },
                          child : TLDFindRootPageGridCell(itemUIModel: itemModel)
                        );
                      })),
            ]),
      ),
    );
  }
}