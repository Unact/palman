part of 'goods_info_page.dart';

class GoodsInfoViewModel extends PageViewModel<GoodsInfoState, GoodsInfoStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PricesRepository pricesRepository;
  StreamSubscription<List<GoodsShipmentsResult>>? goodsShipmentsSubscription;
  StreamSubscription<List<GoodsPricelistsResult>>? goodsPricelistsSubscription;
  StreamSubscription<List<PartnersPricelist>>? partnersPricelistsSubscription;
  StreamSubscription<List<PartnersPrice>>? partnersPricesSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  GoodsInfoViewModel(
    this.appRepository,
    this.ordersRepository,
    this.pricesRepository,
    {
      required DateTime date,
      required Buyer buyer,
      required GoodsExResult goodsEx,
    }
  ) : super(GoodsInfoState(date: date, buyer: buyer, goodsEx: goodsEx));

  @override
  GoodsInfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    goodsShipmentsSubscription = ordersRepository.watchGoodsShipments(
      buyerId: state.buyer.id,
      goodsId: state.goodsEx.goods.id
    ).listen((event) {
      emit(state.copyWith(status: GoodsInfoStateStatus.dataLoaded, goodsShipments: event));
    });
    goodsPricelistsSubscription = pricesRepository.watchGoodsPricelists(
      date: state.date,
      goodsId: state.goodsEx.goods.id
    ).listen((event) {
      emit(state.copyWith(status: GoodsInfoStateStatus.dataLoaded, goodsPricelists: event));
    });
    partnersPricelistsSubscription = pricesRepository.watchPartnersPricelists(
      partnerId: state.buyer.partnerId,
      goodsId: state.goodsEx.goods.id
    ).listen((event) {
      emit(state.copyWith(status: GoodsInfoStateStatus.dataLoaded, partnersPricelists: event));
    });
    partnersPricesSubscription = pricesRepository.watchPartnersPrices(
      partnerId: state.buyer.partnerId,
      goodsId: state.goodsEx.goods.id
    ).listen((event) {
      emit(state.copyWith(status: GoodsInfoStateStatus.dataLoaded, partnersPrices: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: GoodsInfoStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await goodsShipmentsSubscription?.cancel();
    await goodsPricelistsSubscription?.cancel();
    await partnersPricelistsSubscription?.cancel();
    await partnersPricesSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> updatePricelist(GoodsPricelistsResult goodsPricelist) async {
    if (state.curPartnerPricelist == null) return;

    await pricesRepository.updatePartnersPricelist(
      state.curPartnerPricelist!,
      pricelistId: Optional.of(goodsPricelist.id)
    );

    emit(state.copyWith(status: GoodsInfoStateStatus.pricelistUpdated));
  }

  Future<void> updatePrice(DateTime dateFrom, DateTime dateTo, double price) async {
    if (state.curPartnersPrice != null) {
      await pricesRepository.updatePartnersPrice(
        state.curPartnersPrice!,
        price: Optional.of(price),
        dateFrom: Optional.of(dateFrom),
        dateTo: Optional.of(dateTo)
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
