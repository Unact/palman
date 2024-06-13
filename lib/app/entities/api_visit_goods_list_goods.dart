part of 'entities.dart';

class ApiVisitGoodsListGoods extends Equatable {
  final int id;
  final String guid;
  final DateTime timestamp;
  final int goodsId;

  const ApiVisitGoodsListGoods({
    required this.id,
    required this.guid,
    required this.timestamp,
    required this.goodsId,
  });

  factory ApiVisitGoodsListGoods.fromJson(dynamic json) {
    return ApiVisitGoodsListGoods(
      id: json['id'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      goodsId: json['goodsId']
    );
  }

  VisitGoodsListGoods toDatabaseEnt(String visitGoodsListGuid) {
    return VisitGoodsListGoods(
      id: id,
      visitGoodsListGuid: visitGoodsListGuid,
      goodsId: goodsId,
      guid: guid,
      isNew: false,
      isDeleted: false,
      timestamp: timestamp,
      currentTimestamp: timestamp,
      lastSyncTime: timestamp,
      needSync: false
    );
  }

  @override
  List<Object> get props => [
    id,
    guid,
    timestamp,
    goodsId
  ];
}
