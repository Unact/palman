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
      notifyListeners();
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
      notifyListeners();
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
        final orderLines = data.orders.map((e) => e.lines.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e).toList();
        final preOrders = data.preOrders.map((e) => e.toDatabaseEnt()).toList();
        final preOrderLines = data.preOrders
          .map((e) => e.lines.map((i) => i.toDatabaseEnt(e.id))).expand((e) => e).toList();

        await dataStore.ordersDao.loadOrders(orders);
        await dataStore.ordersDao.loadOrderLines(orderLines);
        await dataStore.ordersDao.loadPreOrders(preOrders);
        await dataStore.ordersDao.loadPreOrderLines(preOrderLines);
      });
      notifyListeners();
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
      await goodsCacheManager.downloadFile(goods.imageUrl, key: goods.imageKey);
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

  Future<void> blockOrders(bool block, {List<int>? ids}) async {
    await dataStore.ordersDao.blockOrders(block, ids: ids);
    notifyListeners();
  }

  Future<List<OrderExResult>> syncOrders(List<Order> orders, List<OrderLine> orderLines) async {
    try {
      List<Map<String, dynamic>> ordersData = orders.map((e) => {
        'guid': e.guid,
        'timestamp': e.timestamp.toIso8601String(),
        'isDeleted': e.isDeleted,
        'date': e.date?.toIso8601String(),
        'preOrderId': e.preOrderId,
        'needDocs': e.needDocs,
        'needInc': e.needInc,
        'isBonus': e.isBonus,
        'isPhysical': e.isPhysical,
        'buyerId': e.buyerId,
        'info': e.info,
        'needProcessing': e.needProcessing,
        'lines': orderLines.where((i) => i.orderId == e.id && i.needSync).map((i) => {
          'guid': i.guid,
          'timestamp': i.timestamp.toIso8601String(),
          'isDeleted': i.isDeleted,
          'goodsId': i.goodsId,
          'vol': i.vol,
          'price': i.price,
          'priceOriginal': i.priceOriginal,
          'package': i.package,
          'rel': i.rel
        }).toList()
      }).toList();

      final data = await api.saveOrders(ordersData);
      final ids = [];
      await dataStore.transaction(() async {
        for (var order in orders) {
          await dataStore.ordersDao.deleteOrder(order.id);
        }
        for (var orderLine in orderLines) {
          await dataStore.ordersDao.deleteOrderLine(orderLine.id);
        }
        for (var apiOrder in data.orders) {
          final ordersCompanion = apiOrder.toDatabaseEnt().toCompanion(false).copyWith(id: const Value.absent());
          final id = await dataStore.ordersDao.addOrder(ordersCompanion);
          final apiOrderLines = apiOrder.lines.map((i) => i.toDatabaseEnt(id)).toList();

          for (var apiOrderLine in apiOrderLines) {
            final orderLinesCompanion = apiOrderLine.toCompanion(false).copyWith(
              id: const Value.absent(),
              orderId: Value(id)
            );
            await dataStore.ordersDao.addOrderLine(orderLinesCompanion);
          }
          ids.add(id);
        }
      });
      notifyListeners();

      return (await dataStore.ordersDao.getOrderExList()).where((e) => ids.contains(e.order.id)).toList();
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

    try {
      await blockOrders(true);
      await syncOrders(orders, orderLines);
    } finally {
      await blockOrders(false);
    }
  }

  Future<List<Goods>> getGoods({
    required String? name,
    required String? extraLabel,
    required int? categoryId,
    required int? bonusProgramId,
    required List<int>? goodsIds,
  }) async {
    return dataStore.ordersDao.getGoods(
      name: name,
      extraLabel: extraLabel,
      categoryId: categoryId,
      bonusProgramId: bonusProgramId,
      goodsIds: goodsIds,
    );
  }

  Future<List<GoodsFilter>> getGoodsFilters() async {
    return dataStore.ordersDao.getGoodsFilters();
  }

  Future<List<ShopDepartment>> getShopDepartments() async {
    return dataStore.ordersDao.getShopDepartments();
  }

  Future<List<CategoriesExResult>> getCategories({required int buyerId}) async {
    return dataStore.ordersDao.getCategories(buyerId: buyerId);
  }

  Future<List<Goods>> getAllGoodsWithImage() async {
    return dataStore.ordersDao.getAllGoodsWithImage();
  }

  Future<List<BonusProgramGroup>> getBonusProgramGroups({
    required int buyerId
  }) async {
    return dataStore.bonusProgramsDao.getBonusProgramGroups(
      buyerId: buyerId
    );
  }

  Future<List<GoodsShipmentsResult>> getGoodsShipments({
    required int buyerId,
    required int goodsId
  }) async {
    return dataStore.shipmentsDao.getGoodsShipments(
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

  Future<List<GoodsDetail>> getGoodsDetails({
    required int buyerId,
    required DateTime date,
    required List<int> goodsIds
  }) async {
    return dataStore.ordersDao.getGoodsDetails(
      buyerId: buyerId,
      date: date,
      goodsIds: goodsIds
    );
  }

  Future<OrderExResult?> getOrderEx(int orderId) async {
    return dataStore.ordersDao.getOrderEx(orderId);
  }

  Future<List<OrderExResult>> getOrderExList() async {
    return dataStore.ordersDao.getOrderExList();
  }

  Future<List<OrderLineEx>> getOrderLineExList(int orderId) async {
    return dataStore.ordersDao.getOrderLineExList(orderId);
  }

  Future<List<PreOrderExResult>> getPreOrderExList() async {
    return dataStore.ordersDao.getPreOrderExList();
  }

  Future<List<PreOrderLineEx>> getPreOrderLineExList(int preOrderId) async {
    return dataStore.ordersDao.getPreOrderLineExList(preOrderId);
  }

  Future<void> addSeenPreOrder({
    required int id
  }) async {
    await dataStore.ordersDao.addSeenPreOrder(SeenPreOrdersCompanion(id: Value(id)));

    notifyListeners();
  }

  Future<OrderExResult> addOrder({
    int? preOrderId,
    int? buyerId,
    DateTime? date,
    String? status,
    bool needProcessing = false,
    bool needDocs = false,
    bool isBonus = false,
    bool isPhysical = false,
    bool needInc = false,
  }) async {
    final id = await dataStore.ordersDao.addOrder(
      OrdersCompanion.insert(
        status: status ?? OrderStatus.draft.value,
        needDocs: needDocs,
        isBonus: isBonus,
        isPhysical: isPhysical,
        needInc: needInc,
        preOrderId: Value(preOrderId),
        buyerId: Value(buyerId),
        date: Value(date),
        needProcessing: needProcessing,
        isEditable: true,
        isDeleted: false,
        timestamp: DateTime.now(),
        isBlocked: false,
        needSync: false
      )
    );
    final orderEx = await dataStore.ordersDao.getOrderEx(id);

    notifyListeners();

    return orderEx!;
  }

  Future<void> updateOrder(Order order, {
    Optional<int?>? buyerId,
    Optional<DateTime?>? date,
    Optional<String?>? info,
    Optional<bool>? needDocs,
    Optional<bool>? needInc,
    Optional<bool>? isBonus,
    Optional<bool>? isPhysical,
    Optional<bool>? needProcessing,
    Optional<bool>? needSync
  }) async {
    final updatedOrder = OrdersCompanion(
      buyerId: buyerId == null ? const Value.absent() : Value(buyerId.orNull),
      date: date == null ? const Value.absent() : Value(date.orNull),
      info: info == null ? const Value.absent() : Value(info.orNull),
      needDocs: needDocs == null ? const Value.absent() : Value(needDocs.value),
      needInc: needInc == null ? const Value.absent() : Value(needInc.value),
      isBonus: isBonus == null ? const Value.absent() : Value(isBonus.value),
      isPhysical: isPhysical == null ? const Value.absent() : Value(isPhysical.value),
      needProcessing: needProcessing == null ? const Value.absent() : Value(needProcessing.value),
      timestamp: Value(DateTime.now()),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
      isDeleted: const Value(false)
    );

    await dataStore.ordersDao.updateOrder(order.id, updatedOrder);
    notifyListeners();
  }

  Future<void> deleteOrder(Order order) async {
    if (order.guid == null) {
      await dataStore.ordersDao.deleteOrder(order.id);
    } else {
      await dataStore.ordersDao.updateOrder(
        order.id,
        const OrdersCompanion(isDeleted: Value(true), needSync: Value(true))
      );
    }

    notifyListeners();
    return;
  }

  Future<void> addOrderLine(Order order, {
    required int goodsId,
    required double vol,
    required double price,
    required double priceOriginal,
    required int package,
    required int rel
  }) async {
    await dataStore.ordersDao.addOrderLine(
      OrderLinesCompanion.insert(
        orderId: order.id,
        goodsId: goodsId,
        vol: vol,
        price: price,
        priceOriginal: priceOriginal,
        rel: rel,
        package: package,
        isDeleted: false,
        timestamp: DateTime.now(),
        needSync: true
      )
    );
    notifyListeners();
  }

  Future<void> updateOrderLine(OrderLine orderLine, {
    Optional<int>? goodsId,
    Optional<double>? vol,
    Optional<double>? price,
    Optional<double>? priceOriginal,
    Optional<int>? package,
    Optional<int>? rel,
    Optional<bool>? needSync
  }) async {
    final updatedOrderLine = OrderLinesCompanion(
      goodsId: goodsId == null ? const Value.absent() : Value(goodsId.value),
      vol: vol == null ? const Value.absent() : Value(vol.value),
      price: price == null ? const Value.absent() : Value(price.value),
      priceOriginal: priceOriginal == null ? const Value.absent() : Value(priceOriginal.value),
      package: package == null ? const Value.absent() : Value(package.value),
      rel: rel == null ? const Value.absent() : Value(rel.value),
      timestamp: Value(DateTime.now()),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
      isDeleted: const Value(false)
    );

    await dataStore.ordersDao.updateOrderLine(orderLine.id, updatedOrderLine);
    notifyListeners();
  }

  Future<void> deleteOrderLine(OrderLine orderLine) async {
    if (orderLine.guid == null) {
      await dataStore.ordersDao.deleteOrderLine(orderLine.id);
    } else {
      await dataStore.ordersDao.updateOrderLine(
        orderLine.id,
        const OrderLinesCompanion(isDeleted: Value(true), needSync: Value(true))
      );
    }

    notifyListeners();
    return;
  }


  Future<OrderExResult> copyOrder(Order order, List<OrderLine> orderLines) async {
    return await dataStore.transaction(() async {
      final id = await dataStore.ordersDao.addOrder(order.toCompanion(false).copyWith(
        id: const Value.absent(),
        guid: const Value.absent(),
        timestamp: Value(DateTime.now()),
        isDeleted: const Value(false),
        needSync: const Value(true)
      ));
      for (var orderLine in orderLines) {
        await dataStore.ordersDao.addOrderLine(orderLine.toCompanion(false).copyWith(
          orderId: Value(id),
          id: const Value.absent(),
          guid: const Value.absent(),
          timestamp: Value(DateTime.now()),
          isDeleted: const Value(false),
          needSync: const Value(true)
        ));
      }
      notifyListeners();
      return (await dataStore.ordersDao.getOrderEx(id))!;
    });
  }

  Future<void> updateOrderLinePrices(Order order) async {
    await dataStore.transaction(() async {
      final orderLinesEx = await dataStore.ordersDao.getOrderLineExList(order.id);
      final goodsDetails = await dataStore.ordersDao.getGoodsDetails(
        buyerId: order.buyerId!,
        date: order.date!,
        goodsIds: orderLinesEx.map((e) => e.goods.id).toList()
      );

      for (var orderLine in orderLinesEx) {
        final goodsDetail = goodsDetails.firstWhereOrNull((e) => e.goods == orderLine.goods);

        if (goodsDetail == null) continue;
        if (orderLine.line.price != orderLine.line.priceOriginal) continue;

        await updateOrderLine(
          orderLine.line,
          price: Optional.of(goodsDetail.price),
          priceOriginal: Optional.of(goodsDetail.price),
          needSync: Optional.of(true)
        );
      }
      notifyListeners();
    });
  }

  Future<void> clearFiles([Set<String> newKeys = const <String>{}]) async {
    final cacheObjects = await _goodsCacheRepo.getAllObjects();
    final oldCacheObjects = cacheObjects.where((e) => !newKeys.contains(e.key));

    for (var oldCacheObject in oldCacheObjects) {
      await goodsCacheManager.removeFile(oldCacheObject.key);
    }
  }
}
