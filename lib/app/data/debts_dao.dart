part of 'database.dart';

@DriftAccessor(
  tables: [
    Partners,
    Buyers,
    Debts,
    Deposits,
    Encashments
  ]
)
class DebtsDao extends DatabaseAccessor<AppDataStore> with _$DebtsDaoMixin {
  DebtsDao(AppDataStore db) : super(db);

  Future<void> regenerateDepositsGuid() async {
    await db._regenerateGuid(deposits);
  }

  Future<void> regenerateEncashmentsGuid() async {
    await db._regenerateGuid(encashments);
  }

  Future<void> loadDebts(List<Debt> list) async {
    await db._loadData(debts, list);
  }

  Future<void> loadDeposits(List<Deposit> list) async {
    await db._loadData(deposits, list);
  }

  Future<void> loadEncashments(List<Encashment> list) async {
    await db._loadData(encashments, list);
  }

  Future<int> addDeposit(DepositsCompanion newDeposit) async {
    return await into(deposits).insert(newDeposit);
  }

  Future<void> updateDeposit(int id, DepositsCompanion updatedDeposit) async {
    await (update(deposits)..where((tbl) => tbl.id.equals(id))).write(updatedDeposit);
  }

  Future<int> addEncashment(EncashmentsCompanion newEncashment) async {
    return await into(encashments).insert(newEncashment);
  }

  Future<void> updateEncashment(int id, EncashmentsCompanion updatedEncashment) async {
    await (update(encashments)..where((tbl) => tbl.id.equals(id))).write(updatedEncashment);
  }

  Future<void> deleteEncashment(int encashmentId) async {
    await (delete(encashments)..where((tbl) => tbl.id.equals(encashmentId))).go();
  }

  Future<void> deleteDeposit(int depositId) async {
    await (delete(deposits)..where((tbl) => tbl.id.equals(depositId))).go();
  }

  Future<void> updateDebt(int id, DebtsCompanion updatedDebt) async {
    await (update(debts)..where((tbl) => tbl.id.equals(id))).write(updatedDebt);
  }

  Future<List<Encashment>> getEncashmentsForSync() async {
    final hasDepositToSync = existsQuery(
      select(deposits)
        ..where((tbl) => tbl.id.equalsExp(encashments.depositId))
        ..where((tbl) =>
          tbl.lastSyncTime.isNull() | tbl.lastSyncTime.isSmallerThan(tbl.timestamp) |
          encashments.lastSyncTime.isNull() | encashments.lastSyncTime.isSmallerThan(encashments.timestamp)
        )
    );

    return (select(encashments)..where((tbl) => hasDepositToSync)).get();
  }

  Future<List<Deposit>> getDepositsForSync() async {
    final hasEncashmentToSync = existsQuery(
      select(encashments)
        ..where((tbl) => tbl.depositId.equalsExp(deposits.id))
        ..where((tbl) => tbl.lastSyncTime.isNull() | tbl.lastSyncTime.isSmallerThan(tbl.timestamp))
    );

    return (
      select(deposits)
        ..where((tbl) =>
          tbl.lastSyncTime.isNull() | tbl.lastSyncTime.isSmallerThan(tbl.timestamp) |
          hasEncashmentToSync
        )
    ).get();
  }

  Stream<List<DebtEx>> watchDebtExList() {
    final res = select(debts)
      .join([
        innerJoin(buyers, buyers.id.equalsExp(debts.buyerId)),
        innerJoin(partners, partners.id.equalsExp(buyers.partnerId))
      ])
      ..orderBy([OrderingTerm(expression: partners.name), OrderingTerm(expression: debts.dateUntil)]);

    return res.map((row) => DebtEx(row.readTable(debts), row.readTable(buyers), row.readTable(partners))).watch();
  }

  Stream<List<EncashmentEx>> watchEncashmentExList() {
    final res = select(encashments)
      .join([
        leftOuterJoin(deposits, deposits.id.equalsExp(encashments.depositId)),
        innerJoin(buyers, buyers.id.equalsExp(encashments.buyerId)),
        leftOuterJoin(debts, debts.id.equalsExp(encashments.debtId))
      ])
      ..orderBy([
        OrderingTerm(expression: deposits.date, mode: OrderingMode.desc),
        OrderingTerm(expression: buyers.name)
      ]);

    return res.map(
      (row) => EncashmentEx(
        row.readTable(encashments),
        row.readTable(buyers),
        row.readTableOrNull(debts),
        row.readTableOrNull(deposits)
      )
    ).watch();
  }

  Future<EncashmentEx> getEncashmentEx(int id) async {
    final res = select(encashments)
      .join([
        leftOuterJoin(deposits, deposits.id.equalsExp(encashments.depositId)),
        innerJoin(buyers, buyers.id.equalsExp(encashments.buyerId)),
        leftOuterJoin(debts, debts.id.equalsExp(encashments.debtId))
      ])
      ..where(encashments.id.equals(id));

    return res.map(
      (row) => EncashmentEx(
        row.readTable(encashments),
        row.readTable(buyers),
        row.readTableOrNull(debts),
        row.readTableOrNull(deposits)
      )
    ).getSingle();
  }

  Future<Deposit> getDeposit(int id) async {
    return await (select(deposits)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Selectable<Deposit> _deposits() {
    return (select(deposits)..orderBy([(tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.desc)]));
  }

  Stream<List<Deposit>> watchDeposits() {
    return _deposits().watch();
  }

  Future<List<Deposit>> getDeposits() {
    return _deposits().get();
  }
}

class DebtEx {
  final Debt debt;
  final Buyer buyer;
  final Partner partner;

  DebtEx(this.debt, this.buyer, this.partner);
}

class EncashmentEx {
  final Encashment encashment;
  final Buyer buyer;
  final Debt? debt;
  final Deposit? deposit;

  EncashmentEx(this.encashment, this.buyer, this.debt, this.deposit);
}
