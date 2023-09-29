import 'package:collection/collection.dart';
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
          .map((e) => e.encashments.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e).toList();

        await dataStore.debtsDao.loadDebts(debts);
        await dataStore.debtsDao.loadEncashments(encashments);
        await dataStore.debtsDao.loadDeposits(deposits);
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
        'encashments': encashments.where((i) => i.depositId == e.id).map((i) => {
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

      await api.saveDebts(encashmentsData);
      await dataStore.transaction(() async {
        for (var deposit in deposits) {
          await dataStore.debtsDao.updateDeposit(
            deposit.id,
            DepositsCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }
        for (var encashment in encashments) {
          await dataStore.debtsDao.updateEncashment(
            encashment.id,
            EncashmentsCompanion(lastSyncTime: Value(lastSyncTime))
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
    final deposits = await dataStore.debtsDao.getDepositsForSync();
    final encashments = await dataStore.debtsDao.getEncashmentsForSync();

    if (deposits.isEmpty) return;

    await syncEncashments(deposits, encashments);
  }

  Future<Deposit> depositEncashments(DateTime date, List<EncashmentEx> encashmentExList) async {
    final deposits = await dataStore.debtsDao.getDeposits();
    final encWithSum = encashmentExList.where((e) => (e.encashment.encSum ?? 0) > 0);
    final encWithoutSum = encashmentExList.where((e) => (e.encashment.encSum ?? 0) == 0);
    Deposit? deposit = deposits.firstWhereOrNull((e) => e.date == date);
    final totalSum = encWithSum.fold(0.0, (acc, e) => acc + e.encashment.encSum!);
    final checkTotalSum = encWithSum
      .where((e) => e.encashment.isCheck).fold(0.0, (acc, e) => acc + e.encashment.encSum!);

    if (deposit != null) {
      await dataStore.debtsDao.updateDeposit(
        deposit.id,
        DepositsCompanion(
          totalSum: Value(deposit.totalSum + totalSum),
          checkTotalSum: Value(deposit.checkTotalSum + checkTotalSum),
          isDeleted: const Value(false)
        )
      );
    } else {
      final id = await dataStore.debtsDao.addDeposit(
        DepositsCompanion.insert(
          date: date,
          totalSum: totalSum,
          checkTotalSum: checkTotalSum
        )
      );
      deposit = await dataStore.debtsDao.getDeposit(id);
    }

    for (var e in encWithSum) {
      await dataStore.debtsDao.updateEncashment(e.encashment.id, EncashmentsCompanion(depositId: Value(deposit.id)));
    }
    for (var e in encWithoutSum) {
      await dataStore.debtsDao.deleteEncashment(e.encashment.id);
    }

    return deposit;
  }

  Future<EncashmentEx> addEncashment(Debt debt, Buyer buyer) async {
    final id = await dataStore.debtsDao.addEncashment(
      EncashmentsCompanion.insert(
        date: DateTime.now(),
        isCheck: debt.isCheck,
        buyerId: buyer.id,
        debtId: Value(debt.id)
      )
    );
    final encashment = await dataStore.debtsDao.getEncashmentEx(id);

    return encashment;
  }

  Future<void> updateEncashment(Encashment encashment, {
    Optional<double?>? encSum
  }) async {
    final newEncashment = EncashmentsCompanion(
      encSum: encSum == null ? const Value.absent() : Value(encSum.orNull),
      isDeleted: const Value(false)
    );

    await dataStore.debtsDao.updateEncashment(encashment.id, newEncashment);
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
    await dataStore.debtsDao.updateEncashment(
      encashment.id,
      EncashmentsCompanion(isDeleted: const Value(true))
    );
  }

  Future<void> regenerateGuid() async {
    await dataStore.debtsDao.regenerateDepositsGuid();
    await dataStore.debtsDao.regenerateEncashmentsGuid();
  }
}
//needSync во время, сравнивать с ts
