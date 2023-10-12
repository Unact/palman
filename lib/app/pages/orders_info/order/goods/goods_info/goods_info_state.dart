part of 'goods_info_page.dart';

enum GoodsInfoStateStatus {
  initial,
  dataLoaded,
  pricelistUpdated,
  priceUpdated
}

class GoodsInfoState {
  GoodsInfoState({
    this.status = GoodsInfoStateStatus.initial,
    this.user,
    required this.date,
    required this.buyer,
    required this.goodsEx,
    this.goodsShipments = const [],
    this.goodsPricelists = const [],
    this.partnersPrices = const [],
    this.partnersPricelists = const [],
    this.appInfo
  });

  final GoodsInfoStateStatus status;

  final User? user;
  final DateTime date;
  final Buyer buyer;
  final GoodsExResult goodsEx;
  final List<GoodsShipmentsResult> goodsShipments;
  final List<GoodsPricelistsResult> goodsPricelists;
  final List<PartnersPrice> partnersPrices;
  final List<PartnersPricelist> partnersPricelists;
  final AppInfoResult? appInfo;

  bool get showLocalImage => appInfo?.showLocalImage ?? true;
  bool get preOrderMode => user?.preOrderMode ?? false;

  PartnersPricelist? get curPartnerPricelist => partnersPricelists.firstWhereOrNull(
    (e) => goodsPricelists.map((e) => e.id).contains(e.pricelistId)
  );
  GoodsPricelistsResult? get curGoodsPricelist => goodsPricelists.firstWhereOrNull(
    (e) => partnersPricelists.map((e) => e.pricelistId).contains(e.id)
  );
  PartnersPrice? get curPartnersPrice => partnersPrices.firstOrNull;

  bool get needSync => (curPartnerPricelist?.needSync ?? false) || (curPartnersPrice?.needSync ?? false);

  GoodsInfoState copyWith({
    GoodsInfoStateStatus? status,
    User? user,
    DateTime? date,
    Buyer? buyer,
    GoodsExResult? goodsEx,
    List<GoodsShipmentsResult>? goodsShipments,
    List<GoodsPricelistsResult>? goodsPricelists,
    List<PartnersPrice>? partnersPrices,
    List<PartnersPricelist>? partnersPricelists,
    AppInfoResult? appInfo
  }) {
    return GoodsInfoState(
      status: status ?? this.status,
      user: user ?? this.user,
      date: date ?? this.date,
      buyer: buyer ?? this.buyer,
      goodsEx: goodsEx ?? this.goodsEx,
      goodsShipments: goodsShipments ?? this.goodsShipments,
      goodsPricelists: goodsPricelists ?? this.goodsPricelists,
      partnersPrices: partnersPrices ?? this.partnersPrices,
      partnersPricelists: partnersPricelists ?? this.partnersPricelists,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
