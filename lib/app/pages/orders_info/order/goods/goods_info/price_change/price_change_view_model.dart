part of 'price_change_page.dart';

class PriceChangeViewModel extends PageViewModel<PriceChangeState, PriceChangeStateStatus> {
  PriceChangeViewModel({
    required GoodsExResult goodsEx,
    required GoodsPricelistsResult goodsPricelist,
    required double? price,
    required DateTime dateFrom,
    required DateTime dateTo
  }) : super(
    PriceChangeState(
      goodsEx: goodsEx,
      goodsPricelist: goodsPricelist,
      price: price,
      dateFrom: dateFrom,
      dateTo: dateTo
    )
  );

  @override
  PriceChangeStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    emit(state.copyWith(price: state.price == null ? Optional.of(state.goodsPricelist.price) : null));

    await super.initViewModel();
  }

  void updatePrice(double? price) async {
    emit(state.copyWith(
      status: PriceChangeStateStatus.priceUpdated,
      price: Optional.fromNullable(price?.roundDigits(2))
    ));
  }

  void updateDateTo(DateTime dateTo) async {
    emit(state.copyWith(
      status: PriceChangeStateStatus.dateUpdated,
      dateTo: dateTo
    ));
  }
}
