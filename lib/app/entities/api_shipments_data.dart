part of 'entities.dart';

class ApiShipmentsData extends Equatable {
  final List<ApiShipment> shipments;
  final List<ApiIncRequest> incRequests;

  const ApiShipmentsData({
    required this.shipments,
    required this.incRequests
  });

  factory ApiShipmentsData.fromJson(Map<String, dynamic> json) {
    List<ApiShipment> shipments = json['shipments'].map<ApiShipment>((e) => ApiShipment.fromJson(e)).toList();
    List<ApiIncRequest> incRequests = json['incRequests'].map<ApiIncRequest>((e) => ApiIncRequest.fromJson(e)).toList();

    return ApiShipmentsData(
      shipments: shipments,
      incRequests: incRequests
    );
  }

  @override
  List<Object> get props => [
    shipments,
    incRequests
  ];
}
