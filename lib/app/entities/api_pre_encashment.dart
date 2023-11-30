part of 'entities.dart';

class ApiPreEncashment extends Equatable {
  final int id;
  final String guid;
  final DateTime date;
  final bool needReceipt;
  final int debtId;
  final double encSum;
  final DateTime timestamp;

  const ApiPreEncashment({
    required this.id,
    required this.guid,
    required this.date,
    required this.debtId,
    required this.encSum,
    required this.needReceipt,
    required this.timestamp
  });

  factory ApiPreEncashment.fromJson(dynamic json) {
    return ApiPreEncashment(
      id: json['id'],
      guid: json['guid'],
      date: Parsing.parseDate(json['date'])!,
      debtId: json['debtId'],
      encSum: Parsing.parseDouble(json['encSum'])!,
      needReceipt: json['needReceipt'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  PreEncashment toDatabaseEnt() {
    return PreEncashment(
      id: id,
      date: date,
      debtId: debtId,
      encSum: encSum,
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
    encSum,
    needReceipt,
    timestamp
  ];
}
