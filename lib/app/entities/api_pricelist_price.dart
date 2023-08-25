part of 'entities.dart';

class ApiPricelistPrice extends Equatable {
  final int goodsId;
  final int pricelistId;
  final double price;
  final DateTime dateFrom;
  final DateTime dateTo;

  const ApiPricelistPrice({
    required this.goodsId,
    required this.pricelistId,
    required this.price,
    required this.dateFrom,
    required this.dateTo,
  });

  factory ApiPricelistPrice.fromJson(dynamic json) {
    return ApiPricelistPrice(
      goodsId: json['goodsId'],
      pricelistId: json['pricelistId'],
      price: Parsing.parseDouble(json['price'])!,
      dateFrom: Parsing.parseDate(json['dateFrom'])!,
      dateTo: Parsing.parseDate(json['dateTo'])!
    );
  }

  PricelistPrice toDatabaseEnt() {
    return PricelistPrice(
      goodsId: goodsId,
      pricelistId: pricelistId,
      price: price,
      dateFrom: dateFrom,
      dateTo: dateTo
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    pricelistId,
    price,
    dateFrom,
    dateTo
  ];
}
