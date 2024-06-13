part of 'entities.dart';

class ApiVisitsData extends Equatable {
  final List<ApiRoutePoint> routePoints;
  final List<ApiVisit> visits;

  const ApiVisitsData({
    required this.routePoints,
    required this.visits
  });

  factory ApiVisitsData.fromJson(Map<String, dynamic> json) {
    List<ApiRoutePoint> routePoints = json['routePoints'].map<ApiRoutePoint>((e) => ApiRoutePoint.fromJson(e)).toList();
    List<ApiVisit> visits = json['visits'].map<ApiVisit>((e) => ApiVisit.fromJson(e)).toList();

    return ApiVisitsData(routePoints: routePoints, visits: visits);
  }

  @override
  List<Object> get props => [
    routePoints,
    visits
  ];
}
