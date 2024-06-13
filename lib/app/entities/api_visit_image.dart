part of 'entities.dart';

class ApiVisitImage extends Equatable {
  final int id;
  final String guid;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String imageUrl;
  final String imageKey;

  const ApiVisitImage({
    required this.id,
    required this.guid,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.imageUrl,
    required this.imageKey
  });

  factory ApiVisitImage.fromJson(dynamic json) {
    return ApiVisitImage(
      id: json['id'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      latitude: Parsing.parseDouble(json['latitude'])!,
      longitude: Parsing.parseDouble(json['longitude'])!,
      accuracy: Parsing.parseDouble(json['accuracy'])!,
      imageUrl: json['imageUrl'],
      imageKey: json['imageKey']
    );
  }

  VisitImage toDatabaseEnt(String visitGuid) {
    return VisitImage(
      id: id,
      visitGuid: visitGuid,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      imageUrl: imageUrl,
      imageKey: imageKey,
      guid: guid,
      isNew: false,
      isDeleted: false,
      timestamp: timestamp,
      currentTimestamp: timestamp,
      lastSyncTime: timestamp,
      needSync: false,
    );
  }

  @override
  List<Object> get props => [
    id,
    latitude,
    longitude,
    accuracy,
    imageUrl,
    imageKey,
    guid,
    timestamp
  ];
}
