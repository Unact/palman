part of 'points_page.dart';

enum PointsStateStatus {
  initial,
  dataLoaded,
  selectedReasonChanged,
  listViewChanged,
  pointAdded,
  pointDeleted,
  orderAdded
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
    this.routePointExList = const [],
    this.newOrder,
    this.isLoading = false,
    this.workdates = const []
  });

  final PointsStateStatus status;
  final bool isLoading;
  final (String code, String value) selectedReason;
  final List<PointEx> pointExList;
  final PointEx? newPoint;
  final bool listView;
  final List<RoutePointEx> routePointExList;
  final OrderExResult? newOrder;
  final AppInfoResult? appInfo;
  final List<Workdate> workdates;

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
    List<RoutePointEx>? routePointExList,
    OrderExResult? newOrder,
    AppInfoResult? appInfo,
    List<Workdate>? workdates,
  }) {
    return PointsState(
      status: status ?? this.status,
      pointExList: pointExList ?? this.pointExList,
      selectedReason: selectedReason ?? this.selectedReason,
      newPoint: newPoint ?? this.newPoint,
      listView: listView ?? this.listView,
      isLoading: isLoading ?? this.isLoading,
      routePointExList: routePointExList ?? this.routePointExList,
      newOrder: newOrder ?? this.newOrder,
      appInfo: appInfo ?? this.appInfo,
      workdates: workdates ?? this.workdates,
    );
  }
}
