part of 'info_page.dart';

enum InfoStateStatus {
  initial,
  dataLoaded,
  loadDeclined,
  loadSuccess,
  loadFailure,
  loadInProgress,
  loadConfirmation,
  saveSuccess,
  saveFailure,
  saveInProgress,
  syncSuccess,
  syncFailure,
  syncInProgress,
  imageLoaded,
  imageLoadInProgress,
  imageLoadFailure,
  imageLoadSuccess,
  imageLoadCanceled
}

class InfoState {
  InfoState({
    this.status = InfoStateStatus.initial,
    this.message = '',
    this.syncMessage = '',
    this.isBusy = false,
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
  final bool isBusy;
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
    appInfo!.depositsToSync +
    appInfo!.ordersToSync +
    appInfo!.incRequestsToSync +
    appInfo!.partnerPricesToSync +
    appInfo!.partnersPricelistsToSync;
  bool get hasPendingChanges => pendingChanges != 0;

  int get encashmentsTotal => appInfo == null ? 0 : appInfo!.encashmentsTotal;
  int get ordersTotal => appInfo == null ? 0 : appInfo!.ordersTotal;
  int get preOrdersTotal => appInfo == null ? 0 : appInfo!.preOrdersTotal;
  int get shipmentsTotal => appInfo == null ? 0 : appInfo!.shipmentsTotal;
  int get pointsTotal => appInfo == null ? 0 : appInfo!.pointsTotal;

  InfoState copyWith({
    InfoStateStatus? status,
    String? message,
    String? syncMessage,
    bool? isBusy,
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
      isBusy: isBusy ?? this.isBusy,
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
