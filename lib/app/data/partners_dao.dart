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

  Stream<List<BuyerEx>> watchBuyers() {
    final res = select(buyers)
      .join([
        innerJoin(partners, partners.id.equalsExp(buyers.partnerId))
      ])
      ..orderBy([OrderingTerm(expression: buyers.name), OrderingTerm(expression: partners.name)]);

    return res.map(
      (row) => BuyerEx(
        row.readTable(buyers),
        row.readTable(partners)
      )
    ).watch();
  }
}

class BuyerEx {
  final Buyer buyer;
  final Partner partner;

  BuyerEx(this.buyer, this.partner);
}
