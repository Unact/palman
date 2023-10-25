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
        categories.package AS "categoryPackage",
        categories.user_package AS "categoryUserPackage",
        normal_stocks.** AS "normal_stock",
        fridge_stocks.** AS "fridge_stock",
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
        ) AS "last_shipment_date",
        (
          SELECT MAX(shipment_lines.price)
          FROM shipment_lines
          JOIN shipments ON shipments.id = shipment_lines.shipment_id
          JOIN (
            SELECT MAX(shipments.date) last_shipment_date, shipments.buyer_id
            FROM shipments
            GROUP BY shipments.buyer_id
          ) sm ON sm.last_shipment_date = shipments.date AND sm.buyer_id = shipments.buyer_id
          WHERE
            shipment_lines.goods_id = goods.id AND
            shipments.buyer_id = buyers.id AND
            shipments.date < STRFTIME('%s', 'now', 'start of day')
        ) AS "last_price"
      FROM goods
      JOIN categories ON categories.id = goods.category_id
      CROSS JOIN buyers
      LEFT JOIN goods_stocks normal_stocks ON
        normal_stocks.goods_id = goods.id AND normal_stocks.site_id = buyers.site_id
      LEFT JOIN goods_stocks fridge_stocks ON
        fridge_stocks.goods_id = goods.id AND fridge_stocks.site_id = buyers.fridge_site_id
      WHERE
        buyers.id = :buyer_id AND
        goods.id IN :goods_ids
      ORDER BY goods.name
    ''',
    'categoriesEx': '''
      SELECT
        categories.*,
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
      WHERE EXISTS(SELECT 1 FROM goods WHERE goods.category_id = categories.id)
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
    required bool onlyLatest
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
      ..where((tbl) => tbl.isOrderable.equals(true));

    return query.get();
  }

  Stream<List<CategoriesExResult>> watchCategories({required int buyerId}) {
    return categoriesEx(buyerId).watch();
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
    final bonusPrograms = await db.bonusProgramsDao.filteredGoodsBonusPrograms(buyerId, goodsIds, date).get();
    final goodsExList = await goodsEx(buyerId, goodsIds).get();

    return goodsExList.map((e) => GoodsDetail(
      e,
      goodsPrices.where((gp) => gp.goodsId == e.goods.id).toList(),
      bonusPrograms.where((gp) => gp.goodsId == e.goods.id).toList()
    )).toList();
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
  GoodsStock? get stock => goods.isFridge ? goodsEx.fridgeStock : goodsEx.normalStock;
  double get factor => stock?.factor ?? 1;
  bool get conditionalDiscount => bonusPrograms.any((e) => e.conditionalDiscount);
  int get rel => factor < goods.rel ? goods.categoryUserPackageRel : goods.rel;
  int get stockRel => factor~/rel;
  int get package => factor < goods.rel ? goodsEx.categoryUserPackage : goods.package;
  double get pricelistPrice => (prices.firstWhereOrNull((e) => e.goodsId == goods.id)?.price ?? 0).roundDigits(2);
  double get price {
    final goodsBonusPrograms = bonusPrograms.where((e) => e.goodsId == goods.id).toList();

    if (pricelistPrice == 0) return 0;

    int? totalDiscount = goodsBonusPrograms.isNotEmpty ?
      goodsBonusPrograms.fold<int>(0, (acc, e) => (e.discountPercent ?? 0) + acc) :
      null;
    double? maxCoef = goodsBonusPrograms.map((e) => e.coef ?? 0).maxOrNull;
    double bonusPrice =
      goodsBonusPrograms.where((e) => e.goodsPrice != null).map((e) => e.goodsPrice!).maxOrNull ??
      [
        (totalDiscount != null ? (1 - totalDiscount / 100) * pricelistPrice : null),
        (maxCoef != null ? maxCoef * goods.cost : null)
      ].whereNotNull().maxOrNull ??
      pricelistPrice;

    return bonusPrice.roundDigits(2);
  }
}
