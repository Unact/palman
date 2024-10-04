part of 'database.dart';

@DriftAccessor(
  tables: [
    Buyers,
    AllGoods,
    Categories,
    ShopDepartments,
    GoodsFilters,
    Shipments,
    ShipmentLines,
    GoodsBonusPrograms,
    GoodsStocks,
    GoodsRestrictions,
    Orders,
    OrderLines,
    PreOrders,
    PreOrderLines,
    SeenPreOrders
  ],
  queries: {
    'orderEx': '''
      SELECT
        orders.** AS "order",
        buyers.** AS "buyer",
        COALESCE(
          (
            SELECT SUM(order_lines.rel * order_lines.vol * order_lines.price)
            FROM order_lines
            WHERE order_lines.order_guid = orders.guid AND order_lines.is_deleted = 0
          ),
          0
        ) AS "lines_total",
        (
          SELECT COUNT(*)
          FROM order_lines
          WHERE order_guid = orders.guid AND order_lines.is_deleted = 0
        ) AS "lines_count",
        COALESCE(
          (
            SELECT MAX(need_sync)
            FROM order_lines
            WHERE order_guid = orders.guid
          ),
          0
        ) AS "lines_need_sync"
      FROM orders
      LEFT JOIN buyers on buyers.id = orders.buyer_id
      ORDER BY orders.date DESC, buyers.name
    ''',
    'orderLineEx': '''
      SELECT
        order_lines.** AS "line",
        goods.name AS "goods_name"
      FROM order_lines
      JOIN goods ON goods.id = order_lines.goods_id
      WHERE order_lines.order_guid = :order_guid
      ORDER BY goods.name
    ''',
    'preOrderEx': '''
      SELECT
        pre_orders.** AS "pre_order",
        buyers.** AS "buyer",
        COALESCE(
          (
            SELECT SUM(pre_order_lines.rel * pre_order_lines.vol * pre_order_lines.price)
            FROM pre_order_lines
            WHERE pre_order_lines.pre_order_id = pre_orders.id
          ),
          0
        ) AS "lines_total",
        (SELECT COUNT(*) FROM pre_order_lines WHERE pre_order_id = pre_orders.id) AS "lines_count",
        EXISTS(SELECT 1 FROM orders WHERE pre_order_id = pre_orders.id) AS "has_order",
        EXISTS(SELECT 1 FROM seen_pre_orders WHERE id = pre_orders.id) AS "was_seen"
      FROM pre_orders
      JOIN buyers on buyers.id = pre_orders.buyer_id
      ORDER BY pre_orders.date DESC, buyers.name
    ''',
    'preOrderLineEx': '''
      SELECT
        pre_order_lines.** AS "line",
        goods.name AS "goods_name"
      FROM pre_order_lines
      JOIN goods ON goods.id = pre_order_lines.goods_id
      WHERE pre_order_lines.pre_order_id = :pre_order_id
      ORDER BY goods.name
    ''',
    'goodsEx': '''
      SELECT
        goods.**,
        goods_stocks.** AS "stock",
        EXISTS(
          SELECT 1
          FROM goods_restrictions
          WHERE goods_restrictions.goods_id = goods.id AND goods_restrictions.buyer_id = buyers.id
        ) AS "restricted",
        (
          SELECT MAX(shipments.date)
          FROM shipment_lines
          JOIN shipments ON shipments.id = shipment_lines.shipment_id
          WHERE
            shipment_lines.goods_id = goods.id AND
            shipments.buyer_id = buyers.id AND
            shipments.date < STRFTIME('%s', 'now', 'start of day')
        ) AS "last_shipment_date"
      FROM goods
      CROSS JOIN buyers
      LEFT JOIN goods_stocks ON goods_stocks.goods_id = goods.id AND goods_stocks.site_id = buyers.site_id
      WHERE
        buyers.id = :buyer_id AND
        goods.id IN :goods_ids
      ORDER BY goods.name
    ''',
    'categoriesEx': '''
      SELECT
        categories.** AS "category",
        (
          SELECT MAX(shipments.date)
          FROM shipment_lines
          JOIN shipments ON shipments.id = shipment_lines.shipment_id
          JOIN goods ON shipment_lines.goods_id = goods.id
          WHERE
            categories.id = goods.category_id AND
            shipments.buyer_id = :buyer_id AND
            shipments.date < STRFTIME('%s', 'now', 'start of day')
        ) AS "last_shipment_date"
      FROM categories
      ORDER BY categories.name
    '''
  }
)
class OrdersDao extends DatabaseAccessor<AppDataStore> with _$OrdersDaoMixin {
  OrdersDao(AppDataStore db) : super(db);

  Future<void> regenerateOrdersGuid() async {
    await db._regenerateGuid(orders);
  }

  Future<void> regenerateOrderLinesGuid() async {
    await db._regenerateGuid(orderLines);
  }

  Future<void> loadGoods(List<Goods> list) async {
    await db._loadData(allGoods, list);
  }

  Future<void> loadGoodsStocks(List<GoodsStock> list) async {
    await db._loadData(goodsStocks, list);
  }

  Future<void> loadGoodsRestrictions(List<GoodsRestriction> list) async {
    await db._loadData(goodsRestrictions, list);
  }

  Future<void> loadCategories(List<Category> list) async {
    await db._loadData(categories, list);
  }

  Future<void> loadShopDepartments(List<ShopDepartment> list) async {
    await db._loadData(shopDepartments, list);
  }

  Future<void> loadGoodsFilters(List<GoodsFilter> list) async {
    await db._loadData(goodsFilters, list);
  }

  Future<void> loadOrders(List<Order> list, [bool clearTable = true]) async {
    await db._loadData(orders, list, clearTable);
  }

  Future<void> loadOrderLines(List<OrderLine> list, [bool clearTable = true]) async {
    await db._loadData(orderLines, list, clearTable);
  }

  Future<void> loadPreOrders(List<PreOrder> list) async {
    await db._loadData(preOrders, list);
  }

  Future<void> loadPreOrderLines(List<PreOrderLine> list) async {
    await db._loadData(preOrderLines, list);
  }

  Future<void> updateOrder(String guid, OrdersCompanion updatedOrder) async {
    await (update(orders)..where((tbl) => tbl.guid.equals(guid))).write(updatedOrder);
  }

  Future<void> addOrder(OrdersCompanion newOrder) async {
    await into(orders).insert(newOrder);
  }

  Future<void> updateOrderLine(String guid, OrderLinesCompanion updatedOrderLine) async {
    await (update(orderLines)..where((tbl) => tbl.guid.equals(guid))).write(updatedOrderLine);
  }

  Future<int> addOrderLine(OrderLinesCompanion newOrderLine) async {
    return await into(orderLines).insert(newOrderLine);
  }

  Future<int> addSeenPreOrder(SeenPreOrdersCompanion newSeenPreOrder) async {
    return await into(seenPreOrders).insert(newSeenPreOrder);
  }

  Future<List<Order>> getOrdersForSync() async {
    final hasOrderLineToSync = existsQuery(
      select(orderLines)
        ..where((tbl) => tbl.orderGuid.equalsExp(orders.guid))
        ..where((tbl) => tbl.needSync.equals(true))
    );

    return (
      select(orders)
        ..where((tbl) => tbl.needSync.equals(true) | hasOrderLineToSync)
    ).get();
  }

  Future<List<OrderLine>> getOrderLinesForSync() async {
    final hasOrderToSync = existsQuery(
      select(orders)
        ..where((tbl) => tbl.guid.equalsExp(orderLines.orderGuid))
        ..where((tbl) => tbl.needSync.equals(true) | orderLines.needSync.equals(true))
    );

    return (select(orderLines)..where((tbl) => hasOrderToSync)).get();
  }

  Future<List<Goods>> getOrderableGoodsWithImage() async {
    return (
      select(allGoods)
        ..where((tbl) => tbl.isOrderable.equals(true))
        ..where((tbl) => tbl.imageUrl.equals('').not())
    ).get();
  }

  Future<List<Goods>> getGoods({
    required String? name,
    required String? extraLabel,
    required int? categoryId,
    required int? bonusProgramId,
    required List<int>? goodsIds,
    required bool onlyLatest,
    required bool onlyForPhysical,
    required bool onlyWithoutDocs
  }) async {
    final hasBonusProgram = existsQuery(
      select(goodsBonusPrograms)
        ..where((tbl) => tbl.goodsId.equalsExp(allGoods.id))
        ..where((tbl) => tbl.bonusProgramId.equalsNullable(bonusProgramId))
    );
    final hasStock = existsQuery(
      select(goodsStocks)
        ..where((tbl) => tbl.goodsId.equalsExp(allGoods.id))
    );
    final query = select(allGoods)
      ..where((tbl) => tbl.name.containsCase(name ?? ''))
      ..where((tbl) => tbl.extraLabel.containsCase(extraLabel ?? ''))
      ..where(categoryId != null ? (tbl) => tbl.categoryId.equals(categoryId) : (tbl) => const Constant(true))
      ..where(bonusProgramId != null ? (tbl) => hasBonusProgram : (tbl) => const Constant(true))
      ..where((tbl) => hasStock)
      ..where(goodsIds != null ? (tbl) => tbl.id.isIn(goodsIds) : (tbl) => const Constant(true))
      ..where(onlyLatest ? (tbl) => tbl.isLatest.equals(true) : (tbl) => const Constant(true))
      ..where(onlyForPhysical ? (tbl) => tbl.forPhysical.equals(true) : (tbl) => const Constant(true))
      ..where(onlyWithoutDocs ? (tbl) => tbl.onlyWithDocs.equals(false) : (tbl) => const Constant(true))
      ..where((tbl) => tbl.isOrderable.equals(true));

    return query.get();
  }

  Future<List<CategoriesExResult>> getCategories({required int buyerId}) {
    return categoriesEx(buyerId).get();
  }

  Stream<List<GoodsFilter>> watchGoodsFilters() {
    return (select(goodsFilters)..orderBy([(tbl) => OrderingTerm(expression: tbl.name)])).watch();
  }

  Stream<List<ShopDepartment>> watchShopDepartments() {
    return (
      select(shopDepartments)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.ord), (tbl) => OrderingTerm(expression: tbl.name)])
    ).watch();
  }

  Future<List<GoodsDetail>> getGoodsDetails({
    required int buyerId,
    required DateTime date,
    required List<int> goodsIds
  }) async {
    final goodsPrices = await db.pricesDao.goodsPrices(buyerId, goodsIds, date).get();
    final bonusPrograms = await db.bonusProgramsDao.filteredGoodsBonusPrograms(goodsIds, buyerId, date).get();
    final goodsExList = await goodsEx(buyerId, goodsIds).get();
    final groupedGoodsPrices = goodsPrices
      .groupFoldBy<int, List<GoodsPricesResult>>((e) => e.goodsId, (acc, e) => (acc ?? [])..add(e));
    final groupedBonusPrograms = bonusPrograms
      .groupFoldBy<int, List<FilteredGoodsBonusProgramsResult>>((e) => e.goodsId, (acc, e) => (acc ?? [])..add(e));

    return goodsExList.map((e) => GoodsDetail(
      e,
      groupedGoodsPrices[e.goods.id] ?? [],
      groupedBonusPrograms[e.goods.id] ?? []
    )).toList();
  }

  Stream<List<GoodsDetail>> watchGoodsDetails({
    required int buyerId,
    required DateTime date,
    required List<int> goodsIds
  }) {
    final goodsPricesStream = db.pricesDao.goodsPrices(buyerId, goodsIds, date).watch();
    final bonusProgramsStream = db.bonusProgramsDao.filteredGoodsBonusPrograms(goodsIds, buyerId, date).watch();
    final goodsExListStream = goodsEx(buyerId, goodsIds).watch();

    return Rx.combineLatest3(
      goodsPricesStream,
      bonusProgramsStream,
      goodsExListStream,
      (
        List<GoodsPricesResult> goodsPrices,
        List<FilteredGoodsBonusProgramsResult> bonusPrograms,
        List<GoodsExResult> goodsExList
      ) {
        final groupedGoodsPrices = goodsPrices
          .groupFoldBy<int, List<GoodsPricesResult>>((e) => e.goodsId, (acc, e) => (acc ?? [])..add(e));
        final groupedBonusPrograms = bonusPrograms
          .groupFoldBy<int, List<FilteredGoodsBonusProgramsResult>>((e) => e.goodsId, (acc, e) => (acc ?? [])..add(e));

        return goodsExList.map((e) => GoodsDetail(
          e,
          groupedGoodsPrices[e.goods.id] ?? [],
          groupedBonusPrograms[e.goods.id] ?? []
        )).toList();
      }
    );
  }

  Future<OrderExResult> getOrderEx(String guid) async {
    return (await orderEx().get()).firstWhere((e) => e.order.guid == guid);
  }

  Stream<List<OrderExResult>> watchOrderExList() {
    return orderEx().watch();
  }

  Future<List<OrderLineExResult>> getOrderLineExList(String orderGuid) async {
    return orderLineEx(orderGuid).get();
  }

  Stream<List<OrderLineExResult>> watchOrderLineExList(String orderGuid) {
    return orderLineEx(orderGuid).watch();
  }

  Stream<List<PreOrderExResult>> watchPreOrderExList() {
    return preOrderEx().watch();
  }

  Stream<List<PreOrderLineExResult>> watchPreOrderLineExList(int preOrderId) {
    return preOrderLineEx(preOrderId).watch();
  }
}

class GoodsDetail {
  final GoodsExResult goodsEx;
  final List<GoodsPricesResult> prices;
  final List<FilteredGoodsBonusProgramsResult> bonusPrograms;

  GoodsDetail(this.goodsEx, this.prices, this.bonusPrograms);

  bool get hadShipment => goodsEx.lastShipmentDate != null;
  Goods get goods => goodsEx.goods;
  int get minVol => goodsEx.stock?.minVol ?? 1;
  bool? get isVollow => goodsEx.stock?.isVollow;
  int get stockVol => (goodsEx.stock?.vol ?? 0)~/goods.orderRel;
  bool get conditionalDiscount => bonusPrograms.any((e) => e.conditionalDiscount);
  int get rel => goods.orderRel;
  int get package => goods.orderPackage;
  double get pricelistPrice => (prices.firstWhereOrNull((e) => e.goodsId == goods.id)?.price ?? 0).roundDigits(2);
  double get price {
    final goodsBonusPrograms = bonusPrograms.where((e) => e.goodsId == goods.id).toList();

    if (pricelistPrice == 0) return 0;

    double? totalDiscount = goodsBonusPrograms.isNotEmpty ?
      goodsBonusPrograms.fold<double>(0, (acc, e) => (e.discount ?? 0) + acc) :
      null;
    double? minCoef = goodsBonusPrograms.map((e) => e.coef ?? 0).minOrNull;
    double bonusPrice =
      goodsBonusPrograms.where((e) => e.goodsPrice != null).map((e) => e.goodsPrice!).maxOrNull ??
      [
        (totalDiscount != null ? (1 - totalDiscount / 100) * pricelistPrice : null),
        (minCoef != null ? minCoef * goods.cost : null)
      ].whereNotNull().maxOrNull ??
      pricelistPrice;

    return bonusPrice.roundDigits(2);
  }
}
