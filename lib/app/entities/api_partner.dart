part of 'entities.dart';

class ApiPartner extends Equatable {
  final int id;
  final String name;
  final bool factpayment;

  const ApiPartner({
    required this.id,
    required this.name,
    required this.factpayment
  });

  factory ApiPartner.fromJson(dynamic json) {
    return ApiPartner(
      id: json['id'],
      name: json['name'],
      factpayment: json['factPayment']
    );
  }

  Partner toDatabaseEnt() {
    return Partner(
      id: id,
      name: name,
      factpayment: factpayment
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    factpayment
  ];
}
