part of 'entities.dart';

class ApiPartnersPrice extends Equatable {
  final int id;
  final int goodsId;
  final int partnerId;
  final double price;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String guid;
  final DateTime timestamp;

  const ApiPartnersPrice({
    required this.id,
    required this.goodsId,
    required this.partnerId,
    required this.price,
    required this.dateFrom,
    required this.dateTo,
    required this.guid,
    required this.timestamp
  });

  factory ApiPartnersPrice.fromJson(dynamic json) {
    return ApiPartnersPrice(
      id: json['id'],
      goodsId: json['goodsId'],
      partnerId: json['partnerId'],
      price: Parsing.parseDouble(json['price'])!,
      dateFrom: Parsing.parseDate(json['dateFrom'])!,
      dateTo: Parsing.parseDate(json['dateTo'])!,
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  PartnersPrice toDatabaseEnt() {
    return PartnersPrice(
      id: id,
      goodsId: goodsId,
      partnerId: partnerId,
      price: price,
      dateFrom: dateFrom,
      dateTo: dateTo,
      guid: guid,
      isDeleted: false,
      timestamp: timestamp,
      currentTimestamp: timestamp,
      lastSyncTime: timestamp
    );
  }

  @override
  List<Object> get props => [
    id,
    goodsId,
    partnerId,
    price,
    dateFrom,
    dateTo,
    guid,
    timestamp
  ];
}
