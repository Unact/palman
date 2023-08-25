part of 'points_page.dart';

class PointsViewModel extends PageViewModel<PointsState, PointsStateStatus> {
  final AppRepository appRepository;
  final PointsRepository pointsRepository;

  PointsViewModel(this.appRepository, this.pointsRepository) :
    super(PointsState(selectedReason: PointsState.kReasonFilter.first), [appRepository, pointsRepository]);

  @override
  PointsStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final pointExList = await pointsRepository.getPointExList();

    emit(state.copyWith(
      status: PointsStateStatus.dataLoaded,
      pointExList: pointExList
    ));
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
    for (var pointImage in pointEx.images) {
      await pointsRepository.deletePointImage(pointImage);
    }

    await pointsRepository.deletePoint(pointEx.point);
  }
}
