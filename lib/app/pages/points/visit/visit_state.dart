part of 'visit_page.dart';

enum VisitStateStatus {
  initial,
  dataLoaded,
  cameraError,
  cameraOpened,
  inProgress,
  success,
  failure,
  goodsAddedToList
}

class VisitState {
  VisitState({
    this.status = VisitStateStatus.initial,
    required this.visitEx,
    this.images = const [],
    this.softwares = const [],
    this.purposes = const [],
    this.goodsListVisitExList = const [],
    this.message = '',
    this.appInfo,
    required this.listGoods,
    this.takeSoftwarePhoto = false
  });

  final VisitStateStatus status;
  final VisitEx visitEx;
  final List<VisitImage> images;
  final List<VisitSoftware> softwares;
  final List<VisitPurpose> purposes;
  final List<GoodsListVisitExResult> goodsListVisitExList;
  final String message;
  final AppInfoResult? appInfo;
  final Map<GoodsList, List<int>> listGoods;
  final bool takeSoftwarePhoto;

  bool get showLocalImage => appInfo?.showLocalImage ?? true;

  VisitState copyWith({
    VisitStateStatus? status,
    VisitEx? visitEx,
    List<VisitImage>? images,
    List<VisitSoftware>? softwares,
    List<VisitPurpose>? purposes,
    List<GoodsListVisitExResult>? goodsListVisitExList,
    String? message,
    AppInfoResult? appInfo,
    Map<GoodsList, List<int>>? listGoods,
    bool? takeSoftwarePhoto
  }) {
    return VisitState(
      status: status ?? this.status,
      visitEx: visitEx ?? this.visitEx,
      images: images ?? this.images,
      softwares: softwares ?? this.softwares,
      purposes: purposes ?? this.purposes,
      goodsListVisitExList: goodsListVisitExList ?? this.goodsListVisitExList,
      message: message ?? this.message,
      appInfo: appInfo ?? this.appInfo,
      listGoods: listGoods ?? this.listGoods,
      takeSoftwarePhoto: takeSoftwarePhoto ?? this.takeSoftwarePhoto
    );
  }
}
