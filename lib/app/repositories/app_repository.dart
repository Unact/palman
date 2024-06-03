import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class AppRepository extends BaseRepository {
  AppRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Stream<AppInfoResult> watchAppInfo() {
    return dataStore.watchAppInfo();
  }

  Future<void> updatePref({
    Optional<DateTime>? lastLoadTime,
    Optional<bool>? showLocalImage,
    Optional<bool>? showWithPrice
  }) async {
    final newPref = PrefsCompanion(
      lastLoadTime: lastLoadTime == null ? const Value.absent() : Value(lastLoadTime.value),
      showLocalImage: showLocalImage == null ? const Value.absent() : Value(showLocalImage.value),
      showWithPrice: showWithPrice == null ? const Value.absent() : Value(showWithPrice.value)
    );

    await dataStore.updatePref(newPref);
  }

  Stream<List<VisitSkipReason>> watchVisitSkipReasons() {
    return dataStore.watchVisitSkipReasons();
  }

  Stream<List<Workdate>> watchWorkdates() {
    return dataStore.watchWorkdates();
  }

  Stream<List<NtDeptType>> watchNtDeptTypes() {
    return dataStore.watchNtDeptTypes();
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
        final returnActTypes = data.returnActTypes.map((e) => e.toDatabaseEnt()).toList();
        final partnersReturnActTypes = data.partnersReturnActTypes.map((e) => e.toDatabaseEnt()).toList();
        final visitSkipReasons = data.visitSkipReasons.map((e) => e.toDatabaseEnt()).toList();
        final sites = data.sites.map((e) => e.toDatabaseEnt()).toList();
        final ntDeptTypes = data.ntDeptTypes.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.partnersDao.loadBuyers(buyers);
        await dataStore.partnersDao.loadPartners(partners);
        await dataStore.pointsDao.loadPointFormats(pointFormats);
        await dataStore.loadWorkdates(workdates);
        await dataStore.ordersDao.loadCategories(categories);
        await dataStore.ordersDao.loadShopDepartments(shopDepartments);
        await dataStore.ordersDao.loadGoodsFilters(goodsFilters);
        await dataStore.pricesDao.loadPricelists(pricelists);
        await dataStore.pricesDao.loadPricelistSetCategories(pricelistSetCategories);
        await dataStore.returnActsDao.loadReturnActTypes(returnActTypes);
        await dataStore.returnActsDao.loadPartnersReturnActTypes(partnersReturnActTypes);
        await dataStore.loadVisitSkipReasons(visitSkipReasons);
        await dataStore.partnersDao.loadSites(sites);
        await dataStore.loadNtDeptTypes(ntDeptTypes);
      });
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
