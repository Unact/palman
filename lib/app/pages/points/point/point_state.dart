part of 'point_page.dart';

enum PointStateStatus {
  initial,
  dataLoaded,
  pointUpdated,
  pointRemoved,
  cameraError,
  cameraOpened,
  openLinkError
}

class PointState {
  PointState({
    this.status = PointStateStatus.initial,
    required this.pointEx,
    this.pointFormats = const [],
    this.ntDeptTypes = const [],
    this.message = '',
    this.appInfo
  });

  final PointStateStatus status;
  final PointEx pointEx;
  final List<PointFormat> pointFormats;
  final List<NtDeptType> ntDeptTypes;
  final String message;
  final AppInfoResult? appInfo;

  List<PointImage> get images => pointEx.images.where((e) => !e.isDeleted).toList();

  bool get showLocalImage => appInfo?.showLocalImage ?? true;

  bool get needSync => pointEx.point.needSync || pointEx.images.any((e) => e.needSync);

  PointState copyWith({
    PointStateStatus? status,
    PointEx? pointEx,
    List<PointFormat>? pointFormats,
    List<NtDeptType>? ntDeptTypes,
    String? message,
    AppInfoResult? appInfo
  }) {
    return PointState(
      status: status ?? this.status,
      pointEx: pointEx ?? this.pointEx,
      pointFormats: pointFormats ?? this.pointFormats,
      ntDeptTypes: ntDeptTypes ?? this.ntDeptTypes,
      message: message ?? this.message,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
