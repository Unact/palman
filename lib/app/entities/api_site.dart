part of 'entities.dart';

class ApiSite extends Equatable {
  final int id;
  final String name;

  const ApiSite({
    required this.id,
    required this.name
  });

  factory ApiSite.fromJson(dynamic json) {
    return ApiSite(
      id: json['id'],
      name: json['name']
    );
  }

  Site toDatabaseEnt() {
    return Site(
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
