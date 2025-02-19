part of 'entities.dart';

class ApiVisitPurpose extends Equatable {
  final int id;
  final String guid;
  final DateTime timestamp;
  final String description;
  final bool? completed;
  final String? info;

  const ApiVisitPurpose({
    required this.id,
    required this.guid,
    required this.timestamp,
    required this.description,
    required this.completed,
    required this.info
  });

  factory ApiVisitPurpose.fromJson(dynamic json) {
    return ApiVisitPurpose(
      id: json['id'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      description: json['description'],
      completed: json['completed'],
      info: json['info']
    );
  }

  VisitPurpose toDatabaseEnt(String visitGuid) {
    return VisitPurpose(
      id: id,
      visitGuid: visitGuid,
      description: description,
      completed: completed,
      info: info,
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
  List<Object?> get props => [
    id,
    description,
    completed,
    info,
    guid,
    timestamp
  ];
}
