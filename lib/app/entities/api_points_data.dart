part of 'entities.dart';

class ApiPointsData extends Equatable {
  final List<ApiPoint> points;

  const ApiPointsData({
    required this.points
  });

  factory ApiPointsData.fromJson(Map<String, dynamic> json) {
    List<ApiPoint> points = json['points'].map<ApiPoint>((e) => ApiPoint.fromJson(e)).toList();

    return ApiPointsData(points: points);
  }

  @override
  List<Object> get props => [
    points
  ];
}
