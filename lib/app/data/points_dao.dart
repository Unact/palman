part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    Points,
    PointImages,
    PointFormats,
    RoutePoints
  ]
)
class PointsDao extends DatabaseAccessor<AppDataStore> with _$PointsDaoMixin {
  PointsDao(super.db);

  Future<void> regeneratePointsGuid() async {
    await db._regenerateGuid(points);
  }

  Future<void> regeneratePointImagesGuid() async {
    await db._regenerateGuid(pointImages);
  }

  Future<void> loadPoints(List<Point> list, [bool clearTable = true]) async {
    await db._loadData(points, list, clearTable);
  }

  Future<void> loadPointImages(List<PointImage> list, [bool clearTable = true]) async {
    await db._loadData(pointImages, list, clearTable);
  }

  Future<void> loadPointFormats(List<PointFormat> list) async {
    await db._loadData(pointFormats, list);
  }

  Stream<List<PointFormat>> watchPointFormats() {
    return select(pointFormats).watch();
  }

  Stream<List<PointBuyerRoutePoint>> watchPointBuyerRoutePoints() {
    final pointsRes = select(points).join([
      leftOuterJoin(buyers, buyers.pointId.equalsExp(points.id))
    ]).watch();
    final routePointsRes = select(routePoints).watch();

    return Rx.combineLatest2(
      pointsRes,
      routePointsRes,
      (pointRows, routePointRows) => pointRows.map((row) {
        return PointBuyerRoutePoint(
          row.readTable(points),
          routePointRows.where((e) => e.buyerId == row.readTableOrNull(buyers)?.id).toList()
        );
      }).toList()
    );
  }

  Future<void> updatePoint(String guid, PointsCompanion updatedPoint) async {
    await (update(points)..where((tbl) => tbl.guid.equals(guid))).write(updatedPoint);
  }

  Future<void> updatePointImage(String guid, PointImagesCompanion updatedPointImage) async {
    await (update(pointImages)..where((tbl) => tbl.guid.equals(guid))).write(updatedPointImage);
  }

  Future<void> addPoint(PointsCompanion newPoint) async {
    await into(points).insert(newPoint);
  }

  Future<void> addPointImage(PointImagesCompanion newPointImage) async {
    await into(pointImages).insert(newPointImage);
  }

  Future<List<Point>> getPointsForSync() async {
    final hasPointImageToSync = existsQuery(
      select(pointImages)
        ..where((tbl) => tbl.pointGuid.equalsExp(points.guid))
        ..where((tbl) => tbl.needSync.equals(true))
    );

    return (
      select(points)
        ..where((tbl) => tbl.needSync.equals(true) | hasPointImageToSync)
    ).get();
  }

  Future<List<PointImage>> getPointImagesForSync() async {
    final hasPointToSync = existsQuery(
      select(points)
        ..where((tbl) => tbl.guid.equalsExp(pointImages.pointGuid))
        ..where((tbl) => tbl.needSync.equals(true) | pointImages.needSync.equals(true))
    );

    return (select(pointImages)..where((tbl) => hasPointToSync)).get();
  }

  Future<List<PointImage>> getPointImages() async {
    return await select(pointImages).get();
  }

  Stream<List<PointEx>> watchPointExList() {
    final pointsRes = (select(points)..orderBy([(tbl) => OrderingTerm(expression: tbl.buyerName)])).watch();
    final pointImagesRes = select(pointImages).watch();

    return Rx.combineLatest2(
      pointsRes,
      pointImagesRes,
      (points, pointImages) {
        return points.map((row) => PointEx(row, pointImages.where((e) => e.pointGuid == row.guid).toList())).toList();
      }
    );
  }

  Future<PointEx> getPointEx(String guid) async {
    final pointsRes = await (select(points)..where((tbl) => tbl.guid.equals(guid))).getSingle();
    final pointImagesRes = await (select(pointImages)..where((tbl) => tbl.pointGuid.equals(guid))).get();

    return PointEx(pointsRes, pointImagesRes);
  }
}

class PointEx {
  final Point point;
  final List<PointImage> images;

  bool get filled => images.length >= 3 && point.pointFormat != null && point.numberOfCdesks != null;

  PointEx(this.point, this.images);
}

class PointBuyerRoutePoint {
  final Point point;
  final List<RoutePoint> routePoints;

  PointBuyerRoutePoint(this.point, this.routePoints);
}
