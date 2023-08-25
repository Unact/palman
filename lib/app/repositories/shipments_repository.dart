import 'package:drift/drift.dart';
import 'package:quiver/core.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/api.dart';
import '/app/utils/misc.dart';

class ShipmentsRepository extends BaseRepository {
  ShipmentsRepository(AppDataStore dataStore, Api api) : super(dataStore, api);

  Future<void> loadShipments() async {
    try {
      final data = await api.getShipments();

      await dataStore.transaction(() async {
        final incRequests = data.incRequests.map((e) => e.toDatabaseEnt()).toList();
        final shipments = data.shipments.map((e) => e.toDatabaseEnt()).toList();
        final shipmentLines = data.shipments
          .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e).toList();

        await dataStore.shipmentsDao.loadIncRequests(incRequests);
        await dataStore.shipmentsDao.loadShipments(shipments);
        await dataStore.shipmentsDao.loadShipmentLines(shipmentLines);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> blockIncRequests(bool block) async {
    await dataStore.shipmentsDao.blockIncRequests(block);
    notifyListeners();
  }

  Future<void> syncChanges() async {
    final incRequests = await dataStore.shipmentsDao.getIncRequestsForSync();

    if (incRequests.isEmpty) return;

    await blockIncRequests(true);

    try {
      List<Map<String, dynamic>> data = incRequests.map((e) => {
        'timestamp': e.timestamp.toIso8601String(),
        'info': e.info,
        'buyerId': e.buyerId,
        'date': e.date?.toIso8601String(),
        'incSum': e.incSum
      }).toList();

      await api.saveShipments(data);

      await Future.forEach(
        incRequests,
        (e) => dataStore.shipmentsDao.updateIncRequest(e.id, const IncRequestsCompanion(needSync: Value(false)))
      );
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    } finally {
      await blockIncRequests(false);
    }

    await loadShipments();
  }

  Future<List<IncRequestEx>> getIncRequestExList() async {
    return dataStore.shipmentsDao.getIncRequestExList();
  }

  Future<List<ShipmentExResult>> getShipmentExList() async {
    return dataStore.shipmentsDao.getShipmentExList();
  }

  Future<List<ShipmentLineEx>> getShipmentLineExList(int shipmentId) async {
    return dataStore.shipmentsDao.getShipmentLineExList(shipmentId);
  }

  Future<IncRequestEx> getIncRequestEx(int id) async {
    return dataStore.shipmentsDao.getIncRequestEx(id);
  }

  Future<IncRequestEx> addIncRequest() async {
    final id = await dataStore.shipmentsDao.addIncRequest(
      IncRequestsCompanion.insert(
        status: Strings.incRequestDefaultStatus,
        timestamp: DateTime.now(),
        isBlocked: false,
        needSync: false
      )
    );
    final incRequestEx = await dataStore.shipmentsDao.getIncRequestEx(id);

    notifyListeners();

    return incRequestEx;
  }

  Future<void> updateIncRequest(IncRequest incRequest, {
    Optional<int?>? buyerId,
    Optional<DateTime?>? date,
    Optional<String?>? info,
    Optional<double?>? incSum,
    Optional<bool>? needSync
  }) async {
    final updatedIncRequest = IncRequestsCompanion(
      buyerId: buyerId == null ? const Value.absent() : Value(buyerId.orNull),
      date: date == null ? const Value.absent() : Value(date.orNull),
      info: info == null ? const Value.absent() : Value(info.orNull),
      incSum: incSum == null ? const Value.absent() : Value(incSum.orNull),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
    );

    await dataStore.shipmentsDao.updateIncRequest(incRequest.id, updatedIncRequest);
    notifyListeners();
  }

  Future<void> deleteIncRequest(IncRequest incRequest) async {
    await dataStore.shipmentsDao.deleteIncRequest(incRequest.id);
    notifyListeners();
  }
}
