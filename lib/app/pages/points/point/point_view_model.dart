part of 'point_page.dart';

class PointViewModel extends PageViewModel<PointState, PointStateStatus> {
  final AppRepository appRepository;
  final PointsRepository pointsRepository;
  StreamSubscription<List<PointEx>>? pointExListSubscription;
  StreamSubscription<List<PointFormat>>? pointFormatsSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  PointViewModel(this.appRepository, this.pointsRepository, { required PointEx pointEx }) :
    super(PointState(pointEx: pointEx));

  @override
  PointStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: PointStateStatus.dataLoaded, appInfo: event));
    });
    pointExListSubscription = pointsRepository.watchPointExList().listen((event) {
      emit(state.copyWith(
        status: PointStateStatus.dataLoaded,
        pointEx: event.firstWhereOrNull((e) => e.point.id == state.pointEx.point.id)
      ));
    });
    pointFormatsSubscription = pointsRepository.watchPointFormats().listen((event) {
      emit(state.copyWith(status: PointStateStatus.dataLoaded, pointFormats: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await pointExListSubscription?.cancel();
    await pointFormatsSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> tryTakePicture() async {
    if (!await Permissions.hasCameraPermissions()) {
      emit(state.copyWith(
        status: PointStateStatus.cameraError,
        message: Strings.cameraPermissionError
      ));
      return;
    }

    if (!await Permissions.hasLocationPermissions()) {
      emit(state.copyWith(
        status: PointStateStatus.cameraError,
        message: Strings.locationPermissionError
      ));
      return;
    }

    emit(state.copyWith(status: PointStateStatus.cameraOpened));
  }

  Future<void> addPointImage(XFile file) async {
    final position = await Geolocator.getCurrentPosition();

    await pointsRepository.addPointImage(
      state.pointEx.point,
      file: file,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp ?? DateTime.now()
    );
    _notifyPointUpdated();
  }

  Future<void> updateAddress(String? address, double latitude, double longitude) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      address: Optional.fromNullable(address),
      latitude: Optional.of(latitude),
      longitude: Optional.of(longitude)
    );
    _notifyPointUpdated();
  }

  Future<void> updatePointFormat(int pointFormat) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      pointFormat: Optional.of(pointFormat)
    );
    _notifyPointUpdated();
  }

  Future<void> updateName(String name) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      name: Optional.of(name)
    );
    _notifyPointUpdated();
  }

  Future<void> updateNumberOfCdesk(String numberOfCdesk) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      numberOfCdesks: Optional.fromNullable(int.tryParse(numberOfCdesk))
    );
    _notifyPointUpdated();
  }

  Future<void> updateEmailOnlineCheck(String emailOnlineCheck) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      emailOnlineCheck: Optional.of(emailOnlineCheck)
    );
    _notifyPointUpdated();
  }

  Future<void> updateEmail(String email) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      email: Optional.of(email)
    );
    _notifyPointUpdated();
  }

  Future<void> updateInn(String inn) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      inn: Optional.of(inn)
    );
    _notifyPointUpdated();
  }

  Future<void> updateMaxdebt(String maxdebt) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      maxdebt: Optional.fromNullable(int.tryParse(maxdebt))
    );
    _notifyPointUpdated();
  }

  Future<void> updateNds10(String nds10) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      nds10: Optional.fromNullable(int.tryParse(nds10))
    );
    _notifyPointUpdated();
  }

  Future<void> updateNds20(String nds20) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      nds20: Optional.fromNullable(int.tryParse(nds20))
    );
    _notifyPointUpdated();
  }

  Future<void> updatePlong(String plong) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      plong: Optional.fromNullable(int.tryParse(plong))
    );
    _notifyPointUpdated();
  }

  Future<void> updatePhoneOnlineCheck(String phoneOnlineCheck) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      phoneOnlineCheck: Optional.of(phoneOnlineCheck)
    );
    _notifyPointUpdated();
  }

  Future<void> updateJur(String jur) async {
    await pointsRepository.updatePoint(
      state.pointEx.point,
      inn: Optional.of(jur)
    );
    _notifyPointUpdated();
  }

  Future<void> save() async {
    emit(state.copyWith(status: PointStateStatus.saveInProgress));

    try {
      await pointsRepository.syncPoints([state.pointEx.point], state.pointEx.images.toList());

      emit(state.copyWith(status: PointStateStatus.saveSuccess, message: Strings.changesSaved));
    } on AppError catch(e) {
      emit(state.copyWith(status: PointStateStatus.saveFailure, message: e.message));
    }
  }

  void _notifyPointUpdated() {
    emit(state.copyWith(status: PointStateStatus.pointUpdated));
  }
}
