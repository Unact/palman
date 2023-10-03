part of 'entities.dart';

class ApiOrderLine extends Equatable {
  final int id;
  final int goodsId;
  final double vol;
  final double price;
  final double priceOriginal;
  final int package;
  final int rel;
  final String guid;
  final DateTime timestamp;

  const ApiOrderLine({
    required this.id,
    required this.goodsId,
    required this.vol,
    required this.price,
    required this.priceOriginal,
    required this.package,
    required this.rel,
    required this.guid,
    required this.timestamp
  });

  factory ApiOrderLine.fromJson(dynamic json) {
    return ApiOrderLine(
      id: json['id'],
      goodsId: json['goodsId'],
      vol: Parsing.parseDouble(json['vol'])!,
      price: Parsing.parseDouble(json['price'])!,
      priceOriginal: Parsing.parseDouble(json['priceOriginal'])!,
      package: json['package'],
      rel: json['rel'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  OrderLine toDatabaseEnt(String orderGuid) {
    return OrderLine(
      id: id,
      orderGuid: orderGuid,
      goodsId: goodsId,
      vol: vol,
      price: price,
      priceOriginal: priceOriginal,
      package: package,
      rel: rel,
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
    goodsId,
    vol,
    price,
    priceOriginal,
    package,
    rel,
    guid,
    timestamp
  ];
}
