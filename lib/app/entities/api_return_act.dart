part of 'entities.dart';

class ApiReturnAct extends Equatable {
  final int id;
  final String guid;
  final DateTime date;
  final String number;
  final int buyerId;
  final bool needPickup;
  final int returnActTypeId;
  final int? receptId;
  final String? receptNdoc;
  final DateTime? receptDate;
  final DateTime timestamp;
  final List<ApiReturnActLine> lines;

  const ApiReturnAct({
    required this.id,
    required this.guid,
    required this.date,
    required this.number,
    required this.buyerId,
    required this.needPickup,
    required this.returnActTypeId,
    required this.receptId,
    required this.receptNdoc,
    required this.receptDate,
    required this.timestamp,
    required this.lines
  });

  factory ApiReturnAct.fromJson(dynamic json) {
    return ApiReturnAct(
      id: json['id'],
      guid: json['guid'],
      date: Parsing.parseDate(json['date'])!,
      number: json['number'],
      buyerId: json['buyerId'],
      needPickup: json['needPickup'],
      returnActTypeId: json['returnActTypeId'],
      receptId: json['receptId'],
      receptNdoc: json['receptNdoc'],
      receptDate: Parsing.parseDate(json['receptDate']),
      timestamp: Parsing.parseDate(json['timestamp'])!,
      lines: json['lines'].map<ApiReturnActLine>((e) => ApiReturnActLine.fromJson(e)).toList()
    );
  }

  ReturnAct toDatabaseEnt() {
    return ReturnAct(
      id: id,
      date: date,
      number: number,
      buyerId: buyerId,
      needPickup: needPickup,
      returnActTypeId: returnActTypeId,
      receptId: receptId,
      receptNdoc: receptNdoc,
      receptDate: receptDate,
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
    number,
    buyerId,
    needPickup,
    returnActTypeId,
    receptId,
    receptNdoc,
    receptDate,
    lines,
    timestamp
  ];
}
