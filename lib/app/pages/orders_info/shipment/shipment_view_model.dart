part of 'shipment_page.dart';

class ShipmentViewModel extends PageViewModel<ShipmentState, ShipmentStateStatus> {
  final ShipmentsRepository shipmentsRepository;
  StreamSubscription<List<ShipmentLineEx>>? shipmentLineExListSubscription;

  ShipmentViewModel(this.shipmentsRepository, {required ShipmentExResult shipmentEx}) :
    super(ShipmentState(shipmentEx: shipmentEx));

  @override
  ShipmentStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    shipmentLineExListSubscription = shipmentsRepository.watchShipmentLineExList(state.shipmentEx.shipment.id).listen(
      (event) {
        emit(state.copyWith(status: ShipmentStateStatus.dataLoaded, linesExList: event));
      }
    );
  }

  @override
  Future<void> close() async {
    await super.close();

    await shipmentLineExListSubscription?.cancel();
  }
}
