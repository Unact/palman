part of 'entities.dart';

class ApiReturnActLine extends Equatable {
  final int id;
  final int goodsId;
  final double vol;
  final int rel;
  final double price;
  final DateTime? productionDate;
  final bool isBad;
  final String guid;
  final DateTime timestamp;

  const ApiReturnActLine({
    required this.id,
    required this.goodsId,
    required this.vol,
    required this.rel,
    required this.price,
    required this.productionDate,
    required this.isBad,
    required this.guid,
    required this.timestamp
  });

  factory ApiReturnActLine.fromJson(dynamic json) {
    return ApiReturnActLine(
      id: json['id'],
      goodsId: json['goodsId'],
      vol: Parsing.parseDouble(json['vol'])!,
      rel: json['rel'],
      price: Parsing.parseDouble(json['price'])!,
      productionDate: Parsing.parseDate(json['productionDate']),
      isBad: json['isBad'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
    );
  }

  ReturnActLine toDatabaseEnt(String returnActGuid) {
    return ReturnActLine(
      id: id,
      returnActGuid: returnActGuid,
      goodsId: goodsId,
      vol: vol,
      rel: rel,
      price: price,
      productionDate: productionDate,
      isBad: isBad,
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
  List<Object?> get props => [
    id,
    goodsId,
    vol,
    rel,
    price,
    productionDate,
    isBad,
    guid,
    timestamp,
  ];
}
