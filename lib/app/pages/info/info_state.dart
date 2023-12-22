part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  dataLoaded,
  syncSuccess,
  syncFailure,
  syncInProgress,
  imageLoaded,
  imageLoadInProgress,
  imageLoadFailure,
  imageLoadSuccess,
  imageLoadCanceled,
  guidRegenerateSuccess,
  guidRegenerateFailure,
  reloadNeeded
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.message = '',
    this.syncMessage = '',
    this.isLoading = false,
    this.user,
    this.appInfo,
    this.pointImages = const [],
    this.loadedPointImages = 0,
    this.pointImagePreloadCanceled = true,
    this.goodsWithImage = const [],
    this.loadedGoodsImages = 0,
    this.goodsImagePreloadCanceled = true,
    this.loaded = 0,
    this.toLoad = 0
  });

  final InfoStateStatus status;
  final String message;
  final String syncMessage;
  final bool isLoading;
  final User? user;
  final AppInfoResult? appInfo;
  final List<PointImage> pointImages;
  final int loadedPointImages;
  final bool pointImagePreloadCanceled;
  final List<Goods> goodsWithImage;
  final int loadedGoodsImages;
  final bool goodsImagePreloadCanceled;
  final int loaded;
  final int toLoad;

  int get pendingChanges => appInfo == null ?
    0 :
    appInfo!.pointsToSync +
    appInfo!.preEncashmentsToSync +
    appInfo!.ordersToSync +
    appInfo!.incRequestsToSync +
    appInfo!.partnerPricesToSync +
    appInfo!.partnersPricelistsToSync +
    appInfo!.returnActsToSync;

  int get preEncashmentsTotal => appInfo == null ? 0 : appInfo!.preEncashmentsTotal;
  int get ordersTotal => appInfo == null ? 0 : appInfo!.ordersTotal;
  int get returnActsTotal => appInfo == null ? 0 : appInfo!.returnActsTotal;
  int get preOrdersTotal => appInfo == null ? 0 : appInfo!.preOrdersTotal;
  int get shipmentsTotal => appInfo == null ? 0 : appInfo!.shipmentsTotal;
  int get pointsTotal => appInfo == null ? 0 : appInfo!.pointsTotal;
  int get routePointsTotal => appInfo == null ? 0 : appInfo!.routePointsTotal;

  InfoState copyWith({
    InfoStateStatus? status,
    String? message,
    String? syncMessage,
    bool? isLoading,
    User? user,
    AppInfoResult? appInfo,
    List<PointImage>? pointImages,
    int? loadedPointImages,
    bool? pointImagePreloadCanceled,
    List<Goods>? goodsWithImage,
    int? loadedGoodsImages,
    bool? goodsImagePreloadCanceled,
    int? loaded,
    int? toLoad,
  }) {
    return InfoState(
      status: status ?? this.status,
      message: message ?? this.message,
      syncMessage: syncMessage ?? this.syncMessage,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      appInfo: appInfo ?? this.appInfo,
      pointImages: pointImages ?? this.pointImages,
      loadedPointImages: loadedPointImages ?? this.loadedPointImages,
      pointImagePreloadCanceled: pointImagePreloadCanceled ?? this.pointImagePreloadCanceled,
      goodsWithImage: goodsWithImage ?? this.goodsWithImage,
      loadedGoodsImages: loadedGoodsImages ?? this.loadedGoodsImages,
      goodsImagePreloadCanceled: goodsImagePreloadCanceled ?? this.goodsImagePreloadCanceled,
      loaded: loaded ?? this.loaded,
      toLoad: toLoad ?? this.toLoad,
    );
  }
}
