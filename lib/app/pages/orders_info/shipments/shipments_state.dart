part of 'shipments_page.dart';

enum ShipmentsStateStatus {
  initial,
  dataLoaded,
  buyerChanged
}

class ShipmentsState {
  ShipmentsState({
    this.status = ShipmentsStateStatus.initial,
    this.buyers = const [],
    this.shipmentExList = const [],
    this.selectedBuyer,
  });

  final ShipmentsStateStatus status;
  final List<Buyer> buyers;
  final List<ShipmentExResult> shipmentExList;
  final Buyer? selectedBuyer;

  List<ShipmentExResult> get filteredShipmentExList => shipmentExList
    .where((e) => selectedBuyer == null || e.buyer == selectedBuyer).toList();

  ShipmentsState copyWith({
    ShipmentsStateStatus? status,
    List<Buyer>? buyers,
    List<ShipmentExResult>? shipmentExList,
    Optional<Buyer>? selectedBuyer,
  }) {
    return ShipmentsState(
      status: status ?? this.status,
      buyers: buyers ?? this.buyers,
      shipmentExList: shipmentExList ?? this.shipmentExList,
      selectedBuyer: selectedBuyer != null ? selectedBuyer.orNull : this.selectedBuyer,
    );
  }
}
