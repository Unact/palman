part of 'entities.dart';

class ApiVisit extends Equatable {
  final int id;
  final String name;
  final DateTime date;
  final int? buyerId;
  final int? routePointId;
  final int? visitSkipReasonId;

  const ApiVisit({
    required this.id,
    required this.name,
    required this.date,
    this.buyerId,
    this.routePointId,
    this.visitSkipReasonId
  });

  factory ApiVisit.fromJson(dynamic json) {
    return ApiVisit(
      id: json['id'],
      name: json['name'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      routePointId: json['routePointId'],
      visitSkipReasonId: json['visitSkipReasonId']
    );
  }

  Visit toDatabaseEnt() {
    return Visit(
      id: id,
      name: name,
      date: date,
      buyerId: buyerId,
      routePointId: routePointId,
      visitSkipReasonId: visitSkipReasonId,
      visited: visitSkipReasonId == null
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    date,
    buyerId,
    routePointId,
    visitSkipReasonId
  ];
}
