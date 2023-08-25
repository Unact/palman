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

  Future<List<Partner>> getPartners() async {
    return (select(partners)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)])).get();
  }

  Future<List<Buyer>> getBuyers() async {
    return (select(buyers)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)])).get();
  }
}
