part of 'entities.dart';

class ApiGoodsBonusProgramPrice extends Equatable {
  final int bonusProgramId;
  final int goodsId;
  final double price;

  const ApiGoodsBonusProgramPrice({
    required this.bonusProgramId,
    required this.goodsId,
    required this.price
  });

  factory ApiGoodsBonusProgramPrice.fromJson(dynamic json) {
    return ApiGoodsBonusProgramPrice(
      bonusProgramId: json['bonusProgramId'],
      goodsId: json['goodsId'],
      price: Parsing.parseDouble(json['price'])!
    );
  }

  GoodsBonusProgramPrice toDatabaseEnt() {
    return GoodsBonusProgramPrice(
      bonusProgramId: bonusProgramId,
      goodsId: goodsId,
      price: price
    );
  }

  @override
  List<Object> get props => [
    bonusProgramId,
    goodsId,
    price
  ];
}
