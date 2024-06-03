part of 'entities.dart';

class ApiNtDeptType extends Equatable {
  final int id;
  final String name;

  const ApiNtDeptType({
    required this.id,
    required this.name
  });

  factory ApiNtDeptType.fromJson(dynamic json) {
    return ApiNtDeptType(
      id: json['id'],
      name: json['name']
    );
  }

  NtDeptType toDatabaseEnt() {
    return NtDeptType(
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
