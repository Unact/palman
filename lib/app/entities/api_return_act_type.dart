part of 'entities.dart';

class ApiReturnActType extends Equatable {
  final int id;
  final String name;

  const ApiReturnActType({
    required this.id,
    required this.name,
  });

  factory ApiReturnActType.fromJson(dynamic json) {
    return ApiReturnActType(
      id: json['id'],
      name: json['name']
    );
  }

  ReturnActType toDatabaseEnt() {
    return ReturnActType(
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
