part of 'entities.dart';

class ApiRoutePoint extends Equatable {
  final int id;
  final String name;
  final DateTime date;
  final int? buyerId;

  const ApiRoutePoint({
    required this.id,
    required this.name,
    required this.date,
    this.buyerId
  });

  factory ApiRoutePoint.fromJson(dynamic json) {
    return ApiRoutePoint(
      id: json['id'],
      name: json['name'],
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId']
    );
  }

  RoutePoint toDatabaseEnt() {
    return RoutePoint(
      id: id,
      name: name,
      date: date,
      buyerId: buyerId
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    date,
    buyerId
  ];
}
