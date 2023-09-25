part of 'point_page.dart';

enum PointStateStatus {
  initial,
  dataLoaded,
  pointUpdated,
  cameraError,
  cameraOpened,
  saveInProgress,
  saveFailure,
  saveSuccess
}

class PointState {
  PointState({
    this.status = PointStateStatus.initial,
    required this.pointEx,
    this.pointFormats = const [],
    this.message = '',
    this.appInfo
  });

  final PointStateStatus status;
  final PointEx pointEx;
  final List<PointFormat> pointFormats;
  final String message;
  final AppInfoResult? appInfo;

  bool get showLocalImage => appInfo?.showLocalImage ?? true;

  bool get needSync => pointEx.point.needSync || pointEx.images.any((e) => e.needSync);

  PointState copyWith({
    PointStateStatus? status,
    PointEx? pointEx,
    List<PointFormat>? pointFormats,
    String? message,
    AppInfoResult? appInfo
  }) {
    return PointState(
      status: status ?? this.status,
      pointEx: pointEx ?? this.pointEx,
      pointFormats: pointFormats ?? this.pointFormats,
      message: message ?? this.message,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
