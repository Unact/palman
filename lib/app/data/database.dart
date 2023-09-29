import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/native.dart';
import 'package:drift/native.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:rxdart/rxdart.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:uuid/uuid.dart';

import '/app/constants/strings.dart';

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
    SeenPreOrders,
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
        (
          SELECT COUNT(*)
          FROM points
          WHERE need_sync = 1 OR EXISTS(SELECT 1 FROM point_images WHERE point_id = points.id AND need_sync = 1)
        ) AS "points_to_sync",
        (
          SELECT COUNT(*)
          FROM deposits
          WHERE need_sync = 1 OR EXISTS(SELECT 1 FROM encashments WHERE deposit_id = deposits.id AND need_sync = 1)
        ) AS "deposits_to_sync",
        (
          SELECT COUNT(*)
          FROM orders
          WHERE need_sync = 1 OR EXISTS(SELECT 1 FROM order_lines WHERE order_id = orders.id AND need_sync = 1)
        ) AS "orders_to_sync",
        (SELECT COUNT(*) FROM inc_requests WHERE need_sync = 1) AS "inc_requests_to_sync",
        (SELECT COUNT(*) FROM partners_prices WHERE need_sync = 1) AS "partner_prices_to_sync",
        (SELECT COUNT(*) FROM partners_pricelists WHERE need_sync = 1) AS "partners_pricelists_to_sync",
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
  static const Uuid _kUuid = Uuid();

  AppDataStore({
    required bool logStatements
  }) : super(_openConnection(logStatements));

  Stream<AppInfoResult> watchAppInfo() {
    return appInfo().watchSingle();
  }

  Stream<List<Workdate>> watchWorkdates() {
    return (select(workdates)..orderBy([(tbl) => OrderingTerm(expression: tbl.date)])).watch();
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
    await _loadData(workdates, list);
  }

  Future<void> loadCategories(List<Category> list) async {
    await _loadData(categories, list);
  }

  Future<void> loadShopDepartments(List<ShopDepartment> list) async {
    await _loadData(shopDepartments, list);
  }

  Future<void> loadGoodsFilters(List<GoodsFilter> list) async {
    await _loadData(goodsFilters, list);
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
      batch.insert(prefs, const Pref(showLocalImage: true, showWithPrice: false));
    });
  }

  Future<void> _loadData(TableInfo table, Iterable<Insertable> rows) async {
    await batch((batch) {
      batch.deleteWhere(table, (row) => const Constant(true));
      batch.insertAll(table, rows, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> _regenerateGuid(TableInfo table) async {
    final toUpdate = await (select(table)..where((tbl) => (table as Syncable).lastSyncTime.isNull())).get();

    await batch((batch) {
      for (var e in toUpdate) {
        batch.customStatement(
          'UPDATE ${table.actualTableName} SET guid = ?1 WHERE id = ?2',
          [AppDataStore._kUuid.v4(), e.id],
          [TableUpdate.onTable(table, kind: UpdateKind.update)]
        );
      }
    });
  }

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
        await m.createTable(table);

        if (table is Syncable) {
          final name = table.entityName;
          final triggerName = 'syncable_$name';
          final systemColumns = ['last_sync_time', 'timestamp', 'current_timestamp'];
          final updateableColumns = table.columnsByName.keys.whereNot((e) => systemColumns.contains(e));

          m.createTrigger(Trigger(
            '''
              CREATE TRIGGER $triggerName
              AFTER UPDATE OF ${updateableColumns.join(',')} ON $name
              BEGIN
                UPDATE $name SET timestamp = CAST(STRFTIME('%s', CURRENT_TIMESTAMP) AS INTEGER) WHERE id = OLD.id;
              END;
            ''',
            triggerName
          ));
        }
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
        'shipment_lines_shipment_id_idx',
        'CREATE INDEX shipment_lines_shipment_idx ON shipment_lines(shipment_id)'
      ));
      await m.createIndex(Index(
        'order_lines_goods_idx',
        'CREATE INDEX order_lines_goods_idx ON order_lines(goods_id)'
      ));
      await m.createIndex(Index(
        'order_lines_order_idx',
        'CREATE INDEX order_lines_order_idx ON order_lines(order_id)'
      ));
      await m.createIndex(Index(
        'pre_order_lines_goods_idx',
        'CREATE INDEX pre_order_lines_goods_idx ON pre_order_lines(goods_id)'
      ));
      await m.createIndex(Index(
        'pre_order_lines_pre_order_idx',
        'CREATE INDEX pre_order_lines_pre_order_idx ON pre_order_lines(pre_order_id)'
      ));
      await m.createIndex(Index(
        'goods_bonus_programs_goods_idx',
        'CREATE INDEX goods_bonus_programs_goods_idx ON goods_bonus_programs(goods_id)'
      ));
      await m.createIndex(Index(
        'goods_bonus_programs_bonus_program_idx',
        'CREATE INDEX goods_bonus_programs_bonus_program_idx ON goods_bonus_programs(bonus_program_id)'
      ));
      await m.createIndex(Index(
        'pricelist_prices_idx',
        'CREATE INDEX pricelist_prices_idx ON pricelist_prices(goods_id, pricelist_id)'
      ));
      await m.createIndex(Index(
        'point_images_point_idx',
        'CREATE INDEX point_images_point_idx ON point_images(point_id)'
      ));
      await m.createIndex(Index(
        'goods_category_idx',
        'CREATE INDEX goods_category_idx ON goods(category_id)'
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
  OrderStatus get detailedStatus => OrderStatus.values
    .firstWhere((e) => e.value == status, orElse: () => OrderStatus.unknown);
}

extension OrderLineX on OrderLine {
  double get total => vol * price * rel;
}

extension PreOrderLineX on PreOrderLine {
  double get total => vol * price * rel;
}

extension UserX on User {
  Future<bool> get newVersionAvailable async {
    final currentVersion = (await PackageInfo.fromPlatform()).version;

    return Version.parse(version) > Version.parse(currentVersion);
  }
}

enum OrderStatus {
  draft('draft', 'Черновик'),
  upload('upload', 'В работе'),
  deleted('deleted', 'Удален'),
  onhold('onhold', 'Задержан'),
  processing('processing', 'Передача'),
  done('done', 'Передан'),
  unknown('unknown', 'Статус не определен');

  const OrderStatus(this.value, this.name);

  final String value;
  final String name;
}
