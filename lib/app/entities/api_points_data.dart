part of 'entities.dart';

class ApiPointsData extends Equatable {
  final List<ApiPoint> points;
  final List<ApiRoutePoint> routePoints;

  const ApiPointsData({
    required this.points,
    required this.routePoints
  });

  factory ApiPointsData.fromJson(Map<String, dynamic> json) {
    List<ApiPoint> points = json['points'].map<ApiPoint>((e) => ApiPoint.fromJson(e)).toList();
    List<ApiRoutePoint> routePoints = json['routePoints'].map<ApiRoutePoint>((e) => ApiRoutePoint.fromJson(e)).toList();

    return ApiPointsData(points: points, routePoints: routePoints);
  }

  @override
  List<Object> get props => [
    points,
    routePoints
  ];
}
