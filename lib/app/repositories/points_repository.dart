import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/api.dart';
import '/app/utils/misc.dart';

class PointsRepository extends BaseRepository {
  static const _kPointsFileFolder = 'points';

  PointsRepository(AppDataStore dataStore, Api api) : super(dataStore, api);

  String getPointImagePath(int id) {
    return p.join(_kPointsFileFolder, '$id.jpg');
  }

  Future<PointEx?> getPointEx(int id) {
    return dataStore.pointsDao.getPointEx(id);
  }

  Future<List<PointEx>> getPointExList() {
    return dataStore.pointsDao.getPointExList();
  }

  Future<List<PointImage>> getPointImages() {
    return dataStore.pointsDao.getPointImages();
  }

  Future<List<PointFormat>> getPointFormats() {
    return dataStore.pointsDao.getPointFormats();
  }

  Future<void> loadPoints() async {
    try {
      final data = await api.getPoints();

      await dataStore.transaction(() async {
        final points = data.points.map((e) => e.toDatabaseEnt()).toList();
        final pointImages = data.points
          .map((e) => e.images.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e)
          .map((e) => e.copyWith(imagePath: getPointImagePath(e.id)))
          .toList();

        await dataStore.pointsDao.loadPoints(points);
        await dataStore.pointsDao.loadPointImages(pointImages);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<bool> preloadPointImage(PointImage pointImage) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = getPointImagePath(pointImage.id);
    final fullImagePath = p.join(directory.path, imagePath);

    if (pointImage.needSync) return true;
    if (File(fullImagePath).existsSync()) return true;

    try {
      await Dio().download(pointImage.imageUrl, fullImagePath);
      await dataStore.pointsDao.updatePointImage(pointImage.id, PointImagesCompanion(imagePath: Value(imagePath)));
    } on DioException catch(e) {
      throw AppError(e.message ?? 'Ошибка при загрузке фотографии');
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }

    return true;
  }

  Future<PointEx> addPoint() async {
    final id = await dataStore.pointsDao.addPoint(
      PointsCompanion.insert(
        name: Strings.newPointName,
        buyerName: Strings.newPointName,
        reason: Strings.pointReasonZone,
        timestamp: DateTime.now(),
        isBlocked: false,
        needSync: false
      )
    );
    final point = await dataStore.pointsDao.getPointEx(id);

    notifyListeners();

    return point!;
  }

  Future<void> addPointImage(Point point, {
    required XFile file,
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp
  }) async {
    final id = await dataStore.pointsDao.addPointImage(
      PointImagesCompanion.insert(
        pointId: point.id,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        imageUrl: '',
        imagePath: '',
        timestamp: timestamp,
        needSync: true
      )
    );
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = getPointImagePath(id);
    final fullImagePath = p.join(directory.path, imagePath);

    await file.saveTo(fullImagePath);
    await dataStore.pointsDao.updatePoint(point.id, const PointsCompanion(needSync: Value(true)));
    await dataStore.pointsDao.updatePointImage(id, PointImagesCompanion(imagePath: Value(imagePath)));
    notifyListeners();
  }

  Future<void> updatePoint(Point point, {
    Optional<String>? name,
    Optional<String>? address,
    Optional<String>? buyerName,
    Optional<String>? reason,
    Optional<double?>? latitude,
    Optional<double?>? longitude,
    Optional<int>? pointFormat,
    Optional<int?>? numberOfCdesks,
    Optional<String?>? emailOnlineCheck,
    Optional<String?>? email,
    Optional<String?>? phoneOnlineCheck,
    Optional<String?>? inn,
    Optional<String?>? jur,
    Optional<int?>? plong,
    Optional<int?>? maxdebt,
    Optional<int?>? nds10,
    Optional<int?>? nds20,
    Optional<bool>? needSync
  }) async {
    final newPoint = PointsCompanion(
      name: name == null ? const Value.absent() : Value(name.value),
      address: address == null ? const Value.absent() : Value(address.value),
      buyerName: buyerName == null ? const Value.absent() : Value(buyerName.value),
      reason: reason == null ? const Value.absent() : Value(reason.value),
      latitude: latitude == null ? const Value.absent() : Value(latitude.value),
      longitude: longitude == null ? const Value.absent() : Value(longitude.value),
      pointFormat: pointFormat == null ? const Value.absent() : Value(pointFormat.value),
      numberOfCdesks: numberOfCdesks == null ? const Value.absent() : Value(numberOfCdesks.value),
      emailOnlineCheck: emailOnlineCheck == null ? const Value.absent() : Value(emailOnlineCheck.value),
      email: email == null ? const Value.absent() : Value(email.value),
      phoneOnlineCheck: phoneOnlineCheck == null ? const Value.absent() : Value(phoneOnlineCheck.value),
      inn: inn == null ? const Value.absent() : Value(inn.value),
      jur: jur == null ? const Value.absent() : Value(jur.value),
      plong: plong == null ? const Value.absent() : Value(plong.value),
      maxdebt: maxdebt == null ? const Value.absent() : Value(maxdebt.value),
      nds10: nds10 == null ? const Value.absent() : Value(nds10.value),
      nds20: nds20 == null ? const Value.absent() : Value(nds20.value),
      timestamp: Value(DateTime.now()),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
    );

    await dataStore.pointsDao.updatePoint(point.id, newPoint);
    notifyListeners();
  }

  Future<void> deletePoint(Point point) async {
    if (point.guid != null) return;

    await dataStore.pointsDao.deletePoint(point.id);

    notifyListeners();
    return;
  }

  Future<void> deletePointImage(PointImage pointImage) async {
    if (pointImage.guid != null) return;

    await dataStore.pointsDao.deletePointImage(pointImage.id);
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = getPointImagePath(pointImage.id);
    final fullImagePath = p.join(directory.path, imagePath);

    await File(fullImagePath).delete();

    notifyListeners();
    return;
  }

  Future<void> blockPoints(bool block) async {
    await dataStore.pointsDao.blockPoints(block);
    notifyListeners();
  }

  Future<List<PointEx>> syncPoints(List<Point> points, List<PointImage> pointImages) async {
    if (points.isEmpty) return [];

    try {
      final directory = await getApplicationDocumentsDirectory();
      List<Map<String, dynamic>> pointsData = points.map((e) => {
        'guid': e.guid,
        'timestamp': e.timestamp.toIso8601String(),
        'name': e.name,
        'address': e.address,
        'buyerName': e.buyerName,
        'reason': e.reason,
        'latitude': e.latitude,
        'longitude': e.longitude,
        'pointFormat': e.pointFormat,
        'numberOfCdesks': e.numberOfCdesks,
        'emailOnlineCheck': e.emailOnlineCheck,
        'email': e.email,
        'phoneOnlineCheck': e.phoneOnlineCheck,
        'inn': e.inn,
        'jur': e.jur,
        'plong': e.plong,
        'maxdebt': e.maxdebt,
        'nds10': e.nds10,
        'nds20': e.nds20,
        'images': pointImages.where((i) => i.pointId == e.id).map((i) => {
          'guid': i.guid,
          'latitude': i.latitude,
          'longitude': i.longitude,
          'accuracy': i.accuracy,
          'timestamp': i.timestamp.toIso8601String(),
          'imageData': File(p.join(directory.path, i.imagePath)).existsSync() ?
            base64Encode(File(p.join(directory.path, i.imagePath)).readAsBytesSync()) :
            null
        }).toList()
      }).toList();

      final data = await api.savePoints(pointsData);
      final ids = [];
      await dataStore.transaction(() async {
        for (var point in points) {
          await dataStore.pointsDao.deletePoint(point.id);
        }
        for (var pointImage in pointImages) {
          await dataStore.pointsDao.deletePointImage(pointImage.id);
        }
        for (var apiPoint in data.points) {
          final pointsCompanion = apiPoint.toDatabaseEnt().toCompanion(false).copyWith(id: const Value.absent());
          final id = await dataStore.pointsDao.addPoint(pointsCompanion);
          final apiPointImages = apiPoint.images.map((i) => i.toDatabaseEnt(id)).toList();

          for (var apiPointImage in apiPointImages) {
            final pointImagesCompanion = apiPointImage.toCompanion(false).copyWith(id: const Value.absent());
            await dataStore.pointsDao.addPointImage(pointImagesCompanion);
          }
          ids.add(id);
        }
      });
      for (var e in pointImages) {
        await File(p.join(directory.path, e.imagePath)).delete();
      }
      notifyListeners();

      return (await dataStore.pointsDao.getPointExList()).where((e) => ids.contains(e.point.id)).toList();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final points = await dataStore.pointsDao.getPointsForSync();
    final pointImages = await dataStore.pointsDao.getPointImagesForSync();

    try {
      await blockPoints(true);
      await syncPoints(points, pointImages);
    } finally {
      await blockPoints(false);
    }
  }

  Future<void> clearFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/$_kPointsFileFolder";
    final pathDirectory = await Directory(path).create(recursive: true);
    final filePaths = (pathDirectory.listSync()).map((e) => e.path).toSet();

    for (var filePath in filePaths) {
      await File(filePath).delete();
    }
  }
}
