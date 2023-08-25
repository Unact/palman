part of 'address_page.dart';

enum AddressStateStatus {
  initial,
  addressChanged,
  coordsChanged,
  permissionNotGranted
}

class AddressState {
  AddressState({
    this.status = AddressStateStatus.initial,
    required this.address,
    required this.latitude,
    required this.longitude
  });

  final AddressStateStatus status;
  final String? address;
  final double? latitude;
  final double? longitude;

  AddressState copyWith({
    AddressStateStatus? status,
    String? address,
    double? latitude,
    double? longitude
  }) {
    return AddressState(
      status: status ?? this.status,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
