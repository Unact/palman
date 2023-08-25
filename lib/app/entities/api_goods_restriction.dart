part of 'entities.dart';

class ApiGoodsRestriction extends Equatable {
  final int goodsId;
  final int buyerId;

  const ApiGoodsRestriction({
    required this.goodsId,
    required this.buyerId,
  });

  factory ApiGoodsRestriction.fromJson(dynamic json) {
    return ApiGoodsRestriction(
      goodsId: json['goodsId'],
      buyerId: json['buyerId'],
    );
  }

  GoodsRestriction toDatabaseEnt() {
    return GoodsRestriction(
      goodsId: goodsId,
      buyerId: buyerId
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    buyerId
  ];
}
