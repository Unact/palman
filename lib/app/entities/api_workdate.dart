part of 'entities.dart';

class ApiWorkdate extends Equatable {
  final DateTime date;

  const ApiWorkdate({
    required this.date
  });

  factory ApiWorkdate.fromJson(dynamic json) {
    return ApiWorkdate(
      date: Parsing.parseDate(json['date'])!
    );
  }

  Workdate toDatabaseEnt() {
    return Workdate(
      date: date
    );
  }

  @override
  List<Object> get props => [
    date
  ];
}
