part of 'points_page.dart';

enum PointsStateStatus {
  initial,
  dataLoaded,
  selectedReasonChanged,
  listViewChanged,
  pointAdded,
  pointDeleted,
  orderAdded,
  visitInProgress,
  visitSuccess,
  visitFailure
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
    this.appInfo,
    this.routePointExList = const [],
    this.newOrder,
    this.isLoading = false,
    this.workdates = const [],
    this.visitSkipReasons = const [],
    this.message = '',
    this.visitExList = const [],
    this.buyerExList = const []
  });

  final PointsStateStatus status;
  final bool isLoading;
  final (String code, String value) selectedReason;
  final List<PointEx> pointExList;
  final PointEx? newPoint;
  final List<RoutePointEx> routePointExList;
  final OrderExResult? newOrder;
  final AppInfoResult? appInfo;
  final List<Workdate> workdates;
  final List<VisitSkipReason> visitSkipReasons;
  final String message;
  final List<VisitEx> visitExList;
  final List<BuyerEx> buyerExList;

  int get pendingChanges => appInfo == null ? 0 : appInfo!.pointsToSync;

  List<PointEx> get filteredPointExList => pointExList
    .where((e) => !e.point.isDeleted)
    .where((e) => e.point.reason == selectedReason.$1).toList();

  PointsState copyWith({
    PointsStateStatus? status,
    List<PointEx>? pointExList,
    (String code, String value)? selectedReason,
    PointEx? newPoint,
    bool? isLoading,
    List<RoutePointEx>? routePointExList,
    OrderExResult? newOrder,
    AppInfoResult? appInfo,
    List<Workdate>? workdates,
    List<VisitSkipReason>? visitSkipReasons,
    String? message,
    List<VisitEx>? visitExList,
    List<BuyerEx>? buyerExList,
  }) {
    return PointsState(
      status: status ?? this.status,
      pointExList: pointExList ?? this.pointExList,
      selectedReason: selectedReason ?? this.selectedReason,
      newPoint: newPoint ?? this.newPoint,
      isLoading: isLoading ?? this.isLoading,
      routePointExList: routePointExList ?? this.routePointExList,
      newOrder: newOrder ?? this.newOrder,
      appInfo: appInfo ?? this.appInfo,
      workdates: workdates ?? this.workdates,
      visitSkipReasons: visitSkipReasons ?? this.visitSkipReasons,
      message: message ?? this.message,
      visitExList: visitExList ?? this.visitExList,
      buyerExList: buyerExList ?? this.buyerExList
    );
  }
}
