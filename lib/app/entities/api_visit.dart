part of 'entities.dart';

class ApiVisit extends Equatable {
  final int id;
  final String guid;
  final DateTime timestamp;
  final DateTime date;
  final int buyerId;
  final int? routePointId;
  final int? visitSkipReasonId;
  final List<ApiVisitImage> images;
  final List<ApiVisitSoftware> softwares;
  final List<ApiVisitGoodsList> goodsLists;
  final bool needCheckGL;
  final bool needTakePhotos;
  final bool needFillSoftware;

  const ApiVisit({
    required this.id,
    required this.guid,
    required this.timestamp,
    required this.date,
    required this.buyerId,
    this.routePointId,
    this.visitSkipReasonId,
    required this.images,
    required this.softwares,
    required this.goodsLists,
    required this.needCheckGL,
    required this.needTakePhotos,
    required this.needFillSoftware
  });

  factory ApiVisit.fromJson(dynamic json) {
    return ApiVisit(
      id: json['id'],
      guid: json['guid'],
      timestamp: Parsing.parseDate(json['timestamp'])!,
      date: Parsing.parseDate(json['date'])!,
      buyerId: json['buyerId'],
      routePointId: json['routePointId'],
      visitSkipReasonId: json['visitSkipReasonId'],
      images: json['images'].map<ApiVisitImage>((e) => ApiVisitImage.fromJson(e)).toList(),
      softwares: json['softwares'].map<ApiVisitSoftware>((e) => ApiVisitSoftware.fromJson(e)).toList(),
      goodsLists: json['goodsLists'].map<ApiVisitGoodsList>((e) => ApiVisitGoodsList.fromJson(e)).toList(),
      needCheckGL: json['needCheckGL'],
      needTakePhotos: json['needTakePhotos'],
      needFillSoftware: json['needFillSoftware']
    );
  }

  Visit toDatabaseEnt() {
    return Visit(
      id: id,
      date: date,
      buyerId: buyerId,
      routePointId: routePointId,
      visitSkipReasonId: visitSkipReasonId,
      visited: visitSkipReasonId == null,
      needCheckGL: needCheckGL,
      needTakePhotos: needTakePhotos,
      needFillSoftware: needFillSoftware,
      needDetails: needCheckGL || needTakePhotos,
      guid: guid,
      isNew: false,
      isDeleted: false,
      timestamp: timestamp,
      currentTimestamp: timestamp,
      lastSyncTime: timestamp,
      needSync: false
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    buyerId,
    routePointId,
    visitSkipReasonId,
    needCheckGL,
    needTakePhotos,
    needFillSoftware,
    images,
    softwares,
    goodsLists,
    guid,
    timestamp
  ];
}
