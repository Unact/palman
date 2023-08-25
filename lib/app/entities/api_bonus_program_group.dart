part of 'entities.dart';

class ApiBonusProgramGroup extends Equatable {
  final int id;
  final String name;

  const ApiBonusProgramGroup({
    required this.id,
    required this.name
  });

  factory ApiBonusProgramGroup.fromJson(dynamic json) {
    return ApiBonusProgramGroup(
      id: json['id'],
      name: json['name']
    );
  }

  BonusProgramGroup toDatabaseEnt() {
    return BonusProgramGroup(
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
