part of 'entities.dart';

class ApiPartnersReturnActType extends Equatable {
  final int returnActTypeId;
  final int partnerId;

  const ApiPartnersReturnActType({
    required this.returnActTypeId,
    required this.partnerId,
  });

  factory ApiPartnersReturnActType.fromJson(dynamic json) {
    return ApiPartnersReturnActType(
      returnActTypeId: json['returnActTypeId'],
      partnerId: json['partnerId'],
    );
  }

  PartnersReturnActType toDatabaseEnt() {
    return PartnersReturnActType(
      returnActTypeId: returnActTypeId,
      partnerId: partnerId
    );
  }

  @override
  List<Object> get props => [
    returnActTypeId,
    partnerId
  ];
}
