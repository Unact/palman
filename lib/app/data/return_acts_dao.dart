part of 'database.dart';

@DriftAccessor(
  tables: [
    Categories,
    Buyers,
    AllGoods,
    GoodsReturnStocks,
    ReturnActs,
    ReturnActLines,
    ReturnActTypes,
    PartnersReturnActTypes
  ],
  queries: {
    'returnActEx': '''
      SELECT
        return_acts.** AS "return_act",
        COALESCE(
          (SELECT name FROM return_act_types WHERE return_act_types.id = return_acts.return_act_type_id),
          'Не указан'
        ) AS "return_act_type_name",
        buyers.** AS "buyer",
        COALESCE(
          (
            SELECT SUM(return_act_lines.rel * return_act_lines.vol * return_act_lines.price)
            FROM return_act_lines
            WHERE return_act_lines.return_act_guid = return_acts.guid AND return_act_lines.is_deleted = 0
          ),
          0
        ) AS "lines_total",
        (
          SELECT COUNT(*)
          FROM return_act_lines
          WHERE return_act_lines.return_act_guid = return_acts.guid AND return_act_lines.is_deleted = 0
        ) AS "lines_count",
        COALESCE(
          (
            SELECT MAX(need_sync)
            FROM return_act_lines
            WHERE return_act_lines.return_act_guid = return_acts.guid
          ),
          0
        ) AS "lines_need_sync"
      FROM return_acts
      LEFT JOIN buyers on buyers.id = return_acts.buyer_id
      ORDER BY return_acts.date DESC, buyers.name
    ''',
    'returnActLineEx': '''
      SELECT
        return_act_lines.** AS "line",
        goods.name AS "goods_name"
      FROM return_act_lines
      JOIN goods ON goods.id = return_act_lines.goods_id
      WHERE return_act_lines.return_act_guid = :return_act_guid
      ORDER BY goods.name
    ''',
    'receptEx': '''
      SELECT
        goods_return_stocks.recept_id AS "id",
        goods_return_stocks.recept_date AS "date",
        goods_return_stocks.recept_ndoc AS "ndoc"
      FROM goods_return_stocks
      WHERE goods_return_stocks.buyer_id = :buyer_id and goods_return_stocks.return_act_type_id = :return_act_type_id
      GROUP BY recept_id, recept_date, recept_ndoc
      ORDER BY recept_ndoc, recept_date DESC
    '''
  }
)
class ReturnActsDao extends DatabaseAccessor<AppDataStore> with _$ReturnActsDaoMixin {
  ReturnActsDao(AppDataStore db) : super(db);

  Future<void> regenerateReturnActsGuid() async {
    await db._regenerateGuid(returnActs);
  }

  Future<void> regenerateReturnActLinesGuid() async {
    await db._regenerateGuid(returnActLines);
  }

  Future<void> loadReturnActTypes(List<ReturnActType> list) async {
    await db._loadData(returnActTypes, list);
  }

  Future<void> loadPartnersReturnActTypes(List<PartnersReturnActType> list) async {
    await db._loadData(partnersReturnActTypes, list);
  }

  Future<void> loadReturnActs(List<ReturnAct> list, [bool clearTable = true]) async {
    await db._loadData(returnActs, list, clearTable);
  }

  Future<void> loadReturnActLines(List<ReturnActLine> list, [bool clearTable = true]) async {
    await db._loadData(returnActLines, list, clearTable);
  }

  Future<void> loadGoodsReturnStocks(List<GoodsReturnStock> list, [bool clearTable = true]) async {
    await db._loadData(goodsReturnStocks, list, clearTable);
  }

  Future<void> deleteReturnAct(String guid) async {
    await (delete(returnActs)..where((tbl) => tbl.guid.equals(guid))).go();
  }

  Future<void> deleteReturnActReturnActLines(String returnActGuid) async {
    await (delete(returnActLines)..where((tbl) => tbl.returnActGuid.equals(returnActGuid))).go();
  }

  Future<void> updateReturnAct(String guid, ReturnActsCompanion updatedReturnAct) async {
    await (update(returnActs)..where((tbl) => tbl.guid.equals(guid))).write(updatedReturnAct);
  }

  Future<void> addReturnAct(ReturnActsCompanion newReturnAct) async {
    await into(returnActs).insert(newReturnAct);
  }

  Future<void> updateReturnActLine(String guid, ReturnActLinesCompanion updatedReturnActLine) async {
    await (update(returnActLines)..where((tbl) => tbl.guid.equals(guid))).write(updatedReturnActLine);
  }

  Future<int> addReturnActLine(ReturnActLinesCompanion newReturnActLine) async {
    return await into(returnActLines).insert(newReturnActLine);
  }

  Future<List<ReturnAct>> getReturnActsForSync() async {
    final hasReturnActLineToSync = existsQuery(
      select(returnActLines)
        ..where((tbl) => tbl.returnActGuid.equalsExp(returnActs.guid))
        ..where((tbl) => tbl.needSync.equals(true))
    );

    return (
      select(returnActs)
        ..where((tbl) => tbl.needSync.equals(true) | hasReturnActLineToSync)
    ).get();
  }

  Future<List<ReturnActLine>> getReturnActLinesForSync() async {
    final hasReturnActToSync = existsQuery(
      select(returnActs)
        ..where((tbl) => tbl.guid.equalsExp(returnActLines.returnActGuid))
        ..where((tbl) => tbl.needSync.equals(true) | returnActLines.needSync.equals(true))
    );

    return (select(returnActLines)..where((tbl) => hasReturnActToSync)).get();
  }

  Future<ReturnActExResult> getReturnActEx(String guid) async {
    return (await returnActEx().get()).firstWhere((e) => e.returnAct.guid == guid);
  }

  Stream<List<ReturnActExResult>> watchReturnActExList() {
    return returnActEx().watch();
  }

  Future<List<ReturnActLineExResult>> getReturnActLineExList(String returnActGuid) async {
    return returnActLineEx(returnActGuid).get();
  }

  Stream<List<ReturnActLineExResult>> watchReturnActLineExList(String returnActGuid) {
    return returnActLineEx(returnActGuid).watch();
  }

  Future<List<ReturnActType>> getReturnActTypes({required int buyerId}) {
    final query = select(returnActTypes, distinct: true)
      .join([
        innerJoin(partnersReturnActTypes, partnersReturnActTypes.returnActTypeId.equalsExp(returnActTypes.id)),
        innerJoin(buyers, buyers.partnerId.equalsExp(partnersReturnActTypes.partnerId)),
      ])
      ..where(buyers.id.equals(buyerId))
      ..orderBy([OrderingTerm(expression: returnActTypes.name)]);

    return query.map((lineRow) => lineRow.readTable(returnActTypes)).get();
  }

  Future<List<ReceptExResult>> getReceptExList({required int buyerId, required int returnActTypeId}) async {
    return receptEx(buyerId, returnActTypeId).get();
  }

  Stream<List<GoodsReturnDetail>> watchGoodsReturnDetails({
    required int returnActTypeId,
    required int buyerId,
    required List<int> goodsIds,
    int? receptId
  }) {
    final returnStocksStream = (
      select(goodsReturnStocks)
        ..where((tbl) => tbl.buyerId.equals(buyerId))
        ..where((tbl) => tbl.returnActTypeId.equals(returnActTypeId))
        ..where((tbl) => tbl.goodsId.isIn(goodsIds))
        ..where(receptId != null ? (tbl) => tbl.receptId.equals(receptId) : (tbl) => const Constant(true) )
    ).watch();
    final goodsExListStream = db.ordersDao.goodsEx(buyerId, goodsIds).watch();

    return Rx.combineLatest2(
      returnStocksStream,
      goodsExListStream,
      (
        List<GoodsReturnStock> returnStocks,
        List<GoodsExResult> goodsExList
      ) {
        final groupedReturnStocks = returnStocks
          .groupFoldBy<int, List<GoodsReturnStock>>((e) => e.goodsId, (acc, e) => (acc ?? [])..add(e));

        return goodsExList.map((e) {
          if (groupedReturnStocks[e.goods.id] == null) return null;

          return GoodsReturnDetail(e, groupedReturnStocks[e.goods.id]!);
        }).whereNotNull().toList();
      }
    );
  }

  Future<List<Goods>> getBuyerGoods({
    required int buyerId,
    required String? name,
    required String? extraLabel,
    required int? categoryId,
    required List<int>? goodsIds,
    required bool onlyLatest,
    required String? barcode
  }) async {
    final hasReturnStock = existsQuery(
      select(goodsReturnStocks)
        ..where((tbl) => tbl.goodsId.equalsExp(allGoods.id))
        ..where((tbl) => tbl.buyerId.equals(buyerId))
    );
    final query = select(allGoods)
      ..where((tbl) => tbl.name.containsCase(name ?? ''))
      ..where((tbl) => tbl.extraLabel.containsCase(extraLabel ?? ''))
      ..where((tbl) => tbl.barcodes.containsCase(barcode ?? ''))
      ..where(categoryId != null ? (tbl) => tbl.categoryId.equals(categoryId) : (tbl) => const Constant(true))
      ..where((tbl) => hasReturnStock)
      ..where(goodsIds != null ? (tbl) => tbl.id.isIn(goodsIds) : (tbl) => const Constant(true))
      ..where(onlyLatest ? (tbl) => tbl.isLatest.equals(true) : (tbl) => const Constant(true));

    return query.get();
  }
}

class GoodsReturnDetail {
  final GoodsExResult goodsEx;
  final List<GoodsReturnStock> returnStocks;

  GoodsReturnDetail(this.goodsEx, this.returnStocks);

  Goods get goods => goodsEx.goods;
  bool get hadShipment => goodsEx.lastShipmentDate != null;
}
