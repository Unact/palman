import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cross_file/cross_file.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/extensions/io_file_system.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class PointsRepository extends BaseRepository {
  static const _kPointImagesFileFolder = 'point_images';
  static final _pointImagesCacheRepo = JsonCacheInfoRepository(databaseName: _kPointImagesFileFolder);
  static final pointImagesCacheManager = CacheManager(
    Config(
      _kPointImagesFileFolder,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 10000,
      repo: _pointImagesCacheRepo,
      fileSystem: IOFileSystem(_kPointImagesFileFolder),
      fileService: HttpFileService(),
    ),
  );

  PointsRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Stream<List<PointEx>> watchPointExList() {
    return dataStore.pointsDao.watchPointExList();
  }

  Future<List<PointImage>> getPointImages() {
    return dataStore.pointsDao.getPointImages();
  }

  Stream<List<PointFormat>> watchPointFormats() {
    return dataStore.pointsDao.watchPointFormats();
  }

  Future<void> loadPoints() async {
    try {
      final data = await api.getPoints();

      await dataStore.transaction(() async {
        final points = data.points.map((e) => e.toDatabaseEnt()).toList();
        final pointImages = data.points
          .map((e) => e.images.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e)
          .toList();

        await dataStore.pointsDao.loadPoints(points);
        await dataStore.pointsDao.loadPointImages(pointImages);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<bool> preloadPointImage(PointImage pointImage) async {
    if (await pointImagesCacheManager.getFileFromCache(pointImage.imageKey) != null) return true;

    try {
      await pointImagesCacheManager.downloadFile(pointImage.imageUrl, key: pointImage.imageKey);
    } on HttpException catch(e) {
      throw AppError('Ошибка загрузки: ${e.message}');
    } on ClientException catch(e) {
      throw AppError('Ошибка загрузки: ${e.message}');
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

    return point!;
  }

  Future<void> addPointImage(Point point, {
    required XFile file,
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp
  }) async {
    final imageKey = md5.convert(await file.readAsBytes());
    final id = await dataStore.pointsDao.addPointImage(
      PointImagesCompanion.insert(
        pointId: point.id,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        imageUrl: '',
        imageKey: imageKey.toString(),
        timestamp: timestamp,
        needSync: true
      )
    );
    final pointImage = await dataStore.pointsDao.getPointImage(id);
    await pointImagesCacheManager.putFile('', await file.readAsBytes(), key: pointImage.imageKey);
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
      latitude: latitude == null ? const Value.absent() : Value(latitude.orNull),
      longitude: longitude == null ? const Value.absent() : Value(longitude.orNull),
      pointFormat: pointFormat == null ? const Value.absent() : Value(pointFormat.value),
      numberOfCdesks: numberOfCdesks == null ? const Value.absent() : Value(numberOfCdesks.orNull),
      emailOnlineCheck: emailOnlineCheck == null ? const Value.absent() : Value(emailOnlineCheck.orNull),
      email: email == null ? const Value.absent() : Value(email.orNull),
      phoneOnlineCheck: phoneOnlineCheck == null ? const Value.absent() : Value(phoneOnlineCheck.orNull),
      inn: inn == null ? const Value.absent() : Value(inn.orNull),
      jur: jur == null ? const Value.absent() : Value(jur.orNull),
      plong: plong == null ? const Value.absent() : Value(plong.orNull),
      maxdebt: maxdebt == null ? const Value.absent() : Value(maxdebt.orNull),
      nds10: nds10 == null ? const Value.absent() : Value(nds10.orNull),
      nds20: nds20 == null ? const Value.absent() : Value(nds20.orNull),
      timestamp: Value(DateTime.now()),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
    );

    await dataStore.pointsDao.updatePoint(point.id, newPoint);
  }

  Future<void> deletePoint(Point point) async {
    if (point.guid != null) return;

    await dataStore.pointsDao.deletePoint(point.id);
  }

  Future<void> deletePointImage(PointImage pointImage) async {
    if (pointImage.guid != null) return;

    await dataStore.pointsDao.deletePointImage(pointImage.id);
    await pointImagesCacheManager.removeFile(pointImage.imageKey);
  }

  Future<void> blockPoints(bool block, {List<int>? ids}) async {
    await dataStore.pointsDao.blockPoints(block, ids: ids);
  }

  Future<List<PointEx>> syncPoints(List<Point> points, List<PointImage> pointImages) async {
    try {
      final Map<PointImage, FileInfo?> images = {};
      for (var pointImage in pointImages) {
        final file = await pointImagesCacheManager.getFileFromCache(pointImage.imageKey);
        images.putIfAbsent(pointImage, () => file);
      }

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
        'images': pointImages.where((i) => i.pointId == e.id && i.needSync).map((i) => {
          'guid': i.guid,
          'timestamp': i.timestamp.toIso8601String(),
          'latitude': i.latitude,
          'longitude': i.longitude,
          'accuracy': i.accuracy,
          'imageData': images[i] != null ? base64Encode(images[i]!.file.readAsBytesSync()) : null
        }).toList()
      }).toList();

      final data = await api.savePoints(pointsData);
      final List<int> ids = [];
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
            final pointImagesCompanion = apiPointImage.toCompanion(false).copyWith(
              id: const Value.absent(),
              pointId: Value(id)
            );
            await dataStore.pointsDao.addPointImage(pointImagesCompanion);
          }
          ids.add(id);
        }
      });

      return dataStore.pointsDao.getPointExListByIds(ids);
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

    if (points.isEmpty) return;

    try {
      await blockPoints(true);
      await syncPoints(points, pointImages);
    } finally {
      await blockPoints(false);
    }
  }

  Future<void> clearFiles([Set<String> newKeys = const <String>{}]) async {
    final cacheObjects = await _pointImagesCacheRepo.getAllObjects();
    final oldCacheObjects = cacheObjects.where((e) => !newKeys.contains(e.key));

    for (var oldCacheObject in oldCacheObjects) {
      await pointImagesCacheManager.removeFile(oldCacheObject.key);
    }
  }
}
