part of 'entities.dart';

class ApiGoodsFilter extends Equatable {
  final int id;
  final String name;
  final String value;

  const ApiGoodsFilter({
    required this.id,
    required this.name,
    required this.value
  });

  factory ApiGoodsFilter.fromJson(dynamic json) {
    return ApiGoodsFilter(
      id: json['id'],
      name: json['name'],
      value: json['value']
    );
  }

  GoodsFilter toDatabaseEnt() {
    return GoodsFilter(
      id: id,
      name: name,
      value: value
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    value
  ];
}
