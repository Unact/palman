import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class ReturnActsRepository extends BaseRepository {
  ReturnActsRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<void> loadReturnActs() async {
     try {
      final data = await api.getReturnActs();

      await dataStore.transaction(() async {
        final returnActs = data.returnActs.map((e) => e.toDatabaseEnt()).toList();
        final returnActsLines = data.returnActs
          .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e).toList();

        await dataStore.returnActsDao.loadReturnActs(returnActs);
        await dataStore.returnActsDao.loadReturnActLines(returnActsLines);
        await dataStore.returnActsDao.loadGoodsReturnStocks([]);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> loadReturnRemains({
    required int buyerId,
    required int returnActTypeId
  }) async {
     try {
      final data = await api.getReturnRemains(buyerId: buyerId, returnActTypeId: returnActTypeId);

      await dataStore.transaction(() async {
        final goodsReturnStocks = data.goodsReturnStocks.map((e) => e.toDatabaseEnt(buyerId, returnActTypeId)).toList();

        await dataStore.returnActsDao.loadGoodsReturnStocks(goodsReturnStocks, false);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> clearReturnActLines(ReturnAct returnAct) async {
    await dataStore.transaction(() async {
      final returnActLinesEx = await dataStore.returnActsDao.getReturnActLineExList(returnAct.guid);

      for (var returnActLine in returnActLinesEx) {
        await deleteReturnActLine(returnActLine.line);
      }
    });
  }

  Future<void> syncReturnActs(List<ReturnAct> returnActs, List<ReturnActLine> returnActLines) async {
    try {
      List<Map<String, dynamic>> returnActsData = returnActs.map((e) => {
        'guid': e.guid,
        'isNew': e.isNew,
        'isDeleted': e.isDeleted,
        'currentTimestamp': e.currentTimestamp.toIso8601String(),
        'timestamp': e.timestamp.toIso8601String(),
        'needPickup': e.needPickup,
        'receptId': e.receptId,
        'buyerId': e.buyerId,
        'returnActTypeId': e.returnActTypeId,
        'lines': returnActLines.where((i) => i.returnActGuid == e.guid).map((i) => {
          'guid': i.guid,
          'isNew': i.isNew,
          'isDeleted': i.isDeleted,
          'currentTimestamp': i.currentTimestamp.toIso8601String(),
          'timestamp': i.timestamp.toIso8601String(),
          'goodsId': i.goodsId,
          'vol': i.vol,
          'productionDate': i.productionDate?.toIso8601String(),
          'isBad': i.isBad,
        }).toList()
      }).toList();

      final data = await api.saveReturnActs(returnActsData);
      final apiReturnActs = data.returnActs.map((e) => e.toDatabaseEnt()).toList();
      final apiReturnActsLines = data.returnActs
        .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e).toList();
      await dataStore.transaction(() async {
        for (var returnAct in returnActs) {
          await dataStore.returnActsDao.deleteReturnAct(returnAct.guid);
          await dataStore.returnActsDao.deleteReturnActReturnActLines(returnAct.guid);
        }

        await dataStore.returnActsDao.loadReturnActs(apiReturnActs, false);
        await dataStore.returnActsDao.loadReturnActLines(apiReturnActsLines, false);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final returnActs = await dataStore.returnActsDao.getReturnActsForSync();
    final returnActLines = await dataStore.returnActsDao.getReturnActLinesForSync();

    if (returnActs.isEmpty) return;

    await syncReturnActs(returnActs, returnActLines);
  }

  Future<List<ReturnActType>> getReturnActTypes({
    required int buyerId
  }) async {
    return dataStore.returnActsDao.getReturnActTypes(buyerId: buyerId);
  }

  Future<List<ReturnActLineExResult>> getReturnActLineExList(String returnActGuid) async {
    return dataStore.returnActsDao.getReturnActLineExList(returnActGuid);
  }

  Stream<List<ReturnActExResult>> watchReturnActExList() {
    return dataStore.returnActsDao.watchReturnActExList();
  }

  Stream<List<ReturnActLineExResult>> watchReturnActLineExList(String returnActGuid) {
    return dataStore.returnActsDao.watchReturnActLineExList(returnActGuid);
  }

  Future<List<ReceptExResult>> getReceptExList({
    required int buyerId,
    required int returnActTypeId
  }) {
    return dataStore.returnActsDao.getReceptExList(buyerId: buyerId, returnActTypeId: returnActTypeId);
  }

  Stream<List<GoodsReturnDetail>> watchGoodsReturnDetails({
    required int buyerId,
    required int returnActTypeId,
    required List<int> goodsIds,
    int? receptId
  }) {
    return dataStore.returnActsDao.watchGoodsReturnDetails(
      buyerId: buyerId,
      returnActTypeId: returnActTypeId,
      receptId: receptId,
      goodsIds: goodsIds
    );
  }

  Future<List<Goods>> getBuyerGoods({
    required String? name,
    required String? extraLabel,
    required int? categoryId,
    required int buyerId,
    required List<int>? goodsIds,
    required bool onlyLatest,
    required String? barcode
  }) async {
    return dataStore.returnActsDao.getBuyerGoods(
      name: name,
      extraLabel: extraLabel,
      categoryId: categoryId,
      buyerId: buyerId,
      goodsIds: goodsIds,
      onlyLatest: onlyLatest,
      barcode: barcode
    );
  }

  Future<ReturnActExResult> addReturnAct() async {
    final guid = dataStore.generateGuid();
    await dataStore.returnActsDao.addReturnAct(
      ReturnActsCompanion.insert(
        guid: guid,
        needPickup: true,
        date: Value(DateTime.now().date())
      )
    );
    final returnActEx = await dataStore.returnActsDao.getReturnActEx(guid);

    return returnActEx;
  }

  Future<void> addReturnActLine(ReturnAct returnAct, {
    required int goodsId,
    required double vol,
    required DateTime? productionDate,
    required bool? isBad
  }) async {
    final guid = dataStore.generateGuid();
    await dataStore.returnActsDao.addReturnActLine(
      ReturnActLinesCompanion.insert(
        guid: guid,
        returnActGuid: returnAct.guid,
        goodsId: goodsId,
        vol: vol,
        productionDate: Value(productionDate),
        isBad: Value(isBad)
      )
    );
  }

  Future<void> updateReturnAct(ReturnAct returnAct, {
    Optional<DateTime?>? date,
    Optional<String?>? number,
    Optional<int?>? buyerId,
    Optional<bool>? needPickup,
    Optional<int?>? returnActTypeId,
    Optional<int?>? receptId,
    Optional<String?>? receptNdoc,
    Optional<DateTime?>? receptDate,
    bool restoreDeleted = true
  }) async {
    final updatedReturnAct = ReturnActsCompanion(
      date: date == null ? const Value.absent() : Value(date.orNull),
      buyerId: buyerId == null ? const Value.absent() : Value(buyerId.orNull),
      needPickup: needPickup == null ? const Value.absent() : Value(needPickup.value),
      returnActTypeId: returnActTypeId == null ? const Value.absent() : Value(returnActTypeId.orNull),
      receptId: receptId == null ? const Value.absent() : Value(receptId.orNull),
      receptNdoc: receptNdoc == null ? const Value.absent() : Value(receptNdoc.orNull),
      receptDate: receptDate == null ? const Value.absent() : Value(receptDate.orNull),
      isDeleted: restoreDeleted ? const Value(false) : const Value.absent()
    );

    await dataStore.returnActsDao.updateReturnAct(returnAct.guid, updatedReturnAct);
  }

  Future<void> updateReturnActLine(ReturnActLine returnActLine, {
    Optional<int>? goodsId,
    Optional<double>? vol,
    Optional<DateTime?>? productionDate,
    Optional<bool?>? isBad,
    bool restoreDeleted = true
  }) async {
    final updatedReturnActLine = ReturnActLinesCompanion(
      goodsId: goodsId == null ? const Value.absent() : Value(goodsId.value),
      vol: vol == null ? const Value.absent() : Value(vol.value),
      productionDate: productionDate == null ? const Value.absent() : Value(productionDate.orNull),
      isBad: isBad == null ? const Value.absent() : Value(isBad.orNull),
      isDeleted: restoreDeleted ? const Value(false) : const Value.absent()
    );

    await dataStore.returnActsDao.updateReturnActLine(returnActLine.guid, updatedReturnActLine);
  }

  Future<void> deleteReturnAct(ReturnAct returnAct) async {
    await dataStore.returnActsDao.updateReturnAct(returnAct.guid, const ReturnActsCompanion(isDeleted: Value(true)));
  }

  Future<void> deleteReturnActLine(ReturnActLine returnActLine) async {
    await dataStore.returnActsDao.updateReturnActLine(
      returnActLine.guid,
      const ReturnActLinesCompanion(isDeleted: Value(true))
    );
  }

  Future<void> regenerateGuid() async {
    await dataStore.returnActsDao.regenerateReturnActsGuid();
    await dataStore.returnActsDao.regenerateReturnActLinesGuid();
  }
}
