import 'dart:async';

import 'package:drift/drift.dart';
import 'package:quiver/core.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/palman_api.dart';

class PricesRepository extends BaseRepository {
  PricesRepository(AppDataStore dataStore, RenewApi api) : super(dataStore, api);

  Future<void> loadPrices() async {
    try {
      final data = await api.getPrices();

      await dataStore.transaction(() async {
        final partnersPrices = data.partnersPrices.map((e) => e.toDatabaseEnt()).toList();
        final pricelistPrices = data.pricelistPrices.map((e) => e.toDatabaseEnt()).toList();
        final partnersPricelists = data.partnersPricelists.map((e) => e.toDatabaseEnt()).toList();
        final goodsPartnersPricelists = data.goodsPartnersPricelists.map((e) => e.toDatabaseEnt()).toList();

        await dataStore.pricesDao.loadPartnersPrices(partnersPrices);
        await dataStore.pricesDao.loadPricelistPrices(pricelistPrices);
        await dataStore.pricesDao.loadPartnersPricelists(partnersPricelists);
        await dataStore.pricesDao.loadGoodsPartnersPricelists(goodsPartnersPricelists);
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> blockPartnersPrices(bool block, {List<int>? ids}) async {
    await dataStore.pricesDao.blockPartnersPrices(block, ids: ids);
    notifyListeners();
  }


  Future<void> blockPartnersPricelists(bool block, {List<int>? ids}) async {
    await dataStore.pricesDao.blockPartnersPricelists(block, ids: ids);
    notifyListeners();
  }

  Future<void> syncPrices(List<PartnersPrice> prices, List<PartnersPricelist> pricelists) async {
    try {
      Map<String, dynamic> pricesData = {
        'prices': prices.map((e) => {
          'guid': e.guid,
          'timestamp': e.timestamp.toIso8601String(),
          'goodsId': e.goodsId,
          'partnerId': e.partnerId,
          'price': e.price,
          'dateFrom': e.dateFrom.toIso8601String(),
          'dateTo': e.dateTo.toIso8601String()
        }).toList(),
        'pricelists': pricelists.map((e) => {
          'guid': e.guid,
          'timestamp': e.timestamp.toIso8601String(),
          'partnerId': e.partnerId,
          'pricelistId': e.pricelistId,
          'pricelistSetId': e.pricelistSetId,
          'discount': e.discount
        }).toList(),
      };

      final data = await api.savePrices(pricesData);
      await dataStore.transaction(() async {
        for (var price in prices) {
          await dataStore.pricesDao.deletePartnersPrice(price.id);
        }
        for (var pricelist in pricelists) {
          await dataStore.pricesDao.deletePartnersPricelist(pricelist.id);
        }
        for (var apiPartnersPrice in data.partnersPrices) {
          final companion = apiPartnersPrice.toDatabaseEnt().toCompanion(false).copyWith(id: const Value.absent());
          await dataStore.pricesDao.addPartnersPrice(companion);
        }
        for (var apiPartnersPricelist in data.partnersPricelists) {
          final companion = apiPartnersPricelist.toDatabaseEnt().toCompanion(false).copyWith(id: const Value.absent());
          await dataStore.pricesDao.addPartnersPricelist(companion);
        }
      });
      notifyListeners();
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncChanges() async {
    final prices = await dataStore.pricesDao.getPartnersPricesForSync();
    final pricelists = await dataStore.pricesDao.getPartnersPricelistsForSync();

    if (prices.isEmpty && pricelists.isEmpty) return;

    try {
      await blockPartnersPrices(true);
      await blockPartnersPricelists(true);
      await syncPrices(prices, pricelists);
    } finally {
      await blockPartnersPrices(false);
      await blockPartnersPricelists(false);
    }
  }

  Future<List<GoodsPricelistsResult>> getGoodsPricelists({
    required int goodsId,
    required DateTime date
  }) async {
    return dataStore.pricesDao.getGoodsPricelists(
      goodsId: goodsId,
      date: date
    );
  }

  Future<List<PartnersPricelist>> getPartnersPricelists({
    required int goodsId,
    required int partnerId
  }) async {
    return dataStore.pricesDao.getPartnersPricelists(
      goodsId: goodsId,
      partnerId: partnerId
    );
  }

  Future<List<PartnersPrice>> getPartnersPrices({
    required int goodsId,
    required int partnerId
  }) async {
    return dataStore.pricesDao.getPartnersPrices(
      goodsId: goodsId,
      partnerId: partnerId
    );
  }

  Future<List<GoodsPricesResult>> getGoodsPrices({
    required int buyerId,
    required DateTime date,
    required List<int> goodsIds
  }) async {
    return dataStore.pricesDao.getGoodsPrices(
      buyerId: buyerId,
      date: date,
      goodsIds: goodsIds
    );
  }

  Future<void> updatePartnersPricelist(PartnersPricelist partnersPricelist, {
    Optional<int>? partnerId,
    Optional<int>? pricelistId,
    Optional<int>? pricelistSetId,
    Optional<double>? discount,
    Optional<bool>? needSync
  }) async {
    final updatedPartnersPricelist = PartnersPricelistsCompanion(
      partnerId: partnerId == null ? const Value.absent() : Value(partnerId.value),
      pricelistId: pricelistId == null ? const Value.absent() : Value(pricelistId.value),
      pricelistSetId: pricelistSetId == null ? const Value.absent() : Value(pricelistSetId.value),
      discount: discount == null ? const Value.absent() : Value(discount.value),
      timestamp: Value(DateTime.now()),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value)
    );

    await dataStore.pricesDao.updatePartnersPricelist(partnersPricelist.id, updatedPartnersPricelist);
    notifyListeners();
  }

  Future<void> addPartnersPrice({
    required int goodsId,
    required int partnerId,
    required double price,
    required DateTime dateFrom,
    required DateTime dateTo
  }) async {
    await dataStore.pricesDao.addPartnersPrice(
      PartnersPricesCompanion.insert(
        goodsId: goodsId,
        partnerId: partnerId,
        price: price,
        dateFrom: dateFrom,
        dateTo: dateTo,
        timestamp: DateTime.now(),
        needSync: true,
        isBlocked: false
      )
    );
    notifyListeners();
  }

  Future<void> updatePartnersPrice(PartnersPrice partnersPrice, {
    Optional<int>? goodsId,
    Optional<int>? partnerId,
    Optional<double>? price,
    Optional<DateTime>? dateFrom,
    Optional<DateTime>? dateTo,
    Optional<bool>? needSync
  }) async {
    final updatedPartnersPrice = PartnersPricesCompanion(
      goodsId: goodsId == null ? const Value.absent() : Value(goodsId.value),
      partnerId: partnerId == null ? const Value.absent() : Value(partnerId.value),
      price: price == null ? const Value.absent() : Value(price.value),
      dateFrom: dateFrom == null ? const Value.absent() : Value(dateFrom.value),
      dateTo: dateTo == null ? const Value.absent() : Value(dateTo.value),
      timestamp: Value(DateTime.now()),
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
    );

    await dataStore.pricesDao.updatePartnersPrice(partnersPrice.id, updatedPartnersPrice);
    notifyListeners();
  }
}
