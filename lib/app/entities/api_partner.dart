part of 'entities.dart';

class ApiPartner extends Equatable {
  final int id;
  final String name;

  const ApiPartner({
    required this.id,
    required this.name
  });

  factory ApiPartner.fromJson(dynamic json) {
    return ApiPartner(
      id: json['id'],
      name: json['name']
    );
  }

  Partner toDatabaseEnt() {
    return Partner(
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
