part of 'entities.dart';

class ApiPricelist extends Equatable {
  final int id;
  final String name;
  final bool permit;

  const ApiPricelist({
    required this.id,
    required this.name,
    required this.permit
  });

  factory ApiPricelist.fromJson(dynamic json) {
    return ApiPricelist(
      id: json['id'],
      name: json['name'],
      permit: json['permit']
    );
  }

  Pricelist toDatabaseEnt() {
    return Pricelist(
      id: id,
      name: name,
      permit: permit
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    permit
  ];
}
