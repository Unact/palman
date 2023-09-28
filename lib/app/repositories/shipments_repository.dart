import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class ShipmentsRepository extends BaseRepository {
  ShipmentsRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

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
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncIncRequests(List<IncRequest> incRequests) async {
    try {
      List<Map<String, dynamic>> incRequestsData = incRequests.map((e) => {
        'guid': e.guid,
        'isNew': e.isNew,
        'isDeleted': e.isDeleted,
        'currentTimestamp': e.currentTimestamp.toIso8601String(),
        'timestamp': e.timestamp.toIso8601String(),
        'info': e.info,
        'buyerId': e.buyerId,
        'date': e.date?.toIso8601String(),
        'incSum': e.incSum
      }).toList();

      await api.saveShipments(incRequestsData);
      await dataStore.transaction(() async {
        for (var incRequest in incRequests) {
          await dataStore.shipmentsDao.updateIncRequest(
            incRequest.id,
            const IncRequestsCompanion(isNew: Value(false), needSync: Value(false))
          );
        }
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final incRequests = await dataStore.shipmentsDao.getIncRequestsForSync();

    if (incRequests.isEmpty) return;

    await syncIncRequests(incRequests);
  }

  Stream<List<IncRequestEx>> watchIncRequestExList() {
    return dataStore.shipmentsDao.watchIncRequestExList();
  }

  Stream<List<ShipmentExResult>> watchShipmentExList() {
    return dataStore.shipmentsDao.watchShipmentExList();
  }

  Stream<List<ShipmentLineEx>> watchShipmentLineExList(int shipmentId) {
    return dataStore.shipmentsDao.watchShipmentLineExList(shipmentId);
  }

  Future<IncRequestEx> addIncRequest() async {
    final id = await dataStore.shipmentsDao.addIncRequest(
      IncRequestsCompanion.insert(status: Strings.incRequestDefaultStatus)
    );
    final incRequestEx = await dataStore.shipmentsDao.getIncRequestEx(id);

    return incRequestEx;
  }

  Future<void> updateIncRequest(IncRequest incRequest, {
    Optional<int?>? buyerId,
    Optional<DateTime?>? date,
    Optional<String?>? info,
    Optional<double?>? incSum
  }) async {
    final updatedIncRequest = IncRequestsCompanion(
      buyerId: buyerId == null ? const Value.absent() : Value(buyerId.orNull),
      date: date == null ? const Value.absent() : Value(date.orNull),
      info: info == null ? const Value.absent() : Value(info.orNull),
      incSum: incSum == null ? const Value.absent() : Value(incSum.orNull),
      isDeleted: const Value(false),
      needSync: const Value(true)
    );

    await dataStore.shipmentsDao.updateIncRequest(incRequest.id, updatedIncRequest);
  }

  Future<void> deleteIncRequest(IncRequest incRequest) async {
    if (!incRequest.isNew) return;

    await dataStore.shipmentsDao.deleteIncRequest(incRequest.id);
  }

  Future<void> regenerateGuid() async {
    await dataStore.shipmentsDao.regenerateIncRequestsGuid();
  }
}
