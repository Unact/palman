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
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      await Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> blockDeposits(bool block, {List<int>? ids}) async {
    await dataStore.debtsDao.blockDeposits(block, ids: ids);
    notifyListeners();
  }

  Future<void> syncEncashments(List<Deposit> deposits, List<Encashment> encashments) async {
    try {
      List<Map<String, dynamic>> encashmentsData = deposits.map((e) => {
        'guid': e.guid,
        'timestamp': e.timestamp.toIso8601String(),
        'date': e.date.toIso8601String(),
        'encashments': encashments.where((i) => i.depositId == e.id && i.needSync).map((i) => {
          'guid': i.guid,
          'timestamp': i.timestamp.toIso8601String(),
          'debtId': i.debtId,
          'buyerId': i.buyerId,
          'isCheck': i.isCheck,
          'encSum': i.encSum
        }).toList()
      }).toList();

      final data = await api.saveDebts(encashmentsData);
      await dataStore.transaction(() async {
        for (var encashment in encashments) {
          await dataStore.debtsDao.deleteEncashment(encashment.id);
        }
        for (var deposit in deposits) {
          await dataStore.debtsDao.deleteDeposit(deposit.id);
        }
        for (var apiDeposit in data.deposits) {
          final depositsCompanion = apiDeposit.toDatabaseEnt().toCompanion(false).copyWith(id: const Value.absent());
          final id = await dataStore.debtsDao.addDeposit(depositsCompanion);
          final apiEncashments = apiDeposit.encashments.map((i) => i.toDatabaseEnt(id)).toList();

          for (var apiEncashment in apiEncashments) {
            final encashmentsCompanion = apiEncashment.toCompanion(false).copyWith(
              id: const Value.absent(),
              depositId: Value(id)
            );
            await dataStore.debtsDao.addEncashment(encashmentsCompanion);
          }
        }
      });
      notifyListeners();
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

    try {
      await blockDeposits(true);
      await syncEncashments(deposits, encashments);
    } finally {
      await blockDeposits(false);
    }
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
          timestamp: Value(DateTime.now()),
          needSync: const Value(true)
        )
      );
    } else {
      final id = await dataStore.debtsDao.addDeposit(
        DepositsCompanion.insert(
          date: date,
          totalSum: totalSum,
          checkTotalSum: checkTotalSum,
          timestamp: DateTime.now(),
          isBlocked: false,
          needSync: true
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

    notifyListeners();

    return deposit;
  }

  Future<EncashmentEx> addEncashment(Debt debt, Buyer buyer) async {
    final id = await dataStore.debtsDao.addEncashment(
      EncashmentsCompanion.insert(
        date: DateTime.now(),
        isCheck: debt.isCheck,
        buyerId: buyer.id,
        debtId: Value(debt.id),
        timestamp: DateTime.now(),
        needSync: true
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
