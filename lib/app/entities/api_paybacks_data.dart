part of 'entities.dart';

class ApiPaybacksData extends Equatable {
  final List<ApiPayback> paybacks;
  final List<ApiGoodsPayback> goodsPaybacks;

  const ApiPaybacksData({
    required this.paybacks,
    required this.goodsPaybacks
  });

  factory ApiPaybacksData.fromJson(Map<String, dynamic> json) {
    List<ApiPayback> paybacks = json['paybacks']
      .map<ApiPayback>((e) => ApiPayback.fromJson(e)).toList();
    List<ApiGoodsPayback> goodsPaybacks = json['goodsPaybacks']
      .map<ApiGoodsPayback>((e) => ApiGoodsPayback.fromJson(e)).toList();

    return ApiPaybacksData(paybacks: paybacks, goodsPaybacks: goodsPaybacks);
  }

  @override
  List<Object> get props => [
    paybacks,
    goodsPaybacks
  ];
}
