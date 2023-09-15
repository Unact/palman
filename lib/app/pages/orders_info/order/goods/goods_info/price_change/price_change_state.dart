part of 'price_change_page.dart';

enum PriceChangeStateStatus {
  initial,
  dataLoaded,
  dateUpdated,
  priceUpdated
}

class PriceChangeState {
  PriceChangeState({
    this.status = PriceChangeStateStatus.initial,
    required this.goodsPricelist,
    required this.goodsEx,
    required this.dateFrom,
    required this.dateTo,
    required this.price,
  });

  final PriceChangeStateStatus status;

  final GoodsPricelistsResult goodsPricelist;
  final GoodsExResult goodsEx;
  final DateTime dateFrom;
  final DateTime? dateTo;
  final double? price;

  double get priceStep {
    final minStep = [
      ((goodsPricelist.price - goodsEx.goods.minPrice).abs() / 20).roundDigits(2),
      (price ?? 0) - goodsEx.goods.minPrice
    ].min;

    return minStep > 0 ? minStep : 0.01;
  }

  PriceChangeState copyWith({
    PriceChangeStateStatus? status,
    GoodsPricelistsResult? goodsPricelist,
    GoodsExResult? goodsEx,
    DateTime? dateFrom,
    Optional<DateTime>? dateTo,
    Optional<double>? price,
  }) {
    return PriceChangeState(
      status: status ?? this.status,
      goodsPricelist: goodsPricelist ?? this.goodsPricelist,
      goodsEx: goodsEx ?? this.goodsEx,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo != null ? dateTo.orNull : this.dateTo,
      price: price != null ? price.orNull : this.price
    );
  }
}
