part of 'entities.dart';

class ApiGoodsList extends Equatable {
  final int id;
  final String name;

  const ApiGoodsList({
    required this.id,
    required this.name
  });

  factory ApiGoodsList.fromJson(dynamic json) {
    return ApiGoodsList(
      id: json['id'],
      name: json['name']
    );
  }

  GoodsList toDatabaseEnt() {
    return GoodsList(
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
