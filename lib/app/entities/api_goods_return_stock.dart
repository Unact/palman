part of 'entities.dart';

class ApiGoodsReturnStock extends Equatable {
  final int goodsId;
  final double vol;
  final int receptSubid;
  final int receptId;
  final DateTime receptDate;
  final String receptNdoc;
  final bool needMarking;

  const ApiGoodsReturnStock({
    required this.goodsId,
    required this.vol,
    required this.receptSubid,
    required this.receptId,
    required this.receptDate,
    required this.receptNdoc,
    required this.needMarking,
  });

  factory ApiGoodsReturnStock.fromJson(dynamic json) {
    return ApiGoodsReturnStock(
      goodsId: json['goodsId'],
      vol: Parsing.parseDouble(json['vol'])!,
      receptSubid: json['receptSubid'],
      receptId: json['receptId'],
      receptDate: Parsing.parseDate(json['receptDate'])!,
      receptNdoc: json['receptNdoc'],
      needMarking: json['needMarking']
    );
  }

  GoodsReturnStock toDatabaseEnt(int buyerId, int returnActTypeId) {
    return GoodsReturnStock(
      returnActTypeId: returnActTypeId,
      buyerId: buyerId,
      goodsId: goodsId,
      vol: vol,
      receptSubid: receptSubid,
      receptId: receptId,
      receptDate: receptDate,
      receptNdoc: receptNdoc,
      needMarking: needMarking
    );
  }

  @override
  List<Object> get props => [
    goodsId,
    vol,
    receptSubid,
    receptId,
    receptDate,
    receptNdoc,
    needMarking
  ];
}
