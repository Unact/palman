part of 'locations_page.dart';

class LocationsViewModel extends PageViewModel<LocationsState, LocationsStateStatus> {
  final LocationsRepository locationsRepository;

  StreamSubscription<List<Location>>? locationsSubscription;

  LocationsViewModel(this.locationsRepository) : super(LocationsState());

  @override
  LocationsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    locationsSubscription = locationsRepository.watchLocations().listen((event) {
      emit(state.copyWith(status: LocationsStateStatus.dataLoaded, locations: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await locationsSubscription?.cancel();
  }
}
