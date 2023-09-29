part of 'entities.dart';

class ApiDeposit extends Equatable {
  final int id;
  final String guid;
  final DateTime timestamp;
  final DateTime date;
  final double totalSum;
  final double checkTotalSum;
  final List<ApiEncashment> encashments;

  const ApiDeposit({
    required this.id,
    required this.guid,
    required this.timestamp,
    required this.date,
    required this.totalSum,
    required this.checkTotalSum,
    required this.encashments
  });

  factory ApiDeposit.fromJson(dynamic json) {
    return ApiDeposit(
      id: json['id'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      date: Parsing.parseDate(json['date'])!,
      totalSum: Parsing.parseDouble(json['totalSum'])!,
      checkTotalSum: Parsing.parseDouble(json['checkTotalSum'])!,
      encashments: json['encashments'].map<ApiEncashment>((e) => ApiEncashment.fromJson(e)).toList()
    );
  }

  Deposit toDatabaseEnt() {
    return Deposit(
      id: id,
      date: date,
      totalSum: totalSum,
      checkTotalSum: checkTotalSum,
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
    guid,
    timestamp,
    date,
    totalSum,
    checkTotalSum,
    encashments
  ];
}
