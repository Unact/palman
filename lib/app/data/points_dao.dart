part of 'database.dart';

@DriftAccessor(
  tables: [
    Points,
    PointImages,
    PointFormats
  ]
)
class PointsDao extends DatabaseAccessor<AppDataStore> with _$PointsDaoMixin {
  PointsDao(AppDataStore db) : super(db);

  Future<void> blockPoints(bool block) async {
    await update(points).write(PointsCompanion(isBlocked: Value(block)));
  }

  Future<void> loadPoints(List<Point> list) async {
    await db._loadData(points, list);
  }

  Future<void> loadPointImages(List<PointImage> list) async {
    await db._loadData(pointImages, list);
  }

  Future<void> loadPointFormats(List<PointFormat> list) async {
    await db._loadData(pointFormats, list);
  }

  Future<List<PointFormat>> getPointFormats() async {
    return select(pointFormats).get();
  }

  Future<void> updatePoint(int id, PointsCompanion updatedPoint) async {
    await (update(points)..where((tbl) => tbl.id.equals(id))).write(updatedPoint);
  }

  Future<void> updatePointImage(int id, PointImagesCompanion updatedPointImage) async {
    await (update(pointImages)..where((tbl) => tbl.id.equals(id))).write(updatedPointImage);
  }

  Future<int> addPoint(PointsCompanion newPoint) async {
    return await into(points).insert(newPoint);
  }

  Future<int> addPointImage(PointImagesCompanion newPointImage) async {
    return await into(pointImages).insert(newPointImage);
  }

  Future<void> deletePoint(int pointId) async {
    await (delete(points)..where((tbl) => tbl.id.equals(pointId))).go();
  }

  Future<void> deletePointImage(int pointImageId) async {
    await (delete(pointImages)..where((tbl) => tbl.id.equals(pointImageId))).go();
  }

  Future<List<Point>> getPointsForSync() async {
    final hasPointImageToSync = existsQuery(
      select(pointImages)
        ..where((tbl) => tbl.pointId.equalsExp(points.id))
        ..where((tbl) => tbl.needSync.equals(true))
    );

    return (
      select(points)
        ..where((tbl) => tbl.needSync.equals(true) | hasPointImageToSync)
        ..where((tbl) => tbl.isBlocked.equals(false))
    ).get();
  }

  Future<List<PointImage>> getPointImagesForSync() async {
    final hasUnblockedPoint = existsQuery(
      select(points)
        ..where((tbl) => tbl.id.equalsExp(pointImages.pointId))
        ..where((tbl) => tbl.isBlocked.equals(false))
        ..where((tbl) => tbl.needSync.equals(true) | pointImages.needSync.equals(true))
    );

    return (select(pointImages)..where((tbl) => hasUnblockedPoint)).get();
  }

  Future<List<PointImage>> getPointImages() async {
    return await select(pointImages).get();
  }

  Future<List<PointEx>> getPointExList() async {
    final pointsRes = await (select(points)..orderBy([(tbl) => OrderingTerm(expression: tbl.buyerName)])).get();
    final pointImagesRes = await select(pointImages).get();

    return pointsRes.map((row) => PointEx(row, pointImagesRes.where((e) => e.pointId == row.id).toList())).toList();
  }

  Future<PointEx?> getPointEx(int id) async {
    final pointsRes = await (select(points)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    final pointImagesRes = await (select(pointImages)..where((tbl) => tbl.pointId.equals(id))).get();

    return pointsRes != null ? PointEx(pointsRes, pointImagesRes) : null;
  }
}

class PointEx {
  final Point point;
  final List<PointImage> images;

  bool get filled => images.length >= 3 && point.pointFormat != null && point.numberOfCdesks != null;

  PointEx(this.point, this.images);
}
