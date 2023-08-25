part of 'entities.dart';

class ApiShopDepartment extends Equatable {
  final int id;
  final String name;
  final int ord;

  const ApiShopDepartment({
    required this.id,
    required this.name,
    required this.ord
  });

  factory ApiShopDepartment.fromJson(dynamic json) {
    return ApiShopDepartment(
      id: json['id'],
      name: json['name'],
      ord: json['ord']
    );
  }

  ShopDepartment toDatabaseEnt() {
    return ShopDepartment(
      id: id,
      name: name,
      ord: ord
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ord
  ];
}
