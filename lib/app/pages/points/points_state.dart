part of 'points_page.dart';

enum PointsStateStatus {
  initial,
  dataLoaded,
  selectedReasonChanged,
  listViewChanged,
  pointAdded,
  pointDeleted,
  loadInProgress,
  loadConfirmation,
  loadDeclined,
  loadFailure,
  loadSuccess,
  saveInProgress,
  saveSuccess,
  saveFailure,
}

class PointsState {
  static const List<(String code, String value)> kReasonFilter = [
    (Strings.pointReasonActive, 'Актив'),
    (Strings.pointReasonArchive, 'Архив'),
    (Strings.pointReasonZone, 'На территории')
  ];

  PointsState({
    this.status = PointsStateStatus.initial,
    this.pointExList = const [],
    required this.selectedReason,
    this.newPoint,
    this.listView = true,
    this.appInfo,
    this.isLoading = false
  });

  final PointsStateStatus status;
  final bool isLoading;
  final (String code, String value) selectedReason;
  final List<PointEx> pointExList;
  final PointEx? newPoint;
  final bool listView;
  final AppInfoResult? appInfo;

  int get pendingChanges => appInfo == null ? 0 : appInfo!.pointsToSync;

  List<PointEx> get filteredPointExList => pointExList
    .where((e) => !e.point.isDeleted)
    .where((e) => e.point.reason == selectedReason.$1).toList();

  PointsState copyWith({
    PointsStateStatus? status,
    List<PointEx>? pointExList,
    (String code, String value)? selectedReason,
    PointEx? newPoint,
    bool? listView,
    bool? isLoading,
    AppInfoResult? appInfo,
  }) {
    return PointsState(
      status: status ?? this.status,
      pointExList: pointExList ?? this.pointExList,
      selectedReason: selectedReason ?? this.selectedReason,
      newPoint: newPoint ?? this.newPoint,
      listView: listView ?? this.listView,
      isLoading: isLoading ?? this.isLoading,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
