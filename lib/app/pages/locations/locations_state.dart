part of 'locations_page.dart';

enum LocationsStateStatus {
  initial,
  dataLoaded
}

class LocationsState {
  LocationsState({
    this.status = LocationsStateStatus.initial,
    this.locations = const [],
  });

  final LocationsStateStatus status;
  final List<Location> locations;

  LocationsState copyWith({
    LocationsStateStatus? status,
    List<Location>? locations
  }) {
    return LocationsState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
    );
  }
}
