part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final DebtsRepository debtsRepository;
  final LocationsRepository locationsRepository;
  final OrdersRepository ordersRepository;
  final PartnersRepository partnersRepository;
  final PointsRepository pointsRepository;
  final PricesRepository pricesRepository;
  final ShipmentsRepository shipmentsRepository;
  final UsersRepository usersRepository;
  late final StreamSubscription<Position>? positionSubscription;
  late final Timer syncTimer;

  InfoViewModel(
    this.appRepository,
    this.debtsRepository,
    this.locationsRepository,
    this.ordersRepository,
    this.partnersRepository,
    this.pointsRepository,
    this.pricesRepository,
    this.shipmentsRepository,
    this.usersRepository
  ) : super(
    InfoState(),
    [
      appRepository,
      debtsRepository,
      ordersRepository,
      pointsRepository,
      pricesRepository,
      shipmentsRepository,
    ]
  );

  @override
  InfoStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final newVersionAvailable = await appRepository.newVersionAvailable;
    final appInfo = await appRepository.getAppInfo();

    emit(state.copyWith(
      status: InfoStateStatus.dataLoaded,
      newVersionAvailable: newVersionAvailable,
      appInfo: appInfo
    ));
  }

  @override
  Future<void> initViewModel() async {
    await _unblockEntities();
    await _startLocationListen();
    await super.initViewModel();

    await saveChangesBackground();

    syncTimer = Timer(const Duration(minutes: 10), saveChangesBackground);
  }

  @override
  Future<void> close() async {
    await super.close();

    await positionSubscription?.cancel();
    syncTimer.cancel();
  }

  Future<void> _saveLocation(Position? position) async {
    if (position == null || position.timestamp == null) return;

    await locationsRepository.saveLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      heading: position.heading,
      speed: position.speed,
      timestamp: position.timestamp!
    );
  }

  Future<void> _startLocationListen() async {
    if (!await Permissions.hasLocationPermissions()) return;

    positionSubscription = Geolocator.getPositionStream(
      locationSettings: _getLocationSettings()
    ).listen(_saveLocation);
  }

  Future<void> _unblockEntities() async {
    final futures = [
      pointsRepository.blockPoints(false),
      debtsRepository.blockEncashments(false),
      ordersRepository.blockOrders(false),
      pricesRepository.blockPrices(false),
      shipmentsRepository.blockIncRequests(false)
    ];

    await Future.wait(futures);
  }

  Future<void> _syncChanges() async {
    final futures = [
      pointsRepository.syncChanges(),
      debtsRepository.syncChanges(),
      ordersRepository.syncChanges(),
      pricesRepository.syncChanges(),
      shipmentsRepository.syncChanges()
    ];

    await locationsRepository.syncChanges();
    await Future.wait(futures);
  }

  Future<void> saveChangesBackground() async {
    if (state.isBusy) return;

    emit(state.copyWith(status: InfoStateStatus.syncInProgress, isBusy: true));

    try {
      await _syncChanges();

      emit(state.copyWith(status: InfoStateStatus.syncSuccess, syncMessage: '', isBusy: false));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.syncFailure, syncMessage: e.message, isBusy: false));
    }
  }

  Future<void> saveChangesForeground() async {
    if (state.isBusy) return;

    emit(state.copyWith(status: InfoStateStatus.saveInProgress, syncMessage: '', isBusy: true));

    try {
      await _syncChanges();

      emit(state.copyWith(status: InfoStateStatus.saveSuccess, message: 'Изменения успешно сохранены', isBusy: false));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.saveFailure, message: e.message, isBusy: false));
    }
  }

  Future<void> getData() async {
    if (state.isBusy) return;

    emit(state.copyWith(status: InfoStateStatus.inProgress, syncMessage: '', isBusy: true));

    try {
      await usersRepository.loadUserData();

      final futures = [
        appRepository.loadData(),
        pointsRepository.loadPoints(),
        debtsRepository.loadDebts(),
        ordersRepository.loadBonusPrograms(),
        ordersRepository.loadRemains(),
        ordersRepository.loadOrders(),
        pricesRepository.loadPrices(),
        shipmentsRepository.loadShipments(),
      ];

      await Future.wait(futures);
      await appRepository.updatePref(lastSyncTime: Optional.of(DateTime.now()));

      emit(state.copyWith(status: InfoStateStatus.success, message: 'Данные успешно обновлены', isBusy: false));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.failure, message: e.message, isBusy: false));
    }
  }

  LocationSettings _getLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: 'Приложение продолжит получать информацию о местоположении',
          notificationTitle: 'Работа на заднем фоне',
          enableWakeLock: true,
        )
      );
    } else {
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.other,
        distanceFilter: 10,
        showBackgroundLocationIndicator: true,
      );
    }
  }
}
