part of 'address_page.dart';

class AddressViewModel extends PageViewModel<AddressState, AddressStateStatus> {
  AddressViewModel({required String? address, required double? latitude, required double? longitude}) :
    super(AddressState(address: address, latitude: latitude, longitude: longitude));

  @override
  AddressStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    if (state.latitude != null && state.longitude != null) return;

    changeCoordsToMyPosition();
  }

  void changeAddress(String address) {
    emit(state.copyWith(
      status: AddressStateStatus.addressChanged,
      address: address
    ));
  }

  void changeCoords(double latitude, double longitude) {
    emit(state.copyWith(
      status: AddressStateStatus.coordsChanged,
      latitude: latitude,
      longitude: longitude
    ));
  }

  Future<void> changeCoordsToMyPosition() async {
    final position = await Geolocator.getCurrentPosition();
    changeCoords(position.latitude, position.longitude);
  }
}
