part of 'entities.dart';

class ApiBuyersSet extends Equatable {
  final int id;
  final String name;

  const ApiBuyersSet({
    required this.id,
    required this.name
  });

  factory ApiBuyersSet.fromJson(dynamic json) {
    return ApiBuyersSet(
      id: json['id'],
      name: json['name']
    );
  }

  BuyersSet toDatabaseEnt() {
    return BuyersSet(
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
