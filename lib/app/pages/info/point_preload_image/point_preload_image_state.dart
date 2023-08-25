part of 'point_preload_image_page.dart';

enum PointPreloadImageStateStatus {
  initial,
  inProgress,
  dataLoaded,
  imageLoaded,
  success,
  failure,
  canceled
}

class PointPreloadImageState {
  PointPreloadImageState({
    this.status = PointPreloadImageStateStatus.initial,
    this.message = '',
    this.canceled = false,
    this.pointImages = const [],
    this.loadedPointImages = 0
  });

  final PointPreloadImageStateStatus status;
  final String message;
  final bool canceled;

  final List<PointImage> pointImages;
  final int loadedPointImages;

  PointPreloadImageState copyWith({
    PointPreloadImageStateStatus? status,
    String? message,
    bool? canceled,
    List<PointImage>? pointImages,
    int? loadedPointImages,
  }) {
    return PointPreloadImageState(
      status: status ?? this.status,
      message: message ?? this.message,
      canceled: canceled ?? this.canceled,
      pointImages: pointImages ?? this.pointImages,
      loadedPointImages: loadedPointImages ?? this.loadedPointImages
    );
  }
}
