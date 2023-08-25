part of 'entities.dart';

class ApiBuyersSet extends Equatable {
  final int id;
  final String name;
  final bool isForAll;

  const ApiBuyersSet({
    required this.id,
    required this.name,
    required this.isForAll
  });

  factory ApiBuyersSet.fromJson(dynamic json) {
    return ApiBuyersSet(
      id: json['id'],
      name: json['name'],
      isForAll: json['isForAll']
    );
  }

  BuyersSet toDatabaseEnt() {
    return BuyersSet(
      id: id,
      name: name,
      isForAll: isForAll
    );
  }

  @override
  List<Object> get props => [
    id,
    name,
    isForAll
  ];
}
