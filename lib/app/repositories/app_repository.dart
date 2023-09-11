import 'package:drift/drift.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class AppRepository extends BaseRepository {
  AppRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<bool> get newVersionAvailable async {
    final currentVersion = (await PackageInfo.fromPlatform()).version;
    final remoteVersion = (await dataStore.usersDao.getUser()).version;

    return Version.parse(remoteVersion) > Version.parse(currentVersion);
  }

  Future<String> get fullVersion async {
    final info = await PackageInfo.fromPlatform();

    return '${info.version}+${info.buildNumber}';
  }

  Future<AppInfoResult> getAppInfo() {
    return dataStore.getAppInfo();
  }

  Future<Pref> getPref() {
    return dataStore.getPref();
  }

  Future<void> updatePref({
    Optional<DateTime>? lastSyncTime,
    Optional<bool>? showLocalImage
  }) async {
    final newPref = PrefsCompanion(
      lastSyncTime: lastSyncTime == null ? const Value.absent() : Value(lastSyncTime.value),
      showLocalImage: showLocalImage == null ? const Value.absent() : Value(showLocalImage.value)
    );

    await dataStore.updatePref(newPref);
    notifyListeners();
  }

  Future<List<Workdate>> getWorkdates() {
    return dataStore.getWorkdates();
  }

  Future<void> loadData() async {
    try {
      final data = await api.getDictionaries();

      await dataStore.transaction(() async {
        final buyers = data.buyers.map((e) => e.toDatabaseEnt()).toList();
        final partners = data.partners.map((e) => e.toDatabaseEnt()).toList();
        final pointFormats = data.pointFormats.map((e) => e.toDatabaseEnt()).toList();
        final workdates = data.workdates.map((e) => e.toDatabaseEnt()).toList();
        final categories = data.categories.map((e) => e.toDatabaseEnt()).toList();
        final shopDepartments = data.shopDepartments.map((e) => e.toDatabaseEnt()).toList();
        final goodsFilters = data.goodsFilters.map((e) => e.toDatabaseEnt()).toList();
        final pricelists = data.pricelists.map((e) => e.toDatabaseEnt()).toList();
        final pricelistSetCategories = data.pricelistSetCategories.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.partnersDao.loadBuyers(buyers);
        await dataStore.partnersDao.loadPartners(partners);
        await dataStore.pointsDao.loadPointFormats(pointFormats);
        await dataStore.loadWorkdates(workdates);
        await dataStore.ordersDao.loadCategories(categories);
        await dataStore.ordersDao.loadShopDepartments(shopDepartments);
        await dataStore.ordersDao.loadGoodsFilters(goodsFilters);
        await dataStore.pricesDao.loadPricelists(pricelists);
        await dataStore.pricesDao.loadPricelistSetCategories(pricelistSetCategories);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> clearData() async {
    await dataStore.clearData();
  }
}
