part of 'entities.dart';

class ApiPayback extends Equatable {
  final int id;
  final int partnerId;
  final DateTime dateFrom;
  final DateTime dateTo;
  final double percent;

  const ApiPayback({
    required this.id,
    required this.partnerId,
    required this.dateFrom,
    required this.dateTo,
    required this.percent,
  });

  factory ApiPayback.fromJson(dynamic json) {
    return ApiPayback(
      id: json['id'],
      partnerId: json['partnerId'],
      dateFrom: Parsing.parseDate(json['dateFrom'])!,
      dateTo: Parsing.parseDate(json['dateTo'])!,
      percent: Parsing.parseDouble(json['percent'])!,
    );
  }

  Payback toDatabaseEnt() {
    return Payback(
      id: id,
      partnerId: partnerId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      percent: percent,
    );
  }

  @override
  List<Object?> get props => [
    id,
    partnerId,
    dateFrom,
    dateTo,
    percent
  ];
}
