import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:quiver/core.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/api.dart';
import '/app/utils/misc.dart';

class DebtsRepository extends BaseRepository {
  DebtsRepository(AppDataStore dataStore, Api api) : super(dataStore, api);

  Future<EncashmentEx> getEncashmentEx(int id) {
    return dataStore.debtsDao.getEncashmentEx(id);
  }

  Future<List<DebtEx>> getDebtExList() {
    return dataStore.debtsDao.getDebtExList();
  }

  Future<List<EncashmentEx>> getEncashmentExList() {
    return dataStore.debtsDao.getEncashmentExList();
  }

  Future<List<Deposit>> getDeposits() {
    return dataStore.debtsDao.getDeposits();
  }

  Future<void> loadDebts() async {
    try {
      final debtsData = await api.getDebts();

      await dataStore.transaction(() async {
        final debts = debtsData.debts.map((e) => e.toDatabaseEnt()).toList();
        final encashments = debtsData.encashments.map((e) => e.toDatabaseEnt()).toList();
        final deposits = debtsData.deposits.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.debtsDao.loadDebts(debts);
        await dataStore.debtsDao.loadEncashments(encashments);
        await dataStore.debtsDao.loadDeposits(deposits);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> blockEncashments(bool block) async {
    await dataStore.debtsDao.blockEncashments(block);
    notifyListeners();
  }

  Future<void> syncChanges() async {
    final deposits = await dataStore.debtsDao.getDeposits();
    final encashments = await dataStore.debtsDao.getEncashmentsForSync();

    if (encashments.isEmpty) return;

    await blockEncashments(true);

    try {
      List<Map<String, dynamic>> data = encashments
        .groupFoldBy<int, List<Encashment>>((e) => e.depositId!, (acc, e) => (acc ?? [])..add(e)).entries
        .map((e) => {
          'date': deposits.firstWhere((i) => i.id == e.key).date.toIso8601String(),
          'encashments': e.value.map((i) => {
            'timestamp': i.timestamp.toIso8601String(),
            'debtId': i.debtId,
            'buyerId': i.buyerId,
            'isCheck': i.isCheck,
            'encSum': i.encSum
          }).toList()
        })
        .toList();

      await api.saveDebts(data);

      await Future.forEach(
        encashments,
        (e) => dataStore.debtsDao.updateEncashment(e.id, const EncashmentsCompanion(needSync: Value(false)))
      );
      await loadDebts();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    } finally {
      await blockEncashments(false);
    }
  }

  Future<Deposit> addDeposit(List<EncashmentEx> encashmentExList) async {
    final encWithSum = encashmentExList.where((e) => (e.encashment.encSum ?? 0) > 0);
    final encWithoutSum = encashmentExList.where((e) => (e.encashment.encSum ?? 0) == 0);
    final id = await dataStore.debtsDao.addDeposit(
      DepositsCompanion.insert(
        date: DateTime.now(),
        totalSum: encWithSum.fold(0, (acc, e) => acc + e.encashment.encSum!),
        checkTotalSum: encWithSum.where((e) => e.encashment.isCheck).fold(0, (acc, e) => acc + e.encashment.encSum!),
      )
    );
    final deposit = await dataStore.debtsDao.getDeposit(id);

    await Future.forEach(encWithSum, (e) async {
      final updatedEncashment = EncashmentsCompanion(
          depositId: Value(id),
          encSum: Value(e.encashment.encSum!),
          needSync: const Value(true)
        );
      await dataStore.debtsDao.updateEncashment(e.encashment.id, updatedEncashment);
    });
    await Future.forEach(encWithoutSum, (e) async {
      await dataStore.debtsDao.deleteEncashment(e.encashment.id);
    });

    notifyListeners();

    return deposit;
  }

  Future<EncashmentEx> addEncashment(Debt debt, Buyer buyer) async {
    final id = await dataStore.debtsDao.addEncashment(
      EncashmentsCompanion.insert(
        date: DateTime.now(),
        isCheck: debt.isCheck,
        buyerId: buyer.id,
        debtId: debt.id,
        timestamp: DateTime.now(),
        isBlocked: false,
        needSync: false
      )
    );
    final encashment = await dataStore.debtsDao.getEncashmentEx(id);

    notifyListeners();

    return encashment;
  }

  Future<void> updateEncashment(Encashment encashment, {
    Optional<double?>? encSum,
    Optional<bool>? needSync
  }) async {
    final newEncashment = EncashmentsCompanion(
      encSum: encSum == null ? const Value.absent() : Value(encSum.orNull),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
    );

    await dataStore.debtsDao.updateEncashment(encashment.id, newEncashment);
    notifyListeners();
  }

  Future<void> updateDebt(Debt debt, {
    Optional<double>? debtSum
  }) async {
    final newDebt = DebtsCompanion(
      debtSum: debtSum == null ? const Value.absent() : Value(debtSum.value)
    );

    await dataStore.debtsDao.updateDebt(debt.id, newDebt);
    notifyListeners();
  }

  Future<void> deleteEncashment(Encashment encashment) async {
    await dataStore.debtsDao.deleteEncashment(encashment.id);
    notifyListeners();
  }
}
