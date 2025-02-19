part of 'visit_page.dart';

class VisitViewModel extends PageViewModel<VisitState, VisitStateStatus> {
  final AppRepository appRepository;
  final VisitsRepository visitsRepository;
  StreamSubscription<List<GoodsListVisitExResult>>? goodsListVisitExListSubscription;
  StreamSubscription<List<VisitImage>>? visitImagesSubscription;
  StreamSubscription<List<VisitSoftware>>? visitSoftwaresSubscription;
  StreamSubscription<List<VisitPurpose>>? visitPurposesSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  VisitViewModel(this.appRepository, this.visitsRepository, { required VisitEx visitEx }) :
    super(VisitState(visitEx: visitEx, listGoods: {}));

  @override
  VisitStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: VisitStateStatus.dataLoaded, appInfo: event));
    });
    goodsListVisitExListSubscription = visitsRepository.watchGoodsListVisitExList(state.visitEx.visit.guid).
      listen((event) {
        emit(state.copyWith(status: VisitStateStatus.dataLoaded, goodsListVisitExList: event));
      });
    visitImagesSubscription = visitsRepository.watchVisitImages(state.visitEx.visit.guid).listen((event) {
      emit(state.copyWith(status: VisitStateStatus.dataLoaded, images: event));
    });
    visitSoftwaresSubscription = visitsRepository.watchVisitSoftwares(state.visitEx.visit.guid).listen((event) {
      emit(state.copyWith(status: VisitStateStatus.dataLoaded, softwares: event));
    });
    visitPurposesSubscription = visitsRepository.watchVisitPurposes(state.visitEx.visit.guid).listen((event) {
      emit(state.copyWith(status: VisitStateStatus.dataLoaded, purposes: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await goodsListVisitExListSubscription?.cancel();
    await visitImagesSubscription?.cancel();
    await visitSoftwaresSubscription?.cancel();
    await visitPurposesSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> tryTakePicture(bool takeSoftwarePhoto) async {
    if (!await Permissions.hasCameraPermissions()) {
      emit(state.copyWith(
        status: VisitStateStatus.cameraError,
        message: Strings.cameraPermissionError
      ));
      return;
    }

    emit(state.copyWith(status: VisitStateStatus.cameraOpened, takeSoftwarePhoto: takeSoftwarePhoto));
  }

  void addGoodsToList(GoodsList goodsList, int id) {
    emit(state.copyWith(
      status: VisitStateStatus.goodsAddedToList,
      listGoods: state.listGoods..update(goodsList, (value) => value..add(id), ifAbsent: () => [id])
    ));
  }

  void deleteGoodsFromList(GoodsList goodsList, int id) {
    emit(state.copyWith(
      status: VisitStateStatus.goodsAddedToList,
      listGoods: state.listGoods..update(goodsList, (value) => value..remove(id), ifAbsent: () => [])
    ));
  }

  Future<void> finishVisitList(GoodsList goodsList) async {
    emit(state.copyWith(status: VisitStateStatus.inProgress));

    try {
      await visitsRepository.finishVisitList(
        state.visitEx.visit,
        goodsListId: goodsList.id,
        goodsIds: state.listGoods[goodsList] ?? []
      );

      emit(state.copyWith(
        status: VisitStateStatus.success,
        message: 'Список сохранен'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: VisitStateStatus.failure, message: e.message));
    }
  }

  Future<void> completeVisitPurpose(VisitPurpose purpose, bool completed, String? info) async {
    emit(state.copyWith(status: VisitStateStatus.inProgress));

    try {
      await visitsRepository.completeVisitPurpose(purpose, completed: completed, info: info);

      emit(state.copyWith(status: VisitStateStatus.success, message: 'Цель отмечена'));
    } on AppError catch(e) {
      emit(state.copyWith(status: VisitStateStatus.failure, message: e.message));
    }
  }

  Future<void> addVisitImage(XFile file) async {
    emit(state.copyWith(status: VisitStateStatus.inProgress));

    final position = await l.Location().getLocation();

    try {
      await visitsRepository.addVisitImage(
        state.visitEx.visit,
        file: file,
        latitude: position.latitude ?? 0,
        longitude: position.longitude ?? 0,
        accuracy: position.accuracy ?? 0,
        timestamp: position.time != null ? DateTime.fromMillisecondsSinceEpoch(position.time!.toInt()) : DateTime.now()
      );

      emit(state.copyWith(
        status: VisitStateStatus.success,
        message: 'Фотография сохранена'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: VisitStateStatus.failure, message: e.message));
    }
  }

  Future<void> deleteVisitImage(VisitImage visitImage) async {
    emit(state.copyWith(status: VisitStateStatus.inProgress));

    try {
      await visitsRepository.deleteVisitImage(visitImage);
      emit(state.copyWith(
        status: VisitStateStatus.success,
        images: state.images.where((e) => e != visitImage).toList()
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: VisitStateStatus.failure, message: e.message));
    }
  }

  Future<void> addVisitSoftware(XFile file) async {
    emit(state.copyWith(status: VisitStateStatus.inProgress));

    final position = await l.Location().getLocation();

    try {
      await visitsRepository.addVisitSoftware(
        state.visitEx.visit,
        file: file,
        latitude: position.latitude ?? 0,
        longitude: position.longitude ?? 0,
        accuracy: position.accuracy ?? 0,
        timestamp: position.time != null ? DateTime.fromMillisecondsSinceEpoch(position.time!.toInt()) : DateTime.now()
      );

      emit(state.copyWith(
        status: VisitStateStatus.success,
        message: 'Фотография сохранена'
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: VisitStateStatus.failure, message: e.message));
    }
  }

  Future<void> deleteVisitSoftware(VisitSoftware visitSoftware) async {
    emit(state.copyWith(status: VisitStateStatus.inProgress));

    try {
      await visitsRepository.deleteVisitSoftware(visitSoftware);
      emit(state.copyWith(
        status: VisitStateStatus.success,
        softwares: state.softwares.where((e) => e != visitSoftware).toList()
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: VisitStateStatus.failure, message: e.message));
    }
  }
}
