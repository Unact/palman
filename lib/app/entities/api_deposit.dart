part of 'entities.dart';

class ApiDeposit extends Equatable {
  final int id;
  final DateTime date;
  final double totalSum;
  final double checkTotalSum;

  const ApiDeposit({
    required this.id,
    required this.date,
    required this.totalSum,
    required this.checkTotalSum
  });

  factory ApiDeposit.fromJson(dynamic json) {
    return ApiDeposit(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      totalSum: Parsing.parseDouble(json['totalSum'])!,
      checkTotalSum: Parsing.parseDouble(json['checkTotalSum'])!
    );
  }

  Deposit toDatabaseEnt() {
    return Deposit(
      id: id,
      date: date,
      totalSum: totalSum,
      checkTotalSum: checkTotalSum
    );
  }

  @override
  List<Object> get props => [
    id,
    date,
    totalSum,
    checkTotalSum
  ];
}
