part of 'point_images_page.dart';

enum PointImagesStateStatus {
  initial,
  dataLoaded,
  pointImageDeleted
}

class PointImagesState {
  PointImagesState({
    this.status = PointImagesStateStatus.initial,
    required this.pointEx,
    this.appInfo
  });

  final PointImagesStateStatus status;
  final PointEx pointEx;
  final AppInfoResult? appInfo;

  List<PointImage> get images => pointEx.images.where((e) => !e.isDeleted).toList();

  bool get showLocalImage => appInfo?.showLocalImage ?? true;

  PointImagesState copyWith({
    PointImagesStateStatus? status,
    PointEx? pointEx,
    int? curIdx,
    AppInfoResult? appInfo
  }) {
    return PointImagesState(
      status: status ?? this.status,
      pointEx: pointEx ?? this.pointEx,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
