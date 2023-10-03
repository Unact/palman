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

  Future<void> loadDeposits(List<Deposit> list, [bool clearTable = true]) async {
    await db._loadData(deposits, list, clearTable);
  }

  Future<void> loadEncashments(List<Encashment> list, [bool clearTable = true]) async {
    await db._loadData(encashments, list, clearTable);
  }

  Future<void> addDeposit(DepositsCompanion newDeposit) async {
    await into(deposits).insert(newDeposit);
  }

  Future<void> updateDeposit(String guid, DepositsCompanion updatedDeposit) async {
    await (update(deposits)..where((tbl) => tbl.guid.equals(guid))).write(updatedDeposit);
  }

  Future<void> addEncashment(EncashmentsCompanion newEncashment) async {
    await into(encashments).insert(newEncashment);
  }

  Future<void> updateEncashment(String guid, EncashmentsCompanion updatedEncashment) async {
    await (update(encashments)..where((tbl) => tbl.guid.equals(guid))).write(updatedEncashment);
  }

  Future<void> updateDebt(int id, DebtsCompanion updatedDebt) async {
    await (update(debts)..where((tbl) => tbl.id.equals(id))).write(updatedDebt);
  }

  Future<List<Encashment>> getEncashmentsForSync() async {
    final hasDepositToSync = existsQuery(
      select(deposits)
        ..where((tbl) => tbl.guid.equalsExp(encashments.depositGuid))
        ..where((tbl) => tbl.needSync.equals(true) | encashments.needSync.equals(true))
    );

    return (select(encashments)..where((tbl) => hasDepositToSync)).get();
  }

  Future<List<Deposit>> getDepositsForSync() async {
    final hasEncashmentToSync = existsQuery(
      select(encashments)
        ..where((tbl) => tbl.depositGuid.equalsExp(deposits.guid))
        ..where((tbl) => tbl.needSync.equals(true))
    );

    return (
      select(deposits)
        ..where((tbl) => tbl.needSync.equals(true) | hasEncashmentToSync)
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
        leftOuterJoin(deposits, deposits.guid.equalsExp(encashments.depositGuid)),
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

  Future<EncashmentEx> getEncashmentEx(String guid) async {
    final res = select(encashments)
      .join([
        leftOuterJoin(deposits, deposits.guid.equalsExp(encashments.depositGuid)),
        innerJoin(buyers, buyers.id.equalsExp(encashments.buyerId)),
        leftOuterJoin(debts, debts.id.equalsExp(encashments.debtId))
      ])
      ..where(encashments.guid.equals(guid));

    return res.map(
      (row) => EncashmentEx(
        row.readTable(encashments),
        row.readTable(buyers),
        row.readTableOrNull(debts),
        row.readTableOrNull(deposits)
      )
    ).getSingle();
  }

  Future<Deposit> getDeposit(String guid) async {
    return await (select(deposits)..where((tbl) => tbl.guid.equals(guid))).getSingle();
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
