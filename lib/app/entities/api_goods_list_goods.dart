part of 'entities.dart';

class ApiGoodsListGoods extends Equatable {
  final int goodsId;
  final int goodsListId;

  const ApiGoodsListGoods({
    required this.goodsId,
    required this.goodsListId
  });

  factory ApiGoodsListGoods.fromJson(dynamic json) {
    return ApiGoodsListGoods(
      goodsId: json['goodsId'],
      goodsListId: json['goodsListId']
    );
  }

  GoodsListGoods toDatabaseEnt() {
    return GoodsListGoods(
      goodsId: goodsId,
      goodsListId: goodsListId
    );
  }

  @override
  List<Object?> get props => [
    goodsId,
    goodsListId
  ];
}
