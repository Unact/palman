part of 'point_images_page.dart';

class PointImagesViewModel extends PageViewModel<PointImagesState, PointImagesStateStatus> {
  final AppRepository appRepository;
  final PointsRepository pointsRepository;
  StreamSubscription<List<PointEx>>? pointExListSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  PointImagesViewModel(this.appRepository, this.pointsRepository, { required PointEx pointEx }) :
    super(PointImagesState(pointEx: pointEx));

  @override
  PointImagesStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: PointImagesStateStatus.dataLoaded, appInfo: event));
    });
    pointExListSubscription = pointsRepository.watchPointExList().listen((event) {
      final pointEx = event.firstWhereOrNull((e) => e.point.guid == state.pointEx.point.guid);

      emit(state.copyWith(status: PointImagesStateStatus.dataLoaded, pointEx: pointEx));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await appInfoSubscription?.cancel();
    await pointExListSubscription?.cancel();
  }

  Future<void> deletePointImage(PointImage pointImage) async {
    await pointsRepository.deletePointImage(pointImage);
    emit(state.copyWith(
      status: PointImagesStateStatus.pointImageDeleted,
      pointEx: PointEx(state.pointEx.point, state.pointEx.images.where((e) => e != pointImage).toList())
    ));
  }
}
