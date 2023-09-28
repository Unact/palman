part of 'points_page.dart';

enum PointsStateStatus {
  initial,
  dataLoaded,
  selectedReasonChanged,
  listViewChanged,
  pointAdded,
  pointDeleted
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
    this.listView = true
  });

  final PointsStateStatus status;
  final (String code, String value) selectedReason;
  final List<PointEx> pointExList;
  final PointEx? newPoint;
  final bool listView;

  List<PointEx> get filteredPointExList => pointExList.where((e) => e.point.reason == selectedReason.$1).toList();

  PointsState copyWith({
    PointsStateStatus? status,
    List<PointEx>? pointExList,
    (String code, String value)? selectedReason,
    PointEx? newPoint,
    bool? listView
  }) {
    return PointsState(
      status: status ?? this.status,
      pointExList: pointExList ?? this.pointExList,
      selectedReason: selectedReason ?? this.selectedReason,
      newPoint: newPoint ?? this.newPoint,
      listView: listView ?? this.listView
    );
  }
}
