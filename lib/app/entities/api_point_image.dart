part of 'entities.dart';

class ApiPointImage extends Equatable {
  final int id;
  final String guid;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String imageUrl;
  final String imageKey;
  final DateTime timestamp;

  const ApiPointImage({
    required this.id,
    required this.guid,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.imageUrl,
    required this.imageKey,
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
      imageKey: json['imageKey'],
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
      imageKey: imageKey,
      timestamp: timestamp,
      needSync: false
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
    imageKey,
    timestamp
  ];
}
