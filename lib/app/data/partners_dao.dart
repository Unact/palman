part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    Partners,
    Sites
  ]
)
class PartnersDao extends DatabaseAccessor<AppDataStore> with _$PartnersDaoMixin {
  PartnersDao(super.db);

   Future<void> loadBuyers(List<Buyer> list) async {
    await db._loadData(buyers, list);
  }

  Future<void> loadPartners(List<Partner> list) async {
    await db._loadData(partners, list);
  }

  Future<void> loadSites(List<Site> list) async {
    await db._loadData(sites, list);
  }

  Stream<List<BuyerEx>> watchBuyers() {
    final res = select(buyers)
      .join([
        innerJoin(partners, partners.id.equalsExp(buyers.partnerId)),
        innerJoin(sites, sites.id.equalsExp(buyers.siteId))
      ])
      ..orderBy([OrderingTerm(expression: buyers.name), OrderingTerm(expression: partners.name)]);

    return res.map(
      (row) => BuyerEx(
        row.readTable(buyers),
        row.readTable(partners),
        row.readTable(sites)
      )
    ).watch();
  }
}

class BuyerEx {
  final Buyer buyer;
  final Partner partner;
  final Site site;

  BuyerEx(this.buyer, this.partner, this.site);
}
