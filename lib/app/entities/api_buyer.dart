part of 'entities.dart';

class ApiBuyer extends Equatable {
  final int id;
  final String name;
  final String loadto;
  final int partnerId;
  final int siteId;
  final int? pointId;
  final List<bool> weekdays;

  const ApiBuyer({
    required this.id,
    required this.name,
    required this.loadto,
    required this.partnerId,
    required this.siteId,
    required this.pointId,
    required this.weekdays,
  });

  factory ApiBuyer.fromJson(dynamic json) {
    return ApiBuyer(
      id: json['id'],
      name: json['name'],
      loadto: json['loadto'],
      partnerId: json['partnerId'],
      siteId: json['siteId'],
      pointId: json['pointId'],
      weekdays: (json['weekdays'] as List).cast<bool>()
    );
  }

  Buyer toDatabaseEnt() {
    return Buyer(
      id: id,
      name: name,
      loadto: loadto,
      partnerId: partnerId,
      siteId: siteId,
      pointId: pointId,
      weekdays: weekdays
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    loadto,
    partnerId,
    siteId,
    pointId,
    weekdays
  ];
}
