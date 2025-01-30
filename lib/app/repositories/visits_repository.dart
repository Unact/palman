import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cross_file/cross_file.dart';
import 'package:crypto/crypto.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class VisitsRepository extends BaseRepository {
  static const _kVisitImagesFileFolder = 'visit_images';
  static final _visitImagesCacheRepo = JsonCacheInfoRepository(databaseName: _kVisitImagesFileFolder);
  static final visitImagesCacheManager = CacheManager(
    Config(
      _kVisitImagesFileFolder,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 10000,
      repo: _visitImagesCacheRepo,
      fileSystem: IOFileSystem(_kVisitImagesFileFolder),
      fileService: HttpFileService(),
    ),
  );
  static const _kVisitSoftwaresFileFolder = 'visit_softwares';
  static final _visitSoftwaresCacheRepo = JsonCacheInfoRepository(databaseName: _kVisitSoftwaresFileFolder);
  static final visitSoftwaresCacheManager = CacheManager(
    Config(
      _kVisitSoftwaresFileFolder,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 10000,
      repo: _visitSoftwaresCacheRepo,
      fileSystem: IOFileSystem(_kVisitSoftwaresFileFolder),
      fileService: HttpFileService(),
    ),
  );

  VisitsRepository(super.dataStore, super.api);

  Stream<List<VisitSoftware>> watchVisitSoftwares(String visitGuid) {
    return dataStore.visitsDao.watchVisitSoftwares(visitGuid);
  }

  Stream<List<VisitImage>> watchVisitImages(String visitGuid) {
    return dataStore.visitsDao.watchVisitImages(visitGuid);
  }

  Stream<List<GoodsListVisitExResult>> watchGoodsListVisitExList(String visitGuid) {
    return dataStore.visitsDao.watchGoodsListVisitEx(visitGuid);
  }

  Stream<List<RoutePointEx>> watchRoutePointExList() {
    return dataStore.visitsDao.watchRoutePoints();
  }

  Stream<List<VisitEx>> watchVisitExList() {
    return dataStore.visitsDao.watchVisitExList();
  }

  Stream<List<GoodsList>> watchGoodsLists() {
    return dataStore.visitsDao.watchGoodsLists();
  }

  Future<void> loadVisits() async {
    try {
      final data = await api.getVisits();

      await _saveApiData(data, true);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> addVisitImage(Visit visit, {
    required XFile file,
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp
  }) async {
    try {
      String guid = dataStore.generateGuid();
      final fileData = await file.readAsBytes();
      final imageKey = md5.convert(fileData);
      Map<String, dynamic> visitImageData = {
        'guid': guid,
        'visitId': visit.id,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'imageData': base64Encode(fileData),
        'timestamp': timestamp.toIso8601String()
      };
      final data = await api.addVisitImage(visitImageData);

      await visitImagesCacheManager.putFile('', fileData, key: imageKey.toString());
      await _saveApiData(data, false);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> deleteVisitImage(VisitImage visitImage) async {
    try {
      Map<String, dynamic> visitImageData = {
        'guid': visitImage.guid
      };
      final data = await api.deleteVisitImage(visitImageData);

      await visitImagesCacheManager.removeFile(visitImage.imageKey);
      await _saveApiData(data, false);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> addVisitSoftware(Visit visit, {
    required XFile file,
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp
  }) async {
    try {
      String guid = dataStore.generateGuid();
      final fileData = await file.readAsBytes();
      final imageKey = md5.convert(fileData);
      Map<String, dynamic> visitSoftwareData = {
        'guid': guid,
        'visitId': visit.id,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'imageData': base64Encode(fileData),
        'timestamp': timestamp.toIso8601String()
      };
      final data = await api.addVisitSoftware(visitSoftwareData);

      await visitSoftwaresCacheManager.putFile('', fileData, key: imageKey.toString());
      await _saveApiData(data, false);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> deleteVisitSoftware(VisitSoftware visitSoftware) async {
    try {
      Map<String, dynamic> visitSoftwareData = {
        'guid': visitSoftware.guid
      };
      final data = await api.deleteVisitSoftware(visitSoftwareData);

      await visitSoftwaresCacheManager.removeFile(visitSoftware.imageKey);
      await _saveApiData(data, false);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> finishVisitList(Visit visit, {
    required int goodsListId,
    required List<int> goodsIds
  }) async {
    try {
      String guid = dataStore.generateGuid();
      Map<String, dynamic> visitGoodsListData = {
        'guid': guid,
        'visitId': visit.id,
        'goodsListId': goodsListId,
        'goodsIds': goodsIds
      };
      final data = await api.finishVisitList(visitGoodsListData);
      await _saveApiData(data, false);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<VisitEx> visit({
    required Buyer buyer,
    required RoutePoint? routePoint,
    required VisitSkipReason? visitSkipReason,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double altitude,
    required double heading,
    required double speed,
    required DateTime timestamp
  }) async {
    try {
      String guid = dataStore.generateGuid();
      Map<String, dynamic> visitData = {
        'guid': guid,
        'buyerId': buyer.id,
        'routePointId': routePoint?.id,
        'visitSkipReasonId': visitSkipReason?.id,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'altitude': altitude,
        'heading': heading,
        'speed': speed,
        'timestamp': timestamp.toIso8601String()
      };
      final data = await api.visit(visitData);

      await _saveApiData(data, false);

      return dataStore.visitsDao.getVisitEx(guid);
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> clearFiles([Set<String> newKeys = const <String>{}]) async {
    final cacheObjects = await _visitImagesCacheRepo.getAllObjects();
    final oldCacheObjects = cacheObjects.where((e) => !newKeys.contains(e.key));

    for (var oldCacheObject in oldCacheObjects) {
      try {
        await visitImagesCacheManager.removeFile(oldCacheObject.key);
      } on PathNotFoundException {
        continue;
      }
    }
  }

  Future<void> _saveApiData(ApiVisitsData data, bool clearTable) async {
    await dataStore.transaction(() async {
      final visits = data.visits.map((e) => e.toDatabaseEnt()).toList();
      final visitImages = data.visits
        .map((e) => e.images.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e)
        .toList();
      final visitSoftwares = data.visits
        .map((e) => e.softwares.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e)
        .toList();
      final visitGoodsLists = data.visits
        .map((e) => e.goodsLists.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e)
        .toList();
      final visitGoodsListGoods = data.visits
        .map((e) => e.goodsLists.map((i) => i.goods.map((j) => j.toDatabaseEnt(i.guid))).expand((e) => e))
        .expand((e) => e)
        .toList();
      final routePoints = data.routePoints.map((e) => e.toDatabaseEnt()).toList();

      await dataStore.visitsDao.loadVisits(visits, clearTable);
      await dataStore.visitsDao.loadVisitImages(visitImages, clearTable);
      await dataStore.visitsDao.loadVisitSoftwares(visitSoftwares, clearTable);
      await dataStore.visitsDao.loadVisitGoodsLists(visitGoodsLists, clearTable);
      await dataStore.visitsDao.loadVisitGoodsListGoods(visitGoodsListGoods, clearTable);
      await dataStore.visitsDao.loadRoutePoints(routePoints, clearTable);
    });
  }
}
