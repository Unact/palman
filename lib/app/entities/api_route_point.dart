part of 'entities.dart';

class ApiRoutePoint extends Equatable {
  final int id;
  final DateTime date;
  final int buyerId;
  final bool? visited;
  final String? purposeDescription;

  const ApiRoutePoint({
    required this.id,
    required this.date,
    required this.buyerId,
    required this.purposeDescription,
    this.visited
  });

  factory ApiRoutePoint.fromJson(dynamic json) {
    return ApiRoutePoint(
      id: json['id'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      purposeDescription: json['purposeDescription'],
      visited: json['visited']
    );
  }

  RoutePoint toDatabaseEnt() {
    return RoutePoint(
      id: id,
      date: date,
      buyerId: buyerId,
      purposeDescription: purposeDescription,
      visited: visited
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    buyerId,
    purposeDescription,
    visited
  ];
}
