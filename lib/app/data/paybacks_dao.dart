part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    Paybacks,
    GoodsPaybacks
  ],
  queries: {
    'filteredGoodsPaybacks': '''
      SELECT
        paybacks.percent,
        goods_paybacks.goods_id
      FROM paybacks
      JOIN buyers ON buyers.partner_id = paybacks.partner_id
      JOIN goods_paybacks ON goods_paybacks.payback_id = paybacks.id
      WHERE
        goods_paybacks.goods_id IN :goods_ids AND
        buyers.id = :buyer_id AND
        :date between paybacks.date_from and paybacks.date_to
    '''
  }
)
class PaybacksDao extends DatabaseAccessor<AppDataStore> with _$PaybacksDaoMixin {
  PaybacksDao(super.db);

  Future<void> loadPaybacks(List<Payback> list) async {
    await db._loadData(paybacks, list);
  }

  Future<void> loadGoodsPaybacks(List<GoodsPayback> list) async {
    await db._loadData(goodsPaybacks, list);
  }
}
