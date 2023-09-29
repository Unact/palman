part of 'entities.dart';

class ApiPoint extends Equatable {
  final int id;
  final String guid;
  final String name;
  final String address;
  final String buyerName;
  final String reason;
  final double latitude;
  final double longitude;
  final int? pointFormat;
  final int numberOfCdesks;
  final String? emailOnlineCheck;
  final String? email;
  final String? phoneOnlineCheck;
  final String? inn;
  final String? jur;
  final int? plong;
  final int? maxdebt;
  final int? nds10;
  final int? nds20;
  final DateTime timestamp;
  final List<ApiPointImage> images;

  const ApiPoint({
    required this.id,
    required this.guid,
    required this.name,
    required this.address,
    required this.buyerName,
    required this.reason,
    required this.latitude,
    required this.longitude,
    this.pointFormat,
    required this.numberOfCdesks,
    this.emailOnlineCheck,
    this.email,
    this.phoneOnlineCheck,
    this.inn,
    this.jur,
    this.plong,
    this.maxdebt,
    this.nds10,
    this.nds20,
    required this.timestamp,
    required this.images
  });

  factory ApiPoint.fromJson(dynamic json) {
    return ApiPoint(
      id: json['id'],
      guid: json['guid'],
      name: json['name'],
      address: json['address'],
      buyerName: json['buyerName'],
      reason: json['reason'],
      latitude: Parsing.parseDouble(json['latitude'])!,
      longitude: Parsing.parseDouble(json['longitude'])!,
      pointFormat: json['pointFormat'],
      numberOfCdesks: json['numberOfCdesks'],
      emailOnlineCheck: json['emailOnlineCheck'],
      email: json['email'],
      phoneOnlineCheck: json['phoneOnlineCheck'],
      inn: json['inn'],
      jur: json['jur'],
      plong: json['plong'],
      maxdebt: json['maxdebt'],
      nds10: json['nds10'],
      nds20: json['nds20'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      images: json['images'].map<ApiPointImage>((e) => ApiPointImage.fromJson(e)).toList()
    );
  }

  Point toDatabaseEnt() {
    return Point(
      id: id,
      name: name,
      address: address,
      buyerName: buyerName,
      reason: reason,
      latitude: latitude,
      longitude: longitude,
      pointFormat: pointFormat,
      numberOfCdesks: numberOfCdesks,
      emailOnlineCheck: emailOnlineCheck,
      email: email,
      phoneOnlineCheck: phoneOnlineCheck,
      inn: inn,
      jur: jur,
      plong: plong,
      maxdebt: maxdebt,
      nds10: nds10,
      nds20: nds20,
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
    name,
    guid,
    name,
    address,
    buyerName,
    reason,
    latitude,
    longitude,
    pointFormat,
    numberOfCdesks,
    emailOnlineCheck,
    email,
    phoneOnlineCheck,
    inn,
    jur,
    plong,
    maxdebt,
    nds10,
    nds20,
    timestamp
  ];
}
