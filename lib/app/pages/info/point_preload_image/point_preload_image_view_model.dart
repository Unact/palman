part of 'point_preload_image_page.dart';

class PointPreloadImageViewModel extends PageViewModel<PointPreloadImageState, PointPreloadImageStateStatus> {
  final PointsRepository pointsRepository;

  PointPreloadImageViewModel(this.pointsRepository) : super(PointPreloadImageState());

  @override
  PointPreloadImageStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final pointImages = await pointsRepository.getPointImages();

    emit(state.copyWith(
      status: PointPreloadImageStateStatus.dataLoaded,
      pointImages: pointImages
    ));
  }

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();
    await preload();
  }

  void cancelPreload() {
    emit(state.copyWith(canceled: true));
  }

  Future<void> preload() async {
    emit(state.copyWith(status: PointPreloadImageStateStatus.inProgress));

    if (state.pointImages.isEmpty) {
      emit(state.copyWith(status: PointPreloadImageStateStatus.failure, message: 'Нет точек для загрузки фотографий'));
      return;
    }

    String? lastErrorMsg;

    for (var pointImage in state.pointImages) {
      try {
        if (state.canceled) {
          emit(state.copyWith(status: PointPreloadImageStateStatus.failure, message: 'Загрузка отменена'));
          return;
        }

        await pointsRepository.preloadPointImage(pointImage);
        emit(state.copyWith(
          status: PointPreloadImageStateStatus.imageLoaded,
          loadedPointImages: state.loadedPointImages + 1
        ));
      } on AppError catch(e) {
        lastErrorMsg = e.message;
      }
    }
    await pointsRepository.clearFiles(state.pointImages.map((e) => e.imagePath).toSet());

    emit(state.copyWith(
      status: PointPreloadImageStateStatus.success,
      message: lastErrorMsg == null ?
        'Фотографии успешно загружены' :
        'Не удалось загрузить все фотографии. $lastErrorMsg'
    ));
  }
}
