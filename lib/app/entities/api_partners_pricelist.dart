part of 'entities.dart';

class ApiPartnersPricelist extends Equatable {
  final int id;
  final int pricelistSetId;
  final int partnerId;
  final int pricelistId;
  final double discount;
  final String guid;
  final DateTime timestamp;

  const ApiPartnersPricelist({
    required this.id,
    required this.pricelistSetId,
    required this.partnerId,
    required this.pricelistId,
    required this.discount,
    required this.guid,
    required this.timestamp
  });

  factory ApiPartnersPricelist.fromJson(dynamic json) {
    return ApiPartnersPricelist(
      id: json['id'],
      pricelistSetId: json['pricelistSetId'],
      partnerId: json['partnerId'],
      pricelistId: json['pricelistId'],
      discount: Parsing.parseDouble(json['discount'])!,
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  PartnersPricelist toDatabaseEnt() {
    return PartnersPricelist(
      id: id,
      pricelistSetId: pricelistSetId,
      partnerId: partnerId,
      pricelistId: pricelistId,
      discount: discount,
      guid: guid,
      timestamp: timestamp,
      isBlocked: false,
      needSync: false
    );
  }

  @override
  List<Object> get props => [
    id,
    pricelistSetId,
    partnerId,
    pricelistId,
    discount,
    guid,
    timestamp
  ];
}
