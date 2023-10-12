part of 'entities.dart';

class ApiReturnRemainsData extends Equatable {
  final List<ApiGoodsReturnStock> goodsReturnStocks;

  const ApiReturnRemainsData({
    required this.goodsReturnStocks
  });

  factory ApiReturnRemainsData.fromJson(Map<String, dynamic> json) {
    List<ApiGoodsReturnStock> goodsReturnStocks = json['goodsReturnStocks']
      .map<ApiGoodsReturnStock>((e) => ApiGoodsReturnStock.fromJson(e)).toList();

    return ApiReturnRemainsData(
      goodsReturnStocks: goodsReturnStocks,
    );
  }

  @override
  List<Object> get props => [
    goodsReturnStocks
  ];
}
