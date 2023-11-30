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

  Stream<List<PreEncashmentEx>> watchPreEncashmentExList() {
    return dataStore.debtsDao.watchPreEncashmentExList();
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
        final preEncashments = data.preEncashments.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.debtsDao.loadDebts(debts);
        await dataStore.debtsDao.loadDeposits(deposits);
        await dataStore.debtsDao.loadPreEncashments(preEncashments);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncPreEncashments(List<PreEncashment> preEncashments) async {
    try {
      DateTime lastSyncTime = DateTime.now();
      List<Map<String, dynamic>> preEncashmentsData = preEncashments.map((i) => {
        'guid': i.guid,
        'isNew': i.isNew,
        'isDeleted': i.isDeleted,
        'currentTimestamp': i.currentTimestamp.toIso8601String(),
        'timestamp': i.timestamp.toIso8601String(),
        'debtId': i.debtId,
        'needReceipt': i.needReceipt,
        'encSum': i.encSum
      }).toList();

      final data = await api.saveDebts(preEncashmentsData);
      final apiPreEncashments = data.preEncashments.map((e) => e.toDatabaseEnt()).toList();
      await dataStore.transaction(() async {
        for (var encashment in preEncashments) {
          await dataStore.debtsDao.updatePreEncashment(
            encashment.guid,
            PreEncashmentsCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }

        await dataStore.debtsDao.loadPreEncashments(apiPreEncashments, false);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> deposit() async {
    try {
      final data = await api.deposit();

      await dataStore.transaction(() async {
        final debts = data.debts.map((e) => e.toDatabaseEnt()).toList();
        final deposits = data.deposits.map((e) => e.toDatabaseEnt()).toList();
        final preEncashments = data.preEncashments.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.debtsDao.loadDebts(debts);
        await dataStore.debtsDao.loadDeposits(deposits);
        await dataStore.debtsDao.loadPreEncashments(preEncashments);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final preEncashments = await dataStore.debtsDao.getPreEncashmentsForSync();

    if (preEncashments.isEmpty) return;

    await syncPreEncashments(preEncashments);
  }

  Future<PreEncashmentEx> addPreEncashment(Debt debt) async {
    final guid = dataStore.generateGuid();
    await dataStore.debtsDao.addPreEncashment(
      PreEncashmentsCompanion.insert(
        guid: guid,
        date: DateTime.now(),
        needReceipt: debt.needReceipt,
        debtId: debt.id
      )
    );
    final encashment = await dataStore.debtsDao.getPreEncashmentEx(guid);

    return encashment;
  }

  Future<void> updatePreEncashment(PreEncashment preEncashment, {
    Optional<double?>? encSum,
    bool restoreDeleted = true
  }) async {
    final newPreEncashment = PreEncashmentsCompanion(
      encSum: encSum == null ? const Value.absent() : Value(encSum.orNull),
      isDeleted: restoreDeleted ? const Value(false) : const Value.absent()
    );

    await dataStore.debtsDao.updatePreEncashment(preEncashment.guid, newPreEncashment);
  }

  Future<void> updateDebt(Debt debt, {
    Optional<double>? debtSum
  }) async {
    final newDebt = DebtsCompanion(
      debtSum: debtSum == null ? const Value.absent() : Value(debtSum.value)
    );

    await dataStore.debtsDao.updateDebt(debt.id, newDebt);
  }

  Future<void> deletePreEncashment(PreEncashment preEncashment) async {
    await dataStore.debtsDao.updatePreEncashment(
      preEncashment.guid,
      const PreEncashmentsCompanion(isDeleted: Value(true))
    );
  }

  Future<void> regenerateGuid() async {
    await dataStore.debtsDao.regeneratePreEncashmentsGuid();
  }
}
