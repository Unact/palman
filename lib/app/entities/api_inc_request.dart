part of 'entities.dart';

class ApiIncRequest extends Equatable {
  final int id;
  final DateTime date;
  final int buyerId;
  final double incSum;
  final String? info;
  final String status;
  final String guid;
  final DateTime timestamp;

  const ApiIncRequest({
    required this.id,
    required this.date,
    required this.buyerId,
    required this.incSum,
    this.info,
    required this.status,
    required this.guid,
    required this.timestamp
  });

  factory ApiIncRequest.fromJson(dynamic json) {
    return ApiIncRequest(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      incSum: Parsing.parseDouble(json['incSum'])!,
      info: json['info'],
      status: json['status'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  IncRequest toDatabaseEnt() {
    return IncRequest(
      id: id,
      date: date,
      buyerId: buyerId,
      incSum: incSum,
      info: info,
      status: status,
      guid: guid,
      isNew: false,
      isDeleted: false,
      timestamp: timestamp,
      currentTimestamp: timestamp,
      needSync: false
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    buyerId,
    incSum,
    info,
    status,
    guid,
    timestamp
  ];
}
