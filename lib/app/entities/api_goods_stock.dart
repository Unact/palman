part of 'entities.dart';

class ApiGoodsStock extends Equatable {
  final int goodsId;
  final int siteId;
  final bool isVollow;
  final double factor;
  final double vol;

  const ApiGoodsStock({
    required this.goodsId,
    required this.siteId,
    required this.isVollow,
    required this.factor,
    required this.vol,
  });

  factory ApiGoodsStock.fromJson(dynamic json) {
    return ApiGoodsStock(
      goodsId: json['goodsId'],
      siteId: json['siteId'],
      isVollow: json['isVollow'],
      factor: Parsing.parseDouble(json['factor'])!,
      vol: Parsing.parseDouble(json['vol'])!
    );
  }

  GoodsStock toDatabaseEnt() {
    return GoodsStock(
      goodsId: goodsId,
      siteId: siteId,
      isVollow: isVollow,
      factor: factor,
      vol: vol
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    siteId,
    isVollow,
    factor,
    vol
  ];
}
