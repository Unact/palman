part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    Partners
  ]
)
class PartnersDao extends DatabaseAccessor<AppDataStore> with _$PartnersDaoMixin {
  PartnersDao(AppDataStore db) : super(db);

   Future<void> loadBuyers(List<Buyer> list) async {
    await db._loadData(buyers, list);
  }

  Future<void> loadPartners(List<Partner> list) async {
    await db._loadData(partners, list);
  }

  Stream<List<Buyer>> watchBuyers() {
    return (select(buyers)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)])).watch();
  }
}
