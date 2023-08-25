part of 'entities.dart';

class ApiCategory extends Equatable {
  final int id;
  final String name;
  final int ord;
  final int shopDepartmentId;
  final int package;
  final int userPackage;

  const ApiCategory({
    required this.id,
    required this.name,
    required this.ord,
    required this.shopDepartmentId,
    required this.package,
    required this.userPackage
  });

  factory ApiCategory.fromJson(dynamic json) {
    return ApiCategory(
      id: json['id'],
      name: json['name'],
      ord: json['ord'],
      shopDepartmentId: json['shopDepartmentId'],
      package: json['package'],
      userPackage: json['userPackage']
    );
  }

  Category toDatabaseEnt() {
    return Category(
      id: id,
      name: name,
      ord: ord,
      shopDepartmentId: shopDepartmentId,
      package: package,
      userPackage: userPackage
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ord,
    shopDepartmentId,
    package,
    userPackage
  ];
}
