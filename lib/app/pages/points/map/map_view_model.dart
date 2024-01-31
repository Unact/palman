part of 'map_page.dart';

class MapViewModel extends PageViewModel<MapState, MapStateStatus> {
  final PointsRepository pointsRepository;

  StreamSubscription<List<PointBuyerRoutePoint>>? pointBuyerRoutePointListSubscription;

  MapViewModel(this.pointsRepository) : super(MapState());

  @override
  MapStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    pointBuyerRoutePointListSubscription = pointsRepository.watchPointBuyerRoutePoints().listen((event) {
      emit(state.copyWith(status: MapStateStatus.dataLoaded, pointBuyerRoutePointList: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await pointBuyerRoutePointListSubscription?.cancel();
  }
}
