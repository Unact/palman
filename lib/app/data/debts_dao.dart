part of 'database.dart';

@DriftAccessor(
  tables: [
    Partners,
    Buyers,
    Debts,
    Deposits,
    PreEncashments
  ]
)
class DebtsDao extends DatabaseAccessor<AppDataStore> with _$DebtsDaoMixin {
  DebtsDao(super.db);

  Future<void> regeneratePreEncashmentsGuid() async {
    await db._regenerateGuid(preEncashments);
  }

  Future<void> loadDebts(List<Debt> list) async {
    await db._loadData(debts, list);
  }

  Future<void> loadDeposits(List<Deposit> list, [bool clearTable = true]) async {
    await db._loadData(deposits, list, clearTable);
  }

  Future<void> loadPreEncashments(List<PreEncashment> list, [bool clearTable = true]) async {
    await db._loadData(preEncashments, list, clearTable);
  }

  Future<void> addPreEncashment(PreEncashmentsCompanion newEncashment) async {
    await into(preEncashments).insert(newEncashment);
  }

  Future<void> updatePreEncashment(String guid, PreEncashmentsCompanion updatedEncashment) async {
    await (update(preEncashments)..where((tbl) => tbl.guid.equals(guid))).write(updatedEncashment);
  }

  Future<void> updateDebt(int id, DebtsCompanion updatedDebt) async {
    await (update(debts)..where((tbl) => tbl.id.equals(id))).write(updatedDebt);
  }

  Future<List<PreEncashment>> getPreEncashmentsForSync() {
    return (select(preEncashments)..where((tbl) => tbl.needSync.equals(true))).get();
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

  Stream<List<PreEncashmentEx>> watchPreEncashmentExList() {
    final res = select(preEncashments)
      .join([
        leftOuterJoin(debts, debts.id.equalsExp(preEncashments.debtId)),
        innerJoin(buyers, buyers.id.equalsExp(preEncashments.buyerId)),
      ])
      ..orderBy([
        OrderingTerm(expression: preEncashments.date, mode: OrderingMode.desc),
        OrderingTerm(expression: buyers.name)
      ]);

    return res.map(
      (row) => PreEncashmentEx(
        row.readTable(preEncashments),
        row.readTable(buyers),
        row.readTableOrNull(debts)
      )
    ).watch();
  }

  Future<PreEncashmentEx> getPreEncashmentEx(String guid) async {
    final res = select(preEncashments)
      .join([
        leftOuterJoin(debts, debts.id.equalsExp(preEncashments.debtId)),
        innerJoin(buyers, buyers.id.equalsExp(preEncashments.buyerId)),
      ])
      ..where(preEncashments.guid.equals(guid));

    return res.map(
      (row) => PreEncashmentEx(
        row.readTable(preEncashments),
        row.readTable(buyers),
        row.readTableOrNull(debts)
      )
    ).getSingle();
  }

  Selectable<Deposit> _deposits() {
    return (
      select(deposits)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
        (tbl) => OrderingTerm(expression: tbl.totalSum, mode: OrderingMode.desc)
      ]));
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

class PreEncashmentEx {
  final PreEncashment preEncashment;
  final Buyer buyer;
  final Debt? debt;

  PreEncashmentEx(this.preEncashment, this.buyer, this.debt);
}
