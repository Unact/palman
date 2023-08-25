part of 'entities.dart';

class ApiPointImage extends Equatable {
  final int id;
  final String guid;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String imageUrl;
  final DateTime timestamp;

  const ApiPointImage({
    required this.id,
    required this.guid,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.imageUrl,
    required this.timestamp
  });

  factory ApiPointImage.fromJson(dynamic json) {
    return ApiPointImage(
      id: json['id'],
      guid: json['guid'],
      latitude: Parsing.parseDouble(json['latitude'])!,
      longitude: Parsing.parseDouble(json['longitude'])!,
      accuracy: Parsing.parseDouble(json['accuracy'])!,
      imageUrl: json['imageUrl'],
      timestamp: Parsing.parseDate(json['timestamp'])!
    );
  }

  PointImage toDatabaseEnt(int pointId) {
    return PointImage(
      id: id,
      guid: guid,
      pointId: pointId,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      imageUrl: imageUrl,
      timestamp: timestamp,
      needSync: false,
      imagePath: ''
    );
  }

  @override
  List<Object> get props => [
    id,
    guid,
    latitude,
    longitude,
    accuracy,
    imageUrl,
    timestamp
  ];
}
