part of 'entities.dart';

class ApiCategory extends Equatable {
  final int id;
  final String name;
  final int ord;
  final int shopDepartmentId;

  const ApiCategory({
    required this.id,
    required this.name,
    required this.ord,
    required this.shopDepartmentId
  });

  factory ApiCategory.fromJson(dynamic json) {
    return ApiCategory(
      id: json['id'],
      name: json['name'],
      ord: json['ord'],
      shopDepartmentId: json['shopDepartmentId']
    );
  }

  Category toDatabaseEnt() {
    return Category(
      id: id,
      name: name,
      ord: ord,
      shopDepartmentId: shopDepartmentId
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ord,
    shopDepartmentId
  ];
}
