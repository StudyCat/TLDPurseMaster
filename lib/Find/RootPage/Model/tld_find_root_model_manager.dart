class TLDFindRootCellUIModel {
  String title;
  List items;
  TLDFindRootCellUIModel({this.title, this.items});
}

class TLDFindRootCellUIItemModel {
  String title = '';
  String imageAssest;
  bool isPlusIcon = false;
  TLDFindRootCellUIItemModel({this.imageAssest, this.title, this.isPlusIcon});
}

class TLDFindRootModelManager {
  static List get uiModelList {
    return [
      TLDFindRootCellUIModel(title: '玩法', items: [
        TLDFindRootCellUIItemModel(
            title: '承兑', imageAssest: 'assetss/images/icon_choose_accept.png',isPlusIcon: false),
        TLDFindRootCellUIItemModel(
            title: '任务', imageAssest: 'assetss/images/icon_choose_mission.png',isPlusIcon: false),
        TLDFindRootCellUIItemModel(title: '', imageAssest: '',isPlusIcon: true)
      ]),
      TLDFindRootCellUIModel(title: '其他', items: [
        TLDFindRootCellUIItemModel(
            title: '排行榜', imageAssest: 'assetss/images/icon_choose_rank.png',isPlusIcon: false),
      ])
    ];
  }
}