part of 'shipment_page.dart';

class ShipmentViewModel extends PageViewModel<ShipmentState, ShipmentStateStatus> {
  final ShipmentsRepository shipmentsRepository;

  ShipmentViewModel(this.shipmentsRepository, {required ShipmentExResult shipmentEx}) :
    super(ShipmentState(shipmentEx: shipmentEx), [shipmentsRepository]);

  @override
  ShipmentStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final linesExList = await shipmentsRepository.getShipmentLineExList(state.shipmentEx.shipment.id);

    emit(state.copyWith(
      status: ShipmentStateStatus.dataLoaded,
      linesExList: linesExList
    ));
  }
}
