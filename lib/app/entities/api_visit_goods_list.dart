part of 'entities.dart';

class ApiVisitGoodsList extends Equatable {
  final int id;
  final String guid;
  final DateTime timestamp;
  final int goodsListId;
  final List<ApiVisitGoodsListGoods> goods;

  const ApiVisitGoodsList({
    required this.id,
    required this.guid,
    required this.timestamp,
    required this.goodsListId,
    required this.goods
  });

  factory ApiVisitGoodsList.fromJson(dynamic json) {
    return ApiVisitGoodsList(
      id: json['id'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      goodsListId: json['goodsListId'],
      goods: json['goods'].map<ApiVisitGoodsListGoods>((e) => ApiVisitGoodsListGoods.fromJson(e)).toList()
    );
  }

  VisitGoodsList toDatabaseEnt(String visitGuid) {
    return VisitGoodsList(
      id: id,
      visitGuid: visitGuid,
      goodsListId: goodsListId,
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
    goodsListId,
    goods,
    guid,
    timestamp
  ];
}
