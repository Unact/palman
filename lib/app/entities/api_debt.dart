part of 'entities.dart';

class ApiDebt extends Equatable {
  final int id;
  final DateTime date;
  final int buyerId;
  final String info;
  final double debtSum;
  final double orderSum;
  final bool needReceipt;
  final DateTime dateUntil;
  final bool overdue;

  const ApiDebt({
    required this.id,
    required this.date,
    required this.buyerId,
    required this.info,
    required this.debtSum,
    required this.orderSum,
    required this.needReceipt,
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
      needReceipt: json['needReceipt'],
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
      needReceipt: needReceipt,
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
    needReceipt,
    dateUntil,
    overdue
  ];
}
