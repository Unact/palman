part of 'info_page.dart';

class InfoViewModel extends PageViewModel<InfoState, InfoStateStatus> {
  final AppRepository appRepository;
  final DebtsRepository debtsRepository;
  final LocationsRepository locationsRepository;
  final OrdersRepository ordersRepository;
  final PointsRepository pointsRepository;
  final PricesRepository pricesRepository;
  final ReturnActsRepository returnActsRepository;
  final ShipmentsRepository shipmentsRepository;
  final UsersRepository usersRepository;
  final VisitsRepository visitsRepository;
  final battery = Battery();
  StreamSubscription<Position>? positionSubscription;
  StreamSubscription<User>? userSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;
  Timer? syncTimer;
  Timer? needReloadCheckTimer;

  InfoViewModel(
    this.appRepository,
    this.debtsRepository,
    this.locationsRepository,
    this.ordersRepository,
    this.pointsRepository,
    this.pricesRepository,
    this.returnActsRepository,
    this.shipmentsRepository,
    this.usersRepository,
    this.visitsRepository
  ) : super(InfoState());

  @override
  InfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: InfoStateStatus.dataLoaded, user: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: InfoStateStatus.dataLoaded, appInfo: event));
    });

    await _startLocationListen();
    await saveLocationChanges();
    await needReloadCheck();

    syncTimer = Timer.periodic(const Duration(minutes: 10), saveLocationChanges);
    needReloadCheckTimer = Timer.periodic(const Duration(minutes: 10), needReloadCheck);
  }

  Future<void> needReloadCheck([Timer? _]) async {
    final needReload = state.appInfo?.lastLoadTime == null ?
      false :
      DateTime.now().isAfter(state.appInfo!.lastLoadTime!.add(const Duration(days: 1)));

    if (!needReload) return;

    emit(state.copyWith(
      status: InfoStateStatus.reloadNeeded,
      message: 'Полное обновление данных производилось более 24 часов назад'
    ));
  }

  @override
  Future<void> close() async {
    await cancelPreloadGoodsImages();
    await cancelPreloadPointImages();
    await super.close();

    await positionSubscription?.cancel();
    await userSubscription?.cancel();
    await appInfoSubscription?.cancel();
    syncTimer?.cancel();
    needReloadCheckTimer?.cancel();
  }

  Future<void> _saveLocation(Position? position) async {
    if (position == null) return;

    await locationsRepository.saveLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      heading: position.heading,
      speed: position.speed,
      timestamp: position.timestamp,
      batteryLevel: await battery.batteryLevel,
      batteryState: (await battery.batteryState).name
    );
  }

  Future<void> _startLocationListen() async {
    await Geolocator.requestPermission();

    positionSubscription = Geolocator.getPositionStream(
      locationSettings: _getLocationSettings()
    ).listen(_saveLocation, onError: (error, stack) {
      emit(state.copyWith(
        status: InfoStateStatus.locationUpdateFailure,
        message: 'Не удалось обновить данные о местоположении. $error'
      ));
    });
  }

  Future<void> syncChanges() async {
    final futures = [
      pointsRepository.syncChanges,
      debtsRepository.syncChanges,
      ordersRepository.syncChanges,
      pricesRepository.syncChanges,
      shipmentsRepository.syncChanges,
      returnActsRepository.syncChanges
    ];

    await usersRepository.refresh();
    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> saveLocationChanges([Timer? _]) async {
    emit(state.copyWith(status: InfoStateStatus.syncInProgress));

    try {
      await locationsRepository.syncChanges();

      emit(state.copyWith(status: InfoStateStatus.syncSuccess, syncMessage: ''));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.syncFailure, syncMessage: e.message));
    }
  }

  Future<void> getData() async {
    Future<void> loadData(Future<void> Function() method) async {
      await method.call();
      emit(state.copyWith(loaded: state.loaded + 1));
    }
    if (state.isLoading) return;

    final futures = [
      usersRepository.loadUserData,
      appRepository.loadData,
      pointsRepository.loadPoints,
      debtsRepository.loadDebts,
      ordersRepository.loadBonusPrograms,
      ordersRepository.loadRemains,
      ordersRepository.loadOrders,
      pricesRepository.loadPrices,
      shipmentsRepository.loadShipments,
      returnActsRepository.loadReturnActs,
      visitsRepository.loadVisits
    ];

    try {
      emit(state.copyWith(isLoading: true, loaded: 0, toLoad: futures.length));
      await usersRepository.refresh();
      await Future.wait(futures.map((e) => loadData(e)));
      await appRepository.updatePref(lastLoadTime: Optional.of(DateTime.now()));
    } finally {
      emit(state.copyWith(isLoading: false, loaded: 0, toLoad: 0));
    }
  }

  LocationSettings _getLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 60,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 30),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationIcon: AndroidResource(name: 'launcher_icon', defType: 'mipmap'),
          notificationText: 'Приложение продолжит получать информацию о местоположении',
          notificationTitle: 'Работа на заднем фоне',
          enableWakeLock: true,
        )
      );
    } else {
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.other,
        distanceFilter: 60,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true
      );
    }
  }

  Future<void> cancelPreloadPointImages() async {
    emit(state.copyWith(
      status: InfoStateStatus.imageLoadCanceled,
      pointImagePreloadCanceled: true,
      message: 'Загрузка отменена',
      pointImages: [],
      loadedPointImages: 0
    ));
  }

  Future<void> preloadPointImages() async {
    final pointImages = await pointsRepository.getPointImages();

    if (pointImages.isEmpty) {
      emit(state.copyWith(status: InfoStateStatus.imageLoadFailure, message: 'Нет точек для загрузки фотографий'));
      return;
    }

    emit(state.copyWith(
      status: InfoStateStatus.imageLoadInProgress,
      pointImages: pointImages,
      pointImagePreloadCanceled: false,
      loadedPointImages: 0,
      message: 'Запущена загрузка фотографий точек'
    ));

    String? lastErrorMsg;

    for (var pointImage in pointImages) {
      try {
        if (state.pointImagePreloadCanceled) return;

        await pointsRepository.preloadPointImage(pointImage);
        emit(state.copyWith(
          status: InfoStateStatus.imageLoaded,
          loadedPointImages: state.loadedPointImages + 1
        ));
      } on AppError catch(e) {
        lastErrorMsg = '${e.message} Точка: ${pointImage.guid}';
      }
    }
    await pointsRepository.clearFiles(pointImages.map((e) => e.imageKey).toSet());

    emit(state.copyWith(
      status: InfoStateStatus.imageLoadSuccess,
      pointImagePreloadCanceled: true,
      pointImages: [],
      loadedPointImages: 0,
      message: lastErrorMsg == null ?
        'Фотографии успешно загружены' :
        'Не удалось загрузить все фотографии. $lastErrorMsg'
    ));
  }

  Future<void> cancelPreloadGoodsImages() async {
    emit(state.copyWith(
      status: InfoStateStatus.imageLoadCanceled,
      goodsImagePreloadCanceled: true,
      message: 'Загрузка отменена',
      goodsWithImage: [],
      loadedGoodsImages: 0
    ));
  }

  Future<void> preloadGoodsImages() async {
    final goodsWithImage = await ordersRepository.getOrderableGoodsWithImage();

    if (goodsWithImage.isEmpty) {
      emit(state.copyWith(status: InfoStateStatus.imageLoadFailure, message: 'Нет товаров для загрузки фотографий'));
      return;
    }

    emit(state.copyWith(
      status: InfoStateStatus.imageLoadInProgress,
      goodsWithImage: goodsWithImage,
      goodsImagePreloadCanceled: false,
      loadedGoodsImages: 0,
      message: 'Запущена загрузка фотографий товаров'
    ));

    String? lastErrorMsg;

    for (var goodsImage in goodsWithImage) {
      try {
        if (state.goodsImagePreloadCanceled) return;

        await ordersRepository.preloadGoodsImages(goodsImage);
        emit(state.copyWith(
          status: InfoStateStatus.imageLoaded,
          loadedGoodsImages: state.loadedGoodsImages + 1
        ));
      } on AppError catch(e) {
        lastErrorMsg = '${e.message} Товар: ${goodsImage.name}';
      }
    }
    await ordersRepository.clearFiles(goodsWithImage.map((e) => e.imageKey).toSet());

    emit(state.copyWith(
      status: InfoStateStatus.imageLoadSuccess,
      goodsImagePreloadCanceled: true,
      goodsWithImage: [],
      loadedGoodsImages: 0,
      message: lastErrorMsg == null ?
        'Фотографии успешно загружены' :
        'Не удалось загрузить все фотографии. $lastErrorMsg'
    ));
  }

  Future<void> regenerateGuids() async {
    if (state.isLoading) {
      emit(state.copyWith(
        status: InfoStateStatus.guidRegenerateFailure,
        message: 'Нельзя менять идентификаторы! Идет синхронизация данных'
      ));
      return;
    }

    final futures = [
      shipmentsRepository.regenerateGuid,
      pricesRepository.regenerateGuid,
      pointsRepository.regenerateGuid,
      ordersRepository.regenerateGuid,
      debtsRepository.regenerateGuid,
      returnActsRepository.regenerateGuid
    ];

    await Future.wait(futures.map((e) => e.call()));

    emit(state.copyWith(
      status: InfoStateStatus.guidRegenerateSuccess,
      message: 'Идентификаторы пересозданы'
    ));
  }

  Future<void> reverseDay() async {
    emit(state.copyWith(status: InfoStateStatus.reverseInProgress));

    try {
      await usersRepository.reverseDay();
      emit(state.copyWith(
        status: InfoStateStatus.reverseSuccess,
        message: 'День успешно ${state.closed ? 'открыт' : 'закрыт'}'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: InfoStateStatus.reverseFailure, message: e.message));
    }
  }
}
