part of 'database.dart';

@DriftAccessor(
  tables: [
    AllGoods,
    BonusProgramGroups,
    BonusPrograms,
    BuyersSets,
    BuyersSetsBonusPrograms,
    BuyersSetsBuyers,
    GoodsBonusPrograms,
    GoodsBonusProgramPrices,
  ],
  queries: {
    'filteredBonusPrograms': '''
      SELECT DISTINCT bonus_programs.id, bonus_programs.name, bonus_programs.condition, bonus_programs.present
      FROM bonus_programs
      JOIN buyers_sets_bonus_programs ON buyers_sets_bonus_programs.bonus_program_id = bonus_programs.id
      JOIN buyers_sets_buyers ON buyers_sets_buyers.buyers_set_id = buyers_sets_bonus_programs.buyers_set_id
      JOIN buyers_sets ON buyers_sets.id = buyers_sets_buyers.buyers_set_id
      JOIN goods_bonus_programs ON goods_bonus_programs.bonus_program_id = bonus_programs.id
      JOIN goods ON goods.id = goods_bonus_programs.goods_id
      WHERE
        (:bonus_program_group_id = bonus_programs.bonus_program_group_id OR :bonus_program_group_id IS NULL) AND
        (:goods_id = goods_bonus_programs.goods_id OR :goods_id IS NULL) AND
        (:category_id = goods.category_id OR :category_id IS NULL) AND
        (buyers_sets.is_for_all = 1 OR buyers_sets_buyers.buyer_id = :buyer_id) AND
        :date between bonus_programs.date_from and bonus_programs.date_to
      ORDER BY bonus_programs.name
    ''',
    'filteredGoodsBonusPrograms': '''
      SELECT
        CAST(
          COALESCE(
            MAX(CASE WHEN bonus_programs.discount_percent > 0 THEN bonus_programs.conditional_discount ELSE 0 END),
            0
          ) AS BOOLEAN
        ) AS "conditional_discount",
        (
          SELECT MAX(goods_bonus_program_prices.price)
          FROM goods_bonus_program_prices
          WHERE
            goods_bonus_program_prices.bonus_program_id = bonus_programs.id AND
            goods_bonus_program_prices.goods_id = goods_bonus_programs.goods_id
        ) AS "goods_price",
        MAX(bonus_programs.discount_percent) AS "discount_percent",
        MAX(bonus_programs.coef) AS "coef",
        bonus_programs.tag_text,
        goods_bonus_programs.goods_id
      FROM bonus_programs
      JOIN goods_bonus_programs ON goods_bonus_programs.bonus_program_id = bonus_programs.id
      WHERE
        goods_bonus_programs.goods_id IN :goods_ids AND
        goods_bonus_programs.bonus_program_id IN (
          SELECT DISTINCT bonus_programs.id
          FROM bonus_programs
          JOIN buyers_sets_bonus_programs ON buyers_sets_bonus_programs.bonus_program_id = bonus_programs.id
          JOIN buyers_sets_buyers ON buyers_sets_buyers.buyers_set_id = buyers_sets_bonus_programs.buyers_set_id
          JOIN buyers_sets ON buyers_sets.id = buyers_sets_buyers.buyers_set_id
          WHERE
            (buyers_sets.is_for_all = 1 OR buyers_sets_buyers.buyer_id = :buyer_id) AND
            :date between bonus_programs.date_from and bonus_programs.date_to
        )
      GROUP BY goods_bonus_programs.bonus_program_id, goods_bonus_programs.goods_id, bonus_programs.tag_text
    '''
  }
)
class BonusProgramsDao extends DatabaseAccessor<AppDataStore> with _$BonusProgramsDaoMixin {
  BonusProgramsDao(AppDataStore db) : super(db);

  Future<void> loadBonusProgramGroups(List<BonusProgramGroup> list) async {
    await db._loadData(bonusProgramGroups, list);
  }

  Future<void> loadBonusPrograms(List<BonusProgram> list) async {
    await db._loadData(bonusPrograms, list);
  }

  Future<void> loadBuyersSets(List<BuyersSet> list) async {
    await db._loadData(buyersSets, list);
  }

  Future<void> loadBuyersSetsBonusPrograms(List<BuyersSetsBonusProgram> list) async {
    await db._loadData(buyersSetsBonusPrograms, list);
  }

  Future<void> loadBuyersSetsBuyers(List<BuyersSetsBuyer> list) async {
    await db._loadData(buyersSetsBuyers, list);
  }

  Future<void> loadGoodsBonusPrograms(List<GoodsBonusProgram> list) async {
    await db._loadData(goodsBonusPrograms, list);
  }

  Future<void> loadGoodsBonusProgramPrices(List<GoodsBonusProgramPrice> list) async {
    await db._loadData(goodsBonusProgramPrices, list);
  }

  Stream<List<BonusProgramGroup>> watchBonusProgramGroups({
    required int buyerId,
    required DateTime date
  }) {
    final hasBonusProgram = existsQuery(
      select(bonusPrograms)
        .join([
          innerJoin(buyersSetsBonusPrograms, buyersSetsBonusPrograms.bonusProgramId.equalsExp(bonusPrograms.id)),
          innerJoin(buyersSetsBuyers, buyersSetsBuyers.buyersSetId.equalsExp(buyersSetsBonusPrograms.buyersSetId)),
          innerJoin(buyersSets, buyersSets.id.equalsExp(buyersSetsBuyers.buyersSetId)),
        ])
        ..where(bonusPrograms.bonusProgramGroupId.equalsExp(bonusProgramGroups.id))
        ..where(buyersSetsBuyers.buyerId.equals(buyerId))
        ..where(bonusPrograms.dateFrom.isSmallerOrEqualValue(date))
        ..where(bonusPrograms.dateTo.isBiggerOrEqualValue(date))
    );

    return (
      select(bonusProgramGroups)
        ..where((tbl) => hasBonusProgram)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)])
    ).watch();
  }

  Future<List<FilteredBonusProgramsResult>> getBonusPrograms({
    required int buyerId,
    required DateTime date,
    required int? bonusProgramGroupId,
    required int? goodsId,
    required int? categoryId
  }) async {
    return filteredBonusPrograms(
      bonusProgramGroupId?.toString(),
      goodsId?.toString(),
      categoryId?.toString(),
      buyerId,
      date
    ).get();
  }
}
