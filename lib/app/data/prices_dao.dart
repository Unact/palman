part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    AllGoods,
    Pricelists,
    PricelistSetCategories,
    PartnersPrices,
    PricelistPrices,
    PartnersPricelists,
    GoodsPartnersPricelists
  ],
  queries: {
    'goodsPrices': '''
        SELECT goods_id, MIN(price) AS "price"
        FROM (
          SELECT prices.goods_id, prices.disc * pricelist_prices.price price
          FROM (
            SELECT
              goods_partners_pricelists.goods_id,
              goods_partners_pricelists.pricelist_id,
              (100 + goods_partners_pricelists.discount)/100 * (1 - partners_pricelists.discount/100.0) disc
            FROM partners_pricelists
            JOIN buyers ON buyers.partner_id = partners_pricelists.partner_id
            JOIN goods_partners_pricelists ON
              goods_partners_pricelists.partner_pricelist_id = partners_pricelists.pricelist_id
            JOIN goods on goods.id = goods_partners_pricelists.goods_id
            WHERE
              buyers.id = :buyer_id AND
              goods_partners_pricelists.goods_id IN :goods_ids AND
              (
                EXISTS(
                  SELECT 1
                  FROM pricelist_set_categories
                  WHERE
                    pricelist_set_categories.pricelist_set_id = partners_pricelists.pricelist_set_id AND
                    pricelist_set_categories.category_id = goods.category_id
                ) OR NOT EXISTS(
                  SELECT 1
                  FROM pricelist_set_categories
                  WHERE pricelist_set_categories.pricelist_set_id = partners_pricelists.pricelist_set_id
                )
              )
          ) prices
          JOIN pricelist_prices ON
            pricelist_prices.pricelist_id = prices.pricelist_id AND
            pricelist_prices.goods_id = prices.goods_id AND
            :date BETWEEN pricelist_prices.date_from and pricelist_prices.date_to
          WHERE NOT EXISTS(
            SELECT 1
            FROM partners_prices
            JOIN buyers ON buyers.partner_id = partners_prices.partner_id
            WHERE
              partners_prices.goods_id IN :goods_ids AND
              buyers.id = :buyer_id AND
              :date BETWEEN partners_prices.date_from AND partners_prices.date_to AND
              partners_prices.goods_id = pricelist_prices.goods_id
          )
          UNION ALL
          SELECT partners_prices.goods_id, partners_prices.price
          FROM partners_prices
          JOIN buyers ON buyers.partner_id = partners_prices.partner_id
          WHERE
            partners_prices.goods_id IN :goods_ids AND
            buyers.id = :buyer_id AND
            :date BETWEEN partners_prices.date_from AND partners_prices.date_to
      )
      GROUP BY goods_id
    ''',
    'goodsPricelists': '''
      SELECT
        pricelists.id,
        pricelists.name,
        pricelists.permit,
        (100 + goods_partners_pricelists.discount)/100 * pricelist_prices.price AS "price"
      FROM pricelists
      JOIN goods_partners_pricelists ON
        goods_partners_pricelists.partner_pricelist_id = pricelists.id AND
        goods_partners_pricelists.goods_id = pricelist_prices.goods_id
      JOIN pricelist_prices ON goods_partners_pricelists.pricelist_id = pricelist_prices.pricelist_id
      WHERE
        :date BETWEEN pricelist_prices.date_from AND pricelist_prices.date_to AND
        goods_partners_pricelists.goods_id = :goods_id
      ORDER BY price, pricelists.name
    '''
  }
)
class PricesDao extends DatabaseAccessor<AppDataStore> with _$PricesDaoMixin {
  PricesDao(AppDataStore db) : super(db);

  Future<void> regeneratePartnersPricesGuid() async {
    await db._regenerateGuid(partnersPrices);
  }

  Future<void> regeneratePartnersPricelistsGuid() async {
    await db._regenerateGuid(partnersPricelists);
  }

  Future<void> loadPricelists(List<Pricelist> list) async {
    await db._loadData(pricelists, list);
  }

  Future<void> loadPricelistSetCategories(List<PricelistSetCategory> list) async {
    await db._loadData(pricelistSetCategories, list);
  }

  Future<void> loadPartnersPrices(List<PartnersPrice> list) async {
    await db._loadData(partnersPrices, list);
  }

  Future<void> loadPricelistPrices(List<PricelistPrice> list) async {
    await db._loadData(pricelistPrices, list);
  }

  Future<void> loadPartnersPricelists(List<PartnersPricelist> list) async {
    await db._loadData(partnersPricelists, list);
  }

  Future<void> loadGoodsPartnersPricelists(List<GoodsPartnersPricelist> list) async {
    await db._loadData(goodsPartnersPricelists, list);
  }

  Future<void> updatePartnersPricelist(int id, PartnersPricelistsCompanion updatedPartnersPricelist) async {
    await (update(partnersPricelists)..where((tbl) => tbl.id.equals(id))).write(updatedPartnersPricelist);
  }

  Future<void> updatePartnersPrice(int id, PartnersPricesCompanion updatedPartnersPrice) async {
    await (update(partnersPrices)..where((tbl) => tbl.id.equals(id))).write(updatedPartnersPrice);
  }

  Future<int> addPartnersPrice(PartnersPricesCompanion newPartnersPrice) async {
    return await into(partnersPrices).insert(newPartnersPrice);
  }

  Future<int> addPartnersPricelist(PartnersPricelistsCompanion newPartnersPricelist) async {
    return await into(partnersPricelists).insert(newPartnersPricelist);
  }

  Future<List<PartnersPricelist>> getPartnersPricelistsForSync() async {
    return (select(partnersPricelists)..where((tbl) => tbl.needSync.equals(true))).get();
  }

  Future<List<PartnersPrice>> getPartnersPricesForSync() async {
    return (select(partnersPrices)..where((tbl) => tbl.needSync.equals(true))).get();
  }

  Stream<List<PartnersPricelist>> watchPartnersPricelists({
    required int partnerId,
    required int goodsId
  }) {
    final query = select(partnersPricelists)
      .join([
        innerJoin(allGoods, allGoods.pricelistSetId.equalsExp(partnersPricelists.pricelistSetId)),
      ])
      ..where(partnersPricelists.partnerId.equals(partnerId))
      ..where(allGoods.id.equals(goodsId));

    return query.map((lineRow) => lineRow.readTable(partnersPricelists)).watch();
  }

  Stream<List<PartnersPrice>> watchPartnersPrices({
    required int partnerId,
    required int goodsId
  }) {
    return (
      select(partnersPrices)
        ..where((tbl) => tbl.partnerId.equals(partnerId))
        ..where((tbl) => tbl.goodsId.equals(goodsId))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.dateTo, mode: OrderingMode.desc)])
    ).watch();
  }

  Stream<List<GoodsPricelistsResult>> watchGoodsPricelists({
    required int goodsId,
    required DateTime date
  }) {
    return goodsPricelists(date, goodsId).watch();
  }
}
