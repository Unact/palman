part of 'map_page.dart';

enum MapStateStatus {
  initial,
  dataLoaded
}

class MapState {
  MapState({
    this.status = MapStateStatus.initial,
    this.pointBuyerRoutePointList = const [],
  });

  final MapStateStatus status;
  final List<PointBuyerRoutePoint> pointBuyerRoutePointList;

  MapState copyWith({
    MapStateStatus? status,
    List<PointBuyerRoutePoint>? pointBuyerRoutePointList
  }) {
    return MapState(
      status: status ?? this.status,
      pointBuyerRoutePointList: pointBuyerRoutePointList ?? this.pointBuyerRoutePointList,
    );
  }
}
