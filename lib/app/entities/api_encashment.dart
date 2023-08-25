part of 'entities.dart';

class ApiEncashment extends Equatable {
  final int id;
  final String guid;
  final DateTime date;
  final bool isCheck;
  final int buyerId;
  final int debtId;
  final int depositId;
  final double encSum;
  final DateTime timestamp;

  const ApiEncashment({
    required this.id,
    required this.guid,
    required this.date,
    required this.buyerId,
    required this.debtId,
    required this.depositId,
    required this.encSum,
    required this.isCheck,
    required this.timestamp
  });

  factory ApiEncashment.fromJson(dynamic json) {
    return ApiEncashment(
      id: json['id'],
      guid: json['guid'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      debtId: json['debtId'],
      depositId: json['depositId'],
      encSum: Parsing.parseDouble(json['encSum'])!,
      isCheck: json['isCheck'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  Encashment toDatabaseEnt() {
    return Encashment(
      id: id,
      guid: guid,
      date: date,
      buyerId: buyerId,
      debtId: debtId,
      depositId: depositId,
      encSum: encSum,
      isCheck: isCheck,
      timestamp: timestamp,
      isBlocked: false,
      needSync: false
    );
  }

  @override
  List<Object> get props => [
    id,
    guid,
    date,
    buyerId,
    debtId,
    depositId,
    encSum,
    isCheck,
    timestamp
  ];
}
