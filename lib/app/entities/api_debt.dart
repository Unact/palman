part of 'entities.dart';

class ApiDebt extends Equatable {
  final int id;
  final DateTime date;
  final int buyerId;
  final String info;
  final double debtSum;
  final double orderSum;
  final bool isCheck;
  final DateTime dateUntil;
  final bool overdue;

  const ApiDebt({
    required this.id,
    required this.date,
    required this.buyerId,
    required this.info,
    required this.debtSum,
    required this.orderSum,
    required this.isCheck,
    required this.dateUntil,
    required this.overdue
  });

  factory ApiDebt.fromJson(dynamic json) {
    return ApiDebt(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      info: json['info'],
      debtSum: Parsing.parseDouble(json['debtSum'])!,
      orderSum: Parsing.parseDouble(json['orderSum'])!,
      isCheck: json['isCheck'],
      dateUntil: Parsing.parseDate(json['dateUntil'])!,
      overdue: json['overdue']
    );
  }

  Debt toDatabaseEnt() {
    return Debt(
      id: id,
      date: date,
      buyerId: buyerId,
      info: info,
      debtSum: debtSum,
      orderSum: orderSum,
      isCheck: isCheck,
      dateUntil: dateUntil,
      overdue: overdue
    );
  }

  @override
  List<Object> get props => [
    id,
    date,
    buyerId,
    info,
    debtSum,
    orderSum,
    isCheck,
    dateUntil,
    overdue
  ];
}
