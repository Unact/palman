part of 'entities.dart';

class ApiVisitSkipReason extends Equatable {
  final int id;
  final String name;

  const ApiVisitSkipReason({
    required this.id,
    required this.name
  });

  factory ApiVisitSkipReason.fromJson(dynamic json) {
    return ApiVisitSkipReason(
      id: json['id'],
      name: json['name']
    );
  }

  VisitSkipReason toDatabaseEnt() {
    return VisitSkipReason(
      id: id,
      name: name
    );
  }

  @override
  List<Object?> get props => [
    id,
    name
  ];
}
