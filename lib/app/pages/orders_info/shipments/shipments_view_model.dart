part of 'shipments_page.dart';

class ShipmentsViewModel extends PageViewModel<ShipmentsState, ShipmentsStateStatus> {
  final AppRepository appRepository;
  final ShipmentsRepository shipmentsRepository;
  final PartnersRepository partnersRepository;

  ShipmentsViewModel(this.appRepository, this.shipmentsRepository, this.partnersRepository) :
    super(ShipmentsState(), [appRepository, shipmentsRepository, partnersRepository]);

  @override
  ShipmentsStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final shipmentExList = await shipmentsRepository.getShipmentExList();
    final buyers = await partnersRepository.getBuyers();

    emit(state.copyWith(
      status: ShipmentsStateStatus.dataLoaded,
      buyers: buyers,
      shipmentExList: shipmentExList
    ));
  }

  void selectBuyer(Buyer? buyer) {
    emit(state.copyWith(
      status: ShipmentsStateStatus.buyerChanged,
      selectedBuyer: Optional.fromNullable(buyer)
    ));
  }
}
