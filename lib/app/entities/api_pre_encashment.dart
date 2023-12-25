part of 'entities.dart';

class ApiPreEncashment extends Equatable {
  final int id;
  final String guid;
  final DateTime date;
  final bool needReceipt;
  final int debtId;
  final int buyerId;
  final String? info;
  final double encSum;
  final DateTime timestamp;

  const ApiPreEncashment({
    required this.id,
    required this.guid,
    required this.date,
    required this.debtId,
    required this.buyerId,
    required this.encSum,
    required this.info,
    required this.needReceipt,
    required this.timestamp
  });

  factory ApiPreEncashment.fromJson(dynamic json) {
    return ApiPreEncashment(
      id: json['id'],
      guid: json['guid'],
      date: Parsing.parseDate(json['date'])!,
      debtId: json['debtId'],
      buyerId: json['buyerId'],
      encSum: Parsing.parseDouble(json['encSum'])!,
      info: json['info'],
      needReceipt: json['needReceipt'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  PreEncashment toDatabaseEnt() {
    return PreEncashment(
      id: id,
      date: date,
      debtId: debtId,
      buyerId: buyerId,
      encSum: encSum,
      info: info,
      needReceipt: needReceipt,
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
    guid,
    date,
    debtId,
    buyerId,
    encSum,
    info,
    needReceipt,
    timestamp
  ];
}
