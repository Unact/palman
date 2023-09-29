part of 'points_page.dart';

class PointsViewModel extends PageViewModel<PointsState, PointsStateStatus> {
  final AppRepository appRepository;
  final PointsRepository pointsRepository;
  StreamSubscription<List<PointEx>>? pointExListSubscription;

  PointsViewModel(this.appRepository, this.pointsRepository) :
    super(PointsState(selectedReason: PointsState.kReasonFilter.first));

  @override
  PointsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    pointExListSubscription = pointsRepository.watchPointExList().listen((event) {
      emit(state.copyWith(status: PointsStateStatus.dataLoaded, pointExList: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await pointExListSubscription?.cancel();
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
}
