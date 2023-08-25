part of 'entities.dart';

class ApiRemainsData extends Equatable {
  final List<ApiGoods> goods;
  final List<ApiGoodsStock> goodsStocks;
  final List<ApiGoodsRestriction> goodsRestrictions;

  const ApiRemainsData({
    required this.goods,
    required this.goodsStocks,
    required this.goodsRestrictions
  });

  factory ApiRemainsData.fromJson(Map<String, dynamic> json) {
    List<ApiGoods> goods = json['goods'].map<ApiGoods>((e) => ApiGoods.fromJson(e)).toList();
    List<ApiGoodsStock> goodsStocks = json['goodsStocks'].map<ApiGoodsStock>((e) => ApiGoodsStock.fromJson(e)).toList();
    List<ApiGoodsRestriction> goodsRestrictions = json['goodsRestrictions']
      .map<ApiGoodsRestriction>((e) => ApiGoodsRestriction.fromJson(e)).toList();

    return ApiRemainsData(
      goods: goods,
      goodsStocks: goodsStocks,
      goodsRestrictions: goodsRestrictions
    );
  }

  @override
  List<Object> get props => [
    goods,
    goodsStocks,
    goodsRestrictions
  ];
}
