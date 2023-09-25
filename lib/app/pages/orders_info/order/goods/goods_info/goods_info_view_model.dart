part of 'goods_info_page.dart';

class GoodsInfoViewModel extends PageViewModel<GoodsInfoState, GoodsInfoStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PricesRepository pricesRepository;

  GoodsInfoViewModel(
    this.appRepository,
    this.ordersRepository,
    this.pricesRepository,
    {
      required DateTime date,
      required Buyer buyer,
      required GoodsExResult goodsEx,
    }
  ) : super(
    GoodsInfoState(date: date, buyer: buyer, goodsEx: goodsEx),
    [appRepository, ordersRepository, pricesRepository]
  );

  @override
  GoodsInfoStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final goodsShipments = await ordersRepository.getGoodsShipments(
      buyerId: state.buyer.id,
      goodsId: state.goodsEx.goods.id
    );
    final goodsPricelists = await pricesRepository.getGoodsPricelists(
      date: state.date,
      goodsId: state.goodsEx.goods.id
    );
    final partnersPricelists = await pricesRepository.getPartnersPricelists(
      partnerId: state.buyer.partnerId,
      goodsId: state.goodsEx.goods.id
    );
    final partnersPrices = await pricesRepository.getPartnersPrices(
      partnerId: state.buyer.partnerId,
      goodsId: state.goodsEx.goods.id
    );
    final appInfo = await appRepository.getAppInfo();

    emit(state.copyWith(
      status: GoodsInfoStateStatus.dataLoaded,
      goodsShipments: goodsShipments,
      goodsPricelists: goodsPricelists,
      partnersPricelists: partnersPricelists,
      partnersPrices: partnersPrices,
      appInfo: appInfo
    ));
  }

  Future<void> updatePricelist(GoodsPricelistsResult goodsPricelist) async {
    if (state.curPartnerPricelist == null) return;

    await pricesRepository.updatePartnersPricelist(
      state.curPartnerPricelist!,
      pricelistId: Optional.of(goodsPricelist.id),
      needSync: Optional.of(true)
    );

    emit(state.copyWith(status: GoodsInfoStateStatus.pricelistUpdated));
  }

  Future<void> updatePrice(DateTime dateFrom, DateTime dateTo, double price) async {
    if (state.curPartnersPrice != null) {
      await pricesRepository.updatePartnersPrice(
        state.curPartnersPrice!,
        price: Optional.of(price),
        dateFrom: Optional.of(dateFrom),
        dateTo: Optional.of(dateTo),
        needSync: Optional.of(true)
      );
    } else {
      await pricesRepository.addPartnersPrice(
        goodsId: state.goodsEx.goods.id,
        partnerId: state.buyer.partnerId,
        price: price,
        dateFrom: dateFrom,
        dateTo: dateTo
      );
    }

    emit(state.copyWith(status: GoodsInfoStateStatus.priceUpdated));
  }
}
