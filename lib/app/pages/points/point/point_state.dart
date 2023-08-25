part of 'point_page.dart';

enum PointStateStatus {
  initial,
  dataLoaded,
  pointUpdated,
  cameraError,
  cameraOpened
}

class PointState {
  PointState({
    this.status = PointStateStatus.initial,
    required this.pointEx,
    this.pointFormats = const [],
    this.message = '',
    this.pref
  });

  final PointStateStatus status;
  final PointEx pointEx;
  final List<PointFormat> pointFormats;
  final String message;
  final Pref? pref;

  bool get showLocalImage => pref?.showLocalImage ?? true;

  PointState copyWith({
    PointStateStatus? status,
    PointEx? pointEx,
    List<PointFormat>? pointFormats,
    String? message,
    Pref? pref
  }) {
    return PointState(
      status: status ?? this.status,
      pointEx: pointEx ?? this.pointEx,
      pointFormats: pointFormats ?? this.pointFormats,
      message: message ?? this.message,
      pref: pref ?? this.pref
    );
  }
}
