part of 'points_page.dart';

class PointsViewModel extends PageViewModel<PointsState, PointsStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PartnersRepository partnersRepository;
  final PointsRepository pointsRepository;
  final UsersRepository usersRepository;
  final VisitsRepository visitsRepository;
  StreamSubscription<List<VisitSkipReason>>? visitSkipReasonsSubscription;
  StreamSubscription<List<Workdate>>? workdatesSubscription;
  StreamSubscription<List<PointEx>>? pointExListSubscription;
  StreamSubscription<List<BuyerEx>>? buyersSubscription;
  StreamSubscription<List<RoutePointEx>>? routePointListSubscription;
  StreamSubscription<List<VisitEx>>? visitListSubcription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;
  StreamSubscription<User>? userSubscription;

  PointsViewModel(
    this.appRepository,
    this.ordersRepository,
    this.partnersRepository,
    this.pointsRepository,
    this.usersRepository,
    this.visitsRepository
  ) : super(PointsState(selectedReason: PointsState.kReasonFilter.first));

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
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, buyerExList: event));
    });
    routePointListSubscription = visitsRepository.watchRoutePointExList().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, routePointExList: event));
    });
    visitListSubcription = visitsRepository.watchVisitExList().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, visitExList: event));
    });
    pointExListSubscription = pointsRepository.watchPointExList().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, pointExList: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, appInfo: event));
    });
    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, user: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await visitSkipReasonsSubscription?.cancel();
    await workdatesSubscription?.cancel();
    await buyersSubscription?.cancel();
    await routePointListSubscription?.cancel();
    await visitListSubcription?.cancel();
    await pointExListSubscription?.cancel();
    await appInfoSubscription?.cancel();
    await userSubscription?.cancel();
  }

  void changeSelectedReason((String code, String value) selectedReason) {
    emit(state.copyWith(
      status: PointsStateStatus.selectedReasonChanged,
      selectedReason: selectedReason
    ));
  }

  Future<void> addNewOrder(RoutePointEx routePointEx) async {
    final workdate = state.workdates
      .where((el) =>
        el.date.isAfter(routePointEx.routePoint.date) &&
        routePointEx.buyerEx.buyer.weekdays[el.date.weekday % 7]
      ).firstOrNull;
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

    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> getData() async {
    if (state.isLoading) return;

    final futures = [
      pointsRepository.loadPoints,
      visitsRepository.loadVisits
    ];

    try {
      emit(state.copyWith(isLoading: true));
      await Future.wait(futures.map((e) => e.call()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> visit({RoutePoint? routePoint, required Buyer buyer, VisitSkipReason? visitSkipReason}) async {
    final result = Platform.isIOS ?
      await Geolocator.requestTemporaryFullAccuracy(purposeKey: 'route point') :
      LocationAccuracyStatus.precise;

    if (result != LocationAccuracyStatus.precise) {
      emit(state.copyWith(
        status: PointsStateStatus.visitFailure,
        message: 'Не выдано разрешение на получение местоположения'
      ));
      return;
    }

    emit(state.copyWith(status: PointsStateStatus.visitInProgress));

    final position = await l.Location().getLocation();

    try {
      final visitEx = await visitsRepository.visit(
        buyer: buyer,
        routePoint: routePoint,
        visitSkipReason: visitSkipReason,
        latitude: position.latitude ?? 0,
        longitude: position.longitude ?? 0,
        accuracy: position.accuracy ?? 0,
        altitude: position.altitude ?? 0,
        heading: position.heading ?? 0,
        speed: position.speed ?? 0,
        timestamp: DateTime.fromMillisecondsSinceEpoch(position.time?.toInt() ?? 0)
      );

      emit(state.copyWith(
        status: PointsStateStatus.visitSuccess,
        message: 'Отметка сохранена',
        newVisit: visitEx
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: PointsStateStatus.visitFailure, message: e.message));
    }
  }
}
