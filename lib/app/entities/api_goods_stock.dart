part of 'entities.dart';

class ApiGoodsStock extends Equatable {
  final int goodsId;
  final int siteId;
  final bool isVollow;
  final int vol;
  final int minVol;

  const ApiGoodsStock({
    required this.goodsId,
    required this.siteId,
    required this.isVollow,
    required this.vol,
    required this.minVol
  });

  factory ApiGoodsStock.fromJson(dynamic json) {
    return ApiGoodsStock(
      goodsId: json['goodsId'],
      siteId: json['siteId'],
      isVollow: json['isVollow'],
      vol: json['vol'],
      minVol: json['minVol'],
    );
  }

  GoodsStock toDatabaseEnt() {
    return GoodsStock(
      goodsId: goodsId,
      siteId: siteId,
      isVollow: isVollow,
      vol: vol,
      minVol: minVol
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    siteId,
    isVollow,
    vol,
    minVol
  ];
}
