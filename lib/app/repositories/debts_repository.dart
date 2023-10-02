import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class DebtsRepository extends BaseRepository {
  DebtsRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Stream<List<DebtEx>> watchDebtExList() {
    return dataStore.debtsDao.watchDebtExList();
  }

  Stream<List<EncashmentEx>> watchEncashmentExList() {
    return dataStore.debtsDao.watchEncashmentExList();
  }

  Stream<List<Deposit>> watchDeposits() {
    return dataStore.debtsDao.watchDeposits();
  }

  Future<void> loadDebts() async {
    try {
      final data = await api.getDebts();

      await dataStore.transaction(() async {
        final debts = data.debts.map((e) => e.toDatabaseEnt()).toList();
        final deposits = data.deposits.map((e) => e.toDatabaseEnt()).toList();
        final encashments = data.deposits
          .map((e) => e.encashments.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e).toList();

        await dataStore.debtsDao.loadDebts(debts);
        await dataStore.debtsDao.loadDeposits(deposits);
        await dataStore.debtsDao.loadEncashments(encashments);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncEncashments(List<Deposit> deposits, List<Encashment> encashments) async {
    try {
      DateTime lastSyncTime = DateTime.now();
      List<Map<String, dynamic>> encashmentsData = deposits.map((e) => {
        'guid': e.guid,
        'isNew': e.isNew,
        'isDeleted': e.isDeleted,
        'currentTimestamp': e.currentTimestamp.toIso8601String(),
        'timestamp': e.timestamp.toIso8601String(),
        'date': e.date.toIso8601String(),
        'encashments': encashments.where((i) => i.depositGuid == e.guid).map((i) => {
          'guid': i.guid,
          'isNew': i.isNew,
          'isDeleted': i.isDeleted,
          'currentTimestamp': i.currentTimestamp.toIso8601String(),
          'timestamp': i.timestamp.toIso8601String(),
          'debtId': i.debtId,
          'buyerId': i.buyerId,
          'isCheck': i.isCheck,
          'encSum': i.encSum
        }).toList()
      }).toList();

      final data = await api.saveDebts(encashmentsData);
      final apiDeposits = data.deposits.map((e) => e.toDatabaseEnt()).toList();
      final apiEncashments = data.deposits
          .map((e) => e.encashments.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e).toList();
      await dataStore.transaction(() async {
        for (var deposit in deposits) {
          await dataStore.debtsDao.updateDeposit(
            deposit.guid,
            DepositsCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }
        for (var encashment in encashments) {
          await dataStore.debtsDao.updateEncashment(
            encashment.guid,
            EncashmentsCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }

        await dataStore.debtsDao.loadDeposits(apiDeposits, false);
        await dataStore.debtsDao.loadEncashments(apiEncashments, false);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final deposits = await dataStore.debtsDao.getDepositsForSync();
    final encashments = await dataStore.debtsDao.getEncashmentsForSync();

    if (deposits.isEmpty) return;

    await syncEncashments(deposits, encashments);
  }

  Future<Deposit> depositEncashments(DateTime date, List<EncashmentEx> encashmentExList) async {
    final encWithSum = encashmentExList.where((e) => (e.encashment.encSum ?? 0) > 0);
    final encWithoutSum = encashmentExList.where((e) => (e.encashment.encSum ?? 0) == 0);
    final totalSum = encWithSum.fold(0.0, (acc, e) => acc + e.encashment.encSum!);
    final checkTotalSum = encWithSum
      .where((e) => e.encashment.isCheck).fold(0.0, (acc, e) => acc + e.encashment.encSum!);

    final guid = dataStore.generateGuid();
    await dataStore.debtsDao.addDeposit(
      DepositsCompanion.insert(
        guid: guid,
        date: date,
        totalSum: totalSum,
        checkTotalSum: checkTotalSum
      )
    );
    final deposit = await dataStore.debtsDao.getDeposit(guid);

    for (var e in encWithSum) {
      await dataStore.debtsDao.updateEncashment(e.encashment.guid, EncashmentsCompanion(depositGuid: Value(guid)));
    }
    for (var e in encWithoutSum) {
      await dataStore.debtsDao.updateEncashment(e.encashment.guid, const EncashmentsCompanion(isDeleted: Value(true)));
    }

    return deposit;
  }

  Future<EncashmentEx> addEncashment(Debt debt, Buyer buyer) async {
    final guid = dataStore.generateGuid();
    await dataStore.debtsDao.addEncashment(
      EncashmentsCompanion.insert(
        guid: guid,
        date: DateTime.now(),
        isCheck: debt.isCheck,
        buyerId: buyer.id,
        debtId: Value(debt.id)
      )
    );
    final encashment = await dataStore.debtsDao.getEncashmentEx(guid);

    return encashment;
  }

  Future<void> updateEncashment(Encashment encashment, {
    Optional<double?>? encSum
  }) async {
    final newEncashment = EncashmentsCompanion(
      encSum: encSum == null ? const Value.absent() : Value(encSum.orNull),
      isDeleted: const Value(false)
    );

    await dataStore.debtsDao.updateEncashment(encashment.guid, newEncashment);
  }

  Future<void> updateDebt(Debt debt, {
    Optional<double>? debtSum
  }) async {
    final newDebt = DebtsCompanion(
      debtSum: debtSum == null ? const Value.absent() : Value(debtSum.value)
    );

    await dataStore.debtsDao.updateDebt(debt.id, newDebt);
  }

  Future<void> deleteEncashment(Encashment encashment) async {
    await dataStore.debtsDao.updateEncashment(encashment.guid, const EncashmentsCompanion(isDeleted: Value(true)));
  }

  Future<void> regenerateGuid() async {
    await dataStore.debtsDao.regenerateDepositsGuid();
    await dataStore.debtsDao.regenerateEncashmentsGuid();
  }
}
