part of 'entities.dart';

class ApiPointFormat extends Equatable {
  final int id;
  final String name;

  const ApiPointFormat({
    required this.id,
    required this.name
  });

  factory ApiPointFormat.fromJson(dynamic json) {
    return ApiPointFormat(
      id: json['id'],
      name: json['name']
    );
  }

  PointFormat toDatabaseEnt() {
    return PointFormat(
      id: id,
      name: name
    );
  }

  @override
  List<Object> get props => [
    id,
    name
  ];
}
