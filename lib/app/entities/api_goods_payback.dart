part of 'entities.dart';

class ApiGoodsPayback extends Equatable {
  final int goodsId;
  final int paybackId;

  const ApiGoodsPayback({
    required this.goodsId,
    required this.paybackId
  });

  factory ApiGoodsPayback.fromJson(dynamic json) {
    return ApiGoodsPayback(
      goodsId: json['goodsId'],
      paybackId: json['paybackId']
    );
  }

  GoodsPayback toDatabaseEnt() {
    return GoodsPayback(
      goodsId: goodsId,
      paybackId: paybackId,
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    paybackId
  ];
}
