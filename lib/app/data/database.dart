import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/native.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '/app/constants/strings.dart';
import '/app/utils/extensions.dart';

part 'schema.dart';
part 'database.g.dart';
part 'bonus_programs_dao.dart';
part 'debts_dao.dart';
part 'orders_dao.dart';
part 'partners_dao.dart';
part 'points_dao.dart';
part 'prices_dao.dart';
part 'shipments_dao.dart';
part 'users_dao.dart';

@DriftDatabase(
  tables: [
    Users,
    Prefs,
    Buyers,
    Partners,
    Locations,
    PointFormats,
    Points,
    PointImages,
    Encashments,
    Debts,
    Deposits,
    Shipments,
    ShipmentLines,
    IncRequests,
    AllGoods,
    Workdates,
    ShopDepartments,
    Categories,
    GoodsFilters,
    Orders,
    OrderLines,
    PreOrders,
    PreOrderLines,
    BonusProgramGroups,
    BonusPrograms,
    BuyersSets,
    BuyersSetsBonusPrograms,
    BuyersSetsBuyers,
    GoodsBonusPrograms,
    GoodsBonusProgramPrices,
    Pricelists,
    PricelistSetCategories,
    PartnersPrices,
    PricelistPrices,
    PartnersPricelists,
    GoodsRestrictions,
    GoodsStocks,
    GoodsPartnersPricelists
  ],
  daos: [
    BonusProgramsDao,
    DebtsDao,
    OrdersDao,
    PartnersDao,
    PointsDao,
    PricesDao,
    ShipmentsDao,
    UsersDao
  ],
  queries: {
    'appInfo': '''
      SELECT
        prefs.*,
        (SELECT COUNT(*) FROM points WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM point_images WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM inc_requests WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM encashments WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM partners_prices WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM partners_pricelists WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM orders WHERE need_sync = 1) +
        (SELECT COUNT(*) FROM order_lines WHERE need_sync = 1) AS "sync_total",
        (SELECT COUNT(*) FROM points) AS "points_total",
        (SELECT COUNT(*) FROM encashments) AS "encashments_total",
        (SELECT COUNT(*) FROM shipments) AS "shipments_total",
        (SELECT COUNT(*) FROM orders) AS "orders_total",
        (SELECT COUNT(*) FROM pre_orders) AS "pre_orders_total"
      FROM prefs
    '''
  },
)
class AppDataStore extends _$AppDataStore {
  AppDataStore({
    required bool logStatements
  }) : super(_openConnection(logStatements));

  Future<AppInfoResult> getAppInfo() async {
    return appInfo().getSingle();
  }

  Future<Pref> getPref() async {
    return select(prefs).getSingle();
  }

  Future<List<Workdate>> getWorkdates() async {
    return (select(workdates)..orderBy([(tbl) => OrderingTerm(expression: tbl.date)])).get();
  }

  Future<int> updatePref(PrefsCompanion pref) {
    return update(prefs).write(pref);
  }

  Future<int> insertLocation(LocationsCompanion location) async {
    return await into(locations).insert(location);
  }

  Future<void> deleteLocation(int id) async {
    (delete(locations)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Location>> getLocations() async {
    return select(locations).get();
  }

  Future<void> clearData() async {
    await transaction(() async {
      await _clearData();
      await _populateData();
    });
  }

  Future<void> loadWorkdates(List<Workdate> list) async {
    await batch((batch) {
      batch.deleteWhere(workdates, (row) => const Constant(true));
      batch.insertAll(workdates, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loadCategories(List<Category> list) async {
    await batch((batch) {
      batch.deleteWhere(categories, (row) => const Constant(true));
      batch.insertAll(categories, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loadShopDepartments(List<ShopDepartment> list) async {
    await batch((batch) {
      batch.deleteWhere(shopDepartments, (row) => const Constant(true));
      batch.insertAll(shopDepartments, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> loadGoodsFilters(List<GoodsFilter> list) async {
    await batch((batch) {
      batch.deleteWhere(goodsFilters, (row) => const Constant(true));
      batch.insertAll(goodsFilters, list, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> _clearData() async {
    await batch((batch) {
      for (var table in allTables) {
        batch.deleteWhere(table, (row) => const Constant(true));
      }
    });
  }

  Future<void> _populateData() async {
    await batch((batch) {
      batch.insert(users, const User(
        id: UsersDao.kGuestId,
        username: UsersDao.kGuestUsername,
        email: '',
        salesmanName: '',
        preOrderMode: false,
        version: '0.0.0'
      ));
      batch.insert(prefs, const Pref(showLocalImage: true));
    });
  }

  Future<void> _loadData(TableInfo table, Iterable<Insertable> rows) async {
    await batch((batch) {
      batch.deleteWhere(table, (row) => const Constant(true));
      batch.insertAll(table, rows, mode: InsertMode.insertOrReplace);
    });
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
        await m.createTable(table);
      }

      await m.createIndex(Index(
        'goods_partners_pricelists_idx',
        'CREATE INDEX goods_partners_pricelists_idx ON goods_partners_pricelists(partner_pricelist_id, goods_id)'
      ));
      await m.createIndex(Index(
        'partners_pricelists_idx',
        'CREATE INDEX partners_pricelists_idx ON partners_pricelists(partner_id, pricelist_id)'
      ));
      await m.createIndex(Index(
        'shipment_lines_goods_idx',
        'CREATE INDEX shipment_lines_goods_idx ON shipment_lines(goods_id)'
      ));
      await m.createIndex(Index(
        'order_lines_goods_idx',
        'CREATE INDEX order_lines_goods_idx ON order_lines(goods_id)'
      ));
      await m.createIndex(Index(
        'pre_order_lines_goods_idx',
        'CREATE INDEX pre_order_lines_goods_idx ON pre_order_lines(goods_id)'
      ));
      await m.createIndex(Index(
        'goods_bonus_programs_idx',
        'CREATE INDEX goods_bonus_programs_idx ON goods_bonus_programs(goods_id)'
      ));
      await m.createIndex(Index(
        'pricelist_prices_idx',
        'CREATE INDEX pricelist_prices_idx ON pricelist_prices(goods_id, pricelist_id)'
      ));
    },
    beforeOpen: (details) async {
      if (details.hadUpgrade || details.wasCreated) await _populateData();
    },
  );
}

LazyDatabase _openConnection(bool logStatements) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '${Strings.appName}.sqlite'));

    return NativeDatabase.createInBackground(file, logStatements: logStatements, cachePreparedStatements: true);
  });
}

extension BuyerX on Buyer {
  String get fullname => '$name: $loadto';
}

extension GoodsX on Goods {
  String get preName => name.split(' ')[0];
}

extension OrderX on Order {
  String get statusName {
    switch (status) {
      case 'done': return 'Передан';
      case Strings.orderUploadStatus: return 'В работе';
      case 'processing': return 'Передача';
      case Strings.orderDraftStatus: return 'Черновик';
      case 'onhold': return 'Задержан';
      case 'deleted': return 'Удален';
      default: return 'Статус не определен';
    }
  }
}

extension OrderLineX on OrderLine {
  double get total => vol * price * rel;
}

extension PreOrderLineX on PreOrderLine {
  double get total => vol * price * rel;
}
