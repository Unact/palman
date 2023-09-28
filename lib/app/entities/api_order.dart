part of 'entities.dart';

class ApiOrder extends Equatable {
  final int id;
  final DateTime date;
  final String status;
  final int? preOrderId;
  final bool needDocs;
  final bool needInc;
  final bool isBonus;
  final bool isPhysical;
  final int buyerId;
  final String? info;
  final bool isEditable;
  final String guid;
  final DateTime timestamp;
  final List<ApiOrderLine> lines;

  const ApiOrder({
    required this.id,
    required this.date,
    required this.status,
    this.preOrderId,
    required this.needDocs,
    required this.needInc,
    required this.isBonus,
    required this.isPhysical,
    required this.buyerId,
    this.info,
    required this.isEditable,
    required this.guid,
    required this.timestamp,
    required this.lines
  });

  factory ApiOrder.fromJson(dynamic json) {
    return ApiOrder(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      status: json['status'],
      preOrderId: json['preOrderId'],
      needDocs: json['needDocs'],
      needInc: json['needInc'],
      isBonus: json['isBonus'],
      isPhysical: json['isPhysical'],
      buyerId: json['buyerId'],
      info: json['info'],
      isEditable: json['isEditable'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      lines: json['lines'].map<ApiOrderLine>((e) => ApiOrderLine.fromJson(e)).toList()
    );
  }

  Order toDatabaseEnt() {
    return Order(
      id: id,
      date: date,
      status: status,
      preOrderId: preOrderId,
      needDocs: needDocs,
      needInc: needInc,
      isBonus: isBonus,
      isPhysical: isPhysical,
      buyerId: buyerId,
      info: info,
      isEditable: isEditable,
      needProcessing: false,
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
    status,
    preOrderId,
    needDocs,
    needInc,
    isBonus,
    isPhysical,
    buyerId,
    info,
    isEditable,
    guid,
    timestamp,
    lines
  ];
}
