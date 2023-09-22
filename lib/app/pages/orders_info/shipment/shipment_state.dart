part of 'shipment_page.dart';

enum ShipmentStateStatus {
  initial,
  dataLoaded
}

class ShipmentState {
  ShipmentState({
    this.status = ShipmentStateStatus.initial,
    required this.shipmentEx,
    this.linesExList = const []
  });

  final ShipmentStateStatus status;

  final ShipmentExResult shipmentEx;
  final List<ShipmentLineEx> linesExList;

  ShipmentState copyWith({
    ShipmentStateStatus? status,
    ShipmentExResult? shipmentEx,
    List<ShipmentLineEx>? linesExList
  }) {
    return ShipmentState(
      status: status ?? this.status,
      shipmentEx: shipmentEx ?? this.shipmentEx,
      linesExList: linesExList ?? this.linesExList
    );
  }
}
