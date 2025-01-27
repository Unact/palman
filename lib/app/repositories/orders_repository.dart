import 'dart:io';
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/extensions/io_file_system.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class OrdersRepository extends BaseRepository {
  static const _kGoodsFileFolder = 'goods';
  static final _goodsCacheRepo = JsonCacheInfoRepository(databaseName: _kGoodsFileFolder);
  static CacheManager goodsCacheManager = CacheManager(
    Config(
      _kGoodsFileFolder,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 10000,
      repo: _goodsCacheRepo,
      fileSystem: IOFileSystem(_kGoodsFileFolder),
      fileService: HttpFileService(),
    ),
  );

  OrdersRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<void> loadBonusPrograms() async {
    try {
      final data = await api.getBonusPrograms();

      await dataStore.transaction(() async {
        final bonusProgramGroups = data.bonusProgramGroups.map((e) => e.toDatabaseEnt()).toList();
        final bonusPrograms = data.bonusPrograms.map((e) => e.toDatabaseEnt()).toList();
        final buyerSets = data.buyerSets.map((e) => e.toDatabaseEnt()).toList();
        final buyerSetBonusPrograms = data.buyerSetBonusPrograms.map((e) => e.toDatabaseEnt()).toList();
        final buyersSetsBuyers = data.buyersSetsBuyers.map((e) => e.toDatabaseEnt()).toList();
        final goodsBonusPrograms = data.goodsBonusPrograms.map((e) => e.toDatabaseEnt()).toList();
        final goodsBonusProgramPrices = data.goodsBonusProgramPrices.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.bonusProgramsDao.loadBonusProgramGroups(bonusProgramGroups);
        await dataStore.bonusProgramsDao.loadBonusPrograms(bonusPrograms);
        await dataStore.bonusProgramsDao.loadBuyersSets(buyerSets);
        await dataStore.bonusProgramsDao.loadBuyersSetsBonusPrograms(buyerSetBonusPrograms);
        await dataStore.bonusProgramsDao.loadBuyersSetsBuyers(buyersSetsBuyers);
        await dataStore.bonusProgramsDao.loadGoodsBonusPrograms(goodsBonusPrograms);
        await dataStore.bonusProgramsDao.loadGoodsBonusProgramPrices(goodsBonusProgramPrices);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> loadRemains() async {
    try {
      final data = await api.getRemains();

      await dataStore.transaction(() async {
        final goods = data.goods.map((e) => e.toDatabaseEnt()).toList();
        final goodsStocks = data.goodsStocks.map((e) => e.toDatabaseEnt()).toList();
        final goodsRestrictions = data.goodsRestrictions.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.ordersDao.loadGoods(goods);
        await dataStore.ordersDao.loadGoodsStocks(goodsStocks);
        await dataStore.ordersDao.loadGoodsRestrictions(goodsRestrictions);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> loadOrders() async {
    try {
      final data = await api.getOrders();

      await dataStore.transaction(() async {
        final orders = data.orders.map((e) => e.toDatabaseEnt()).toList();
        final orderLines = data.orders
          .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e).toList();
        final preOrders = data.preOrders.map((e) => e.toDatabaseEnt()).toList();
        final preOrderLines = data.preOrders
          .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e).toList();

        await dataStore.ordersDao.loadOrders(orders);
        await dataStore.ordersDao.loadOrderLines(orderLines);
        await dataStore.ordersDao.loadPreOrders(preOrders);
        await dataStore.ordersDao.loadPreOrderLines(preOrderLines);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<bool> preloadGoodsImages(Goods goods) async {
    if (await goodsCacheManager.getFileFromCache(goods.imageKey) != null) return true;

    try {
      await goodsCacheManager.downloadFile(goods.imageUrl, key: goods.imageKey, force: true);
    } on HttpException catch(e) {
      throw AppError('Ошибка загрузки: ${e.message}');
    } on ClientException catch(e) {
      throw AppError('Ошибка загрузки: ${e.message}');
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }

    return true;
  }

  Future<void> syncOrders(List<Order> orders, List<OrderLine> orderLines) async {
    if (!(await Permissions.hasLocationPermissions())) throw AppError('Нет прав на получение местоположения');

    try {
      DateTime lastSyncTime = DateTime.now();
      List<Map<String, dynamic>> ordersData = orders.map((e) => {
        'guid': e.guid,
        'isNew': e.isNew,
        'isDeleted': e.isDeleted,
        'currentTimestamp': e.currentTimestamp.toIso8601String(),
        'timestamp': e.timestamp.toIso8601String(),
        'date': e.date?.toIso8601String(),
        'preOrderId': e.preOrderId,
        'needDocs': e.needDocs,
        'needInc': e.needInc,
        'isPhysical': e.isPhysical,
        'buyerId': e.buyerId,
        'info': e.info,
        'needProcessing': e.needProcessing,
        'lines': orderLines.where((i) => i.orderGuid == e.guid).map((i) => {
          'guid': i.guid,
          'isNew': i.isNew,
          'isDeleted': i.isDeleted,
          'currentTimestamp': i.currentTimestamp.toIso8601String(),
          'timestamp': i.timestamp.toIso8601String(),
          'goodsId': i.goodsId,
          'vol': i.vol,
          'price': i.price,
          'priceOriginal': i.priceOriginal,
          'package': i.package,
          'rel': i.rel
        }).toList()
      }).toList();

      final data = await api.saveOrders(ordersData);
      final apiOrders = data.orders.map((e) => e.toDatabaseEnt()).toList();
      final apiOrderLines = data.orders
        .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.guid))).expand((e) => e).toList();
      await dataStore.transaction(() async {
        for (var order in orders) {
          await dataStore.ordersDao.updateOrder(
            order.guid,
            OrdersCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }
        for (var orderLine in orderLines) {
          await dataStore.ordersDao.updateOrderLine(
            orderLine.guid,
            OrderLinesCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }

        await dataStore.ordersDao.loadOrders(apiOrders, false);
        await dataStore.ordersDao.loadOrderLines(apiOrderLines, false);
      });
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final orders = await dataStore.ordersDao.getOrdersForSync();
    final orderLines = await dataStore.ordersDao.getOrderLinesForSync();

    if (orders.isEmpty) return;

    await syncOrders(orders, orderLines);
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
    return dataStore.ordersDao.getGoods(
      name: name,
      extraLabel: extraLabel,
      categoryId: categoryId,
      bonusProgramId: bonusProgramId,
      goodsIds: goodsIds,
      onlyLatest: onlyLatest,
      onlyForPhysical: onlyForPhysical,
      onlyWithoutDocs: onlyWithoutDocs
    );
  }

  Stream<List<GoodsFilter>> watchGoodsFilters() {
    return dataStore.ordersDao.watchGoodsFilters();
  }

  Stream<List<ShopDepartment>> watchShopDepartments() {
    return dataStore.ordersDao.watchShopDepartments();
  }

  Future<List<CategoriesExResult>> getCategories({required int buyerId}) {
    return dataStore.ordersDao.getCategories(buyerId: buyerId);
  }

  Future<List<Goods>> getOrderableGoodsWithImage() async {
    return dataStore.ordersDao.getOrderableGoodsWithImage();
  }

  Stream<List<BonusProgramGroup>> watchBonusProgramGroups({
    required int buyerId,
    required DateTime date
  }) {
    return dataStore.bonusProgramsDao.watchBonusProgramGroups(
      buyerId: buyerId,
      date: date
    );
  }

  Stream<List<GoodsShipmentsResult>> watchGoodsShipments({
    required int buyerId,
    required int goodsId
  }) {
    return dataStore.shipmentsDao.watchGoodsShipments(
      buyerId: buyerId,
      goodsId: goodsId
    );
  }

  Future<List<FilteredBonusProgramsResult>> getBonusPrograms({
    required int buyerId,
    required DateTime date,
    required int? bonusProgramGroupId,
    required int? goodsId,
    required int? categoryId
  }) async {
    return dataStore.bonusProgramsDao.getBonusPrograms(
      buyerId: buyerId,
      date: date,
      bonusProgramGroupId: bonusProgramGroupId,
      goodsId: goodsId,
      categoryId: categoryId
    );
  }

  Stream<List<GoodsDetail>> watchGoodsDetails({
    required int buyerId,
    required DateTime date,
    required List<int> goodsIds
  }) {
    return dataStore.ordersDao.watchGoodsDetails(
      buyerId: buyerId,
      date: date,
      goodsIds: goodsIds
    );
  }

  Future<OrderExResult?> getOrderEx(String guid) async {
    return dataStore.ordersDao.getOrderEx(guid);
  }

  Future<List<OrderLineExResult>> getOrderLineExList(String orderGuid) async {
    return dataStore.ordersDao.getOrderLineExList(orderGuid);
  }

  Stream<List<OrderExResult>> watchOrderExList() {
    return dataStore.ordersDao.watchOrderExList();
  }

  Stream<List<OrderLineExResult>> watchOrderLineExList(String orderGuid) {
    return dataStore.ordersDao.watchOrderLineExList(orderGuid);
  }

  Stream<List<PreOrderExResult>> watchPreOrderExList() {
    return dataStore.ordersDao.watchPreOrderExList();
  }

  Stream<List<PreOrderLineExResult>> watchPreOrderLineExList(int preOrderId) {
    return dataStore.ordersDao.watchPreOrderLineExList(preOrderId);
  }

  Future<void> addSeenPreOrder({
    required int id
  }) async {
    await dataStore.ordersDao.addSeenPreOrder(SeenPreOrdersCompanion(id: Value(id)));
  }

  Future<OrderExResult> addOrder({
    int? preOrderId,
    int? buyerId,
    DateTime? date,
    bool needProcessing = false,
    bool needDocs = false,
    bool isPhysical = false,
    bool needInc = false,
  }) async {
    final guid = dataStore.generateGuid();
    await dataStore.ordersDao.addOrder(
      OrdersCompanion.insert(
        guid: guid,
        status: OrderStatus.draft.value,
        needDocs: needDocs,
        isPhysical: isPhysical,
        needInc: needInc,
        preOrderId: Value(preOrderId),
        buyerId: Value(buyerId),
        date: Value(date),
        needProcessing: needProcessing,
        isEditable: true
      )
    );
    final orderEx = await dataStore.ordersDao.getOrderEx(guid);

    return orderEx;
  }

  Future<void> updateOrder(Order order, {
    Optional<String>? status,
    Optional<int?>? buyerId,
    Optional<DateTime?>? date,
    Optional<String?>? info,
    Optional<bool>? needDocs,
    Optional<bool>? needInc,
    Optional<bool>? isPhysical,
    Optional<bool>? needProcessing,
    bool restoreDeleted = true
  }) async {
    final updatedOrder = OrdersCompanion(
      status: status == null ? const Value.absent() : Value(status.value),
      buyerId: buyerId == null ? const Value.absent() : Value(buyerId.orNull),
      date: date == null ? const Value.absent() : Value(date.orNull),
      info: info == null ? const Value.absent() : Value(info.orNull),
      needDocs: needDocs == null ? const Value.absent() : Value(needDocs.value),
      needInc: needInc == null ? const Value.absent() : Value(needInc.value),
      isPhysical: isPhysical == null ? const Value.absent() : Value(isPhysical.value),
      needProcessing: needProcessing == null ? const Value.absent() : Value(needProcessing.value),
      isDeleted: restoreDeleted ? const Value(false) : const Value.absent()
    );

    await dataStore.ordersDao.updateOrder(order.guid, updatedOrder);
  }

  Future<void> deleteOrder(Order order) async {
    await dataStore.ordersDao.updateOrder(order.guid, const OrdersCompanion(isDeleted: Value(true)));
  }

  Future<void> addOrderLine(Order order, {
    required int goodsId,
    required double vol,
    required double price,
    required double priceOriginal,
    required int package,
    required int rel
  }) async {
    final guid = dataStore.generateGuid();
    await dataStore.ordersDao.addOrderLine(
      OrderLinesCompanion.insert(
        guid: guid,
        orderGuid: order.guid,
        goodsId: goodsId,
        vol: vol,
        price: price,
        priceOriginal: priceOriginal,
        rel: rel,
        package: package
      )
    );
  }

  Future<void> updateOrderLine(OrderLine orderLine, {
    Optional<int>? goodsId,
    Optional<double>? vol,
    Optional<double>? price,
    Optional<double>? priceOriginal,
    Optional<int>? package,
    Optional<int>? rel,
    bool restoreDeleted = true
  }) async {
    final updatedOrderLine = OrderLinesCompanion(
      goodsId: goodsId == null ? const Value.absent() : Value(goodsId.value),
      vol: vol == null ? const Value.absent() : Value(vol.value),
      price: price == null ? const Value.absent() : Value(price.value),
      priceOriginal: priceOriginal == null ? const Value.absent() : Value(priceOriginal.value),
      package: package == null ? const Value.absent() : Value(package.value),
      rel: rel == null ? const Value.absent() : Value(rel.value),
      isDeleted: restoreDeleted ? const Value(false) : const Value.absent()
    );

    await dataStore.ordersDao.updateOrderLine(orderLine.guid, updatedOrderLine);
  }

  Future<void> deleteOrderLine(OrderLine orderLine) async {
    await dataStore.ordersDao.updateOrderLine(orderLine.guid, const OrderLinesCompanion(isDeleted: Value(true)));
  }

  Future<OrderExResult> createOrderFromPreOrder(PreOrder preOrder, List<PreOrderLine> preOrderLines) async {
    final orderEx = await dataStore.transaction(() async {
      final guid = dataStore.generateGuid();
      await dataStore.ordersDao.addOrder(OrdersCompanion.insert(
        guid: guid,
        status: OrderStatus.draft.value,
        preOrderId: Value(preOrder.id),
        buyerId: Value(preOrder.buyerId),
        date: Value(preOrder.date),
        needDocs: preOrder.needDocs,
        isPhysical: false,
        needInc: false,
        needProcessing: false,
        isEditable: true
      ));
      final goodsDetails = await dataStore.ordersDao.getGoodsDetails(
        buyerId: preOrder.buyerId,
        date: preOrder.date,
        goodsIds: preOrderLines.map((e) => e.goodsId).toList()
      );

      for (var preOrderLine in preOrderLines) {
        final goodsDetail = goodsDetails.firstWhereOrNull((e) => e.goods.id == preOrderLine.goodsId);

        if (goodsDetail == null) continue;

        final lineGuid = dataStore.generateGuid();
        await dataStore.ordersDao.addOrderLine(OrderLinesCompanion.insert(
          guid: lineGuid,
          orderGuid: guid,
          goodsId: preOrderLine.goodsId,
          vol: preOrderLine.vol * preOrderLine.rel / goodsDetail.rel,
          price: goodsDetail.price,
          priceOriginal: goodsDetail.pricelistPrice,
          package: goodsDetail.package,
          rel: goodsDetail.rel
        ));
      }

      return await dataStore.ordersDao.getOrderEx(guid);
    });

    return orderEx;
  }

  Future<OrderExResult> copyOrder(Order order, List<OrderLine> orderLines) async {
    final orderEx = await dataStore.transaction(() async {
      final guid = dataStore.generateGuid();
      await dataStore.ordersDao.addOrder(order.toCompanion(false).copyWith(
        id: const Value.absent(),
        guid: Value(guid),
        timestamp: const Value.absent(),
        currentTimestamp: const Value.absent(),
        lastSyncTime: const Value.absent()
      ));
      for (var orderLine in orderLines) {
        final lineGuid = dataStore.generateGuid();
        await dataStore.ordersDao.addOrderLine(orderLine.toCompanion(false).copyWith(
          orderGuid: Value(guid),
          id: const Value.absent(),
          guid: Value(lineGuid),
          timestamp: const Value.absent(),
          currentTimestamp: const Value.absent(),
          lastSyncTime: const Value.absent()
        ));
      }

      return await dataStore.ordersDao.getOrderEx(guid);
    });

    return orderEx;
  }

  Future<void> updateOrderLinePrices(Order order) async {
    await dataStore.transaction(() async {
      final orderLinesEx = await dataStore.ordersDao.getOrderLineExList(order.guid);
      final goodsDetails = await dataStore.ordersDao.getGoodsDetails(
        buyerId: order.buyerId!,
        date: order.date!,
        goodsIds: orderLinesEx.map((e) => e.line.goodsId).toList()
      );

      for (var orderLine in orderLinesEx) {
        final line = orderLine.line;
        final goodsDetail = goodsDetails.firstWhereOrNull((e) => e.goods.id == orderLine.line.goodsId);

        if (goodsDetail == null) continue;
        if (line.price == goodsDetail.price && line.priceOriginal == goodsDetail.pricelistPrice) continue;

        await dataStore.ordersDao.updateOrderLine(
          line.guid,
          OrderLinesCompanion(
            price: Value(goodsDetail.price),
            priceOriginal: Value(goodsDetail.pricelistPrice)
          )
        );
      }
    });
  }

  Future<void> clearFiles([Set<String> newKeys = const <String>{}]) async {
    final cacheObjects = await _goodsCacheRepo.getAllObjects();
    final oldCacheObjects = cacheObjects.where((e) => !newKeys.contains(e.key));

    for (var oldCacheObject in oldCacheObjects) {
      try {
        await goodsCacheManager.removeFile(oldCacheObject.key);
      } on PathNotFoundException {
        continue;
      }
    }
  }

  Future<void> regenerateGuid() async {
    await dataStore.ordersDao.regenerateOrdersGuid();
    await dataStore.ordersDao.regenerateOrderLinesGuid();
  }
}
