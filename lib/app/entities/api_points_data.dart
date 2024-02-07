part of 'entities.dart';

class ApiPointsData extends Equatable {
  final List<ApiPoint> points;
  final List<ApiRoutePoint> routePoints;
  final List<ApiVisit> visits;

  const ApiPointsData({
    required this.points,
    required this.routePoints,
    required this.visits
  });

  factory ApiPointsData.fromJson(Map<String, dynamic> json) {
    List<ApiPoint> points = json['points'].map<ApiPoint>((e) => ApiPoint.fromJson(e)).toList();
    List<ApiRoutePoint> routePoints = json['routePoints'].map<ApiRoutePoint>((e) => ApiRoutePoint.fromJson(e)).toList();
    List<ApiVisit> visits = json['visits'].map<ApiVisit>((e) => ApiVisit.fromJson(e)).toList();

    return ApiPointsData(points: points, routePoints: routePoints, visits: visits);
  }

  @override
  List<Object> get props => [
    points,
    routePoints,
    visits
  ];
}
