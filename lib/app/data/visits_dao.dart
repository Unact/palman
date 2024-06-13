part of 'database.dart';

@DriftAccessor(
  tables: [
    AllGoods,
    Buyers,
    Partners,
    Sites,
    RoutePoints,
    Visits,
    VisitImages,
    VisitGoodsLists,
    AllVisitGoodsListGoods,
    GoodsLists,
    AllGoodsListGoods
  ],
  queries: {
    'goodsListVisitEx': '''
      SELECT
        goods_lists.** AS "goods_list",
        LIST(
          SELECT goods.id, goods.name
          FROM goods
          JOIN goods_list_goods ON goods_list_goods.goods_id = goods.id
          WHERE goods_list_goods.goods_list_id = goods_lists.id
        ) AS goods,
        visit_goods_lists.id IS NOT NULL AS "has_visit_goods_list",
        LIST(
          SELECT goods.id, goods.name
          FROM goods
          JOIN visit_goods_list_goods ON visit_goods_list_goods.goods_id = goods.id
          WHERE visit_goods_lists.guid = visit_goods_list_goods.visit_goods_list_guid
        ) AS visit_goods
      FROM goods_lists
      LEFT JOIN visit_goods_lists ON
        visit_goods_lists.goods_list_id = goods_lists.id AND
        visit_goods_lists.visit_guid = :guid
      ORDER BY goods_lists.name
    ''',
  }
)
class VisitsDao extends DatabaseAccessor<AppDataStore> with _$VisitsDaoMixin {
  VisitsDao(AppDataStore db) : super(db);

  Future<void> loadVisitImages(List<VisitImage> list, [bool clearTable = true]) async {
    await db._loadData(visitImages, list, clearTable);
  }

  Future<void> loadVisitGoodsLists(List<VisitGoodsList> list, [bool clearTable = true]) async {
    await db._loadData(visitGoodsLists, list, clearTable);
  }

  Future<void> loadVisitGoodsListGoods(List<VisitGoodsListGoods> list, [bool clearTable = true]) async {
    await db._loadData(allVisitGoodsListGoods, list, clearTable);
  }

  Future<void> loadGoodsLists(List<GoodsList> list) async {
    await db._loadData(goodsLists, list);
  }

  Future<void> loadGoodsListGoods(List<GoodsListGoods> list) async {
    await db._loadData(allGoodsListGoods, list);
  }

  Future<void> loadRoutePoints(List<RoutePoint> list, [bool clearTable = true]) async {
    await db._loadData(routePoints, list, clearTable);
  }

  Future<void> loadVisits(List<Visit> list, [bool clearTable = true]) async {
    await db._loadData(visits, list, clearTable);
  }

  Stream<List<VisitImage>> watchVisitImages(String visitGuid) {
    return (select(visitImages)..where((tbl) => tbl.visitGuid.equals(visitGuid))).watch();
  }

  Stream<List<VisitGoodsList>> watchVisitGoodsList(String visitGuid) {
    return (select(visitGoodsLists)..where((tbl) => tbl.visitGuid.equals(visitGuid))).watch();
  }

  Stream<List<GoodsList>> watchGoodsLists() {
    return select(goodsLists).watch();
  }

  Selectable<VisitEx> visitExList() {
    final res = select(visits).join([
      innerJoin(buyers, buyers.id.equalsExp(visits.buyerId)),
      innerJoin(partners, partners.id.equalsExp(buyers.partnerId)),
      innerJoin(sites, sites.id.equalsExp(buyers.siteId))
    ])
    ..orderBy([OrderingTerm(expression: buyers.name)]);

    return res.map(
      (row) => VisitEx(
        row.readTable(visits),
        BuyerEx(
          row.readTable(buyers),
          row.readTable(partners),
          row.readTable(sites),
        )
      )
    );
  }

  Future<VisitEx> getVisitEx(String guid) async {
    return (await visitExList().get()).firstWhere((e) => e.visit.guid == guid);
  }

  Stream<List<VisitEx>> watchVisitExList() {
    return visitExList().watch();
  }

  Stream<List<RoutePointEx>> watchRoutePoints() {
    final res = select(routePoints).join([
      innerJoin(buyers, buyers.id.equalsExp(routePoints.buyerId)),
      innerJoin(partners, partners.id.equalsExp(buyers.partnerId)),
      innerJoin(sites, sites.id.equalsExp(buyers.siteId))
    ])
    ..orderBy([OrderingTerm(expression: buyers.name)]);

    return res.map(
      (row) => RoutePointEx(
        row.readTable(routePoints),
        BuyerEx(
          row.readTable(buyers),
          row.readTable(partners),
          row.readTable(sites),
        )
      )
    ).watch();
  }

  Stream<List<GoodsListVisitExResult>> watchGoodsListVisitEx(String guid) {
    return goodsListVisitEx(guid).watch();
  }
}

class RoutePointEx {
  final RoutePoint routePoint;
  final BuyerEx buyerEx;

  RoutePointEx(this.routePoint, this.buyerEx);
}

class VisitEx {
  final Visit visit;
  final BuyerEx buyerEx;

  VisitEx(this.visit, this.buyerEx);
}
