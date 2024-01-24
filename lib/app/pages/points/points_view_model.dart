part of 'points_page.dart';

class PointsViewModel extends PageViewModel<PointsState, PointsStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PointsRepository pointsRepository;
  final UsersRepository usersRepository;
  StreamSubscription<List<VisitSkipReason>>? visitSkipReasonsSubscription;
  StreamSubscription<List<Workdate>>? workdatesSubscription;
  StreamSubscription<List<PointEx>>? pointExListSubscription;
  StreamSubscription<List<RoutePointEx>>? routePointListSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  PointsViewModel(this.appRepository, this.ordersRepository, this.pointsRepository, this.usersRepository) :
    super(PointsState(selectedReason: PointsState.kReasonFilter.first));

  @override
  PointsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    visitSkipReasonsSubscription = appRepository.watchVisitSkipReasons().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, visitSkipReasons: event));
    });
    workdatesSubscription = appRepository.watchWorkdates().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, workdates: event));
    });
    routePointListSubscription = pointsRepository.watchRoutePointExList().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, routePointExList: event));
    });
    pointExListSubscription = pointsRepository.watchPointExList().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, pointExList: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await visitSkipReasonsSubscription?.cancel();
    await workdatesSubscription?.cancel();
    await routePointListSubscription?.cancel();
    await pointExListSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  void changeSelectedReason((String code, String value) selectedReason) {
    emit(state.copyWith(
      status: PointsStateStatus.selectedReasonChanged,
      selectedReason: selectedReason
    ));
  }

  void updateListView(bool listView) {
    emit(state.copyWith(
      status: PointsStateStatus.listViewChanged,
      listView: listView
    ));
  }

  Future<void> addNewOrder(RoutePointEx routePointEx) async {
    final workdate = state.workdates.where((el) => el.date.isAfter(routePointEx.routePoint.date)).firstOrNull;
    final newOrder = await ordersRepository.addOrder(
      date: workdate?.date,
      buyerId: routePointEx.routePoint.buyerId
    );

    emit(state.copyWith(
      status: PointsStateStatus.orderAdded,
      newOrder: newOrder
    ));
  }

  Future<void> addNewPoint() async {
    final newPoint = await pointsRepository.addPoint();
    emit(state.copyWith(
      status: PointsStateStatus.pointAdded,
      newPoint: newPoint
    ));
  }

  Future<void> deletePoint(PointEx pointEx) async {
    await pointsRepository.deletePoint(pointEx.point);
    emit(state.copyWith(
      status: PointsStateStatus.pointDeleted,
      pointExList: state.pointExList.where((e) => e != pointEx).toList()
    ));
  }

  Future<void> syncChanges() async {
    final futures = [
      pointsRepository.syncChanges
    ];

    await usersRepository.refresh();
    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> getData() async {
    if (state.isLoading) return;

    final futures = [
      pointsRepository.loadPoints
    ];

    try {
      emit(state.copyWith(isLoading: true));
      await usersRepository.refresh();
      await Future.wait(futures.map((e) => e.call()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> visit(RoutePointEx routePointEx, [VisitSkipReason? visitSkipReason]) async {
    emit(state.copyWith(status: PointsStateStatus.visitInProgress));

    final position = await Geolocator.getCurrentPosition();

    try {
      await pointsRepository.visit(
        routePoint: routePointEx.routePoint,
        visitSkipReason: visitSkipReason,
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        heading: position.heading,
        speed: position.speed,
        timestamp: position.timestamp ?? DateTime.now()
      );

      emit(state.copyWith(status: PointsStateStatus.visitSuccess, message: 'Отметка сохранена'));
    } on AppError catch(e) {
      emit(state.copyWith(status: PointsStateStatus.visitFailure, message: e.message));
    }
  }
}
