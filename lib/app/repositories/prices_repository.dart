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
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    }
  }

  Future<void> syncPrices(List<PartnersPrice> prices, List<PartnersPricelist> pricelists) async {
    try {
      DateTime lastSyncTime = DateTime.now();
      Map<String, dynamic> pricesData = {
        'prices': prices.map((e) => {
          'guid': e.guid,
          'isNew': e.isNew,
          'isDeleted': e.isDeleted,
          'currentTimestamp': e.currentTimestamp.toIso8601String(),
          'timestamp': e.timestamp.toIso8601String(),
          'goodsId': e.goodsId,
          'partnerId': e.partnerId,
          'price': e.price,
          'dateFrom': e.dateFrom.toIso8601String(),
          'dateTo': e.dateTo.toIso8601String()
        }).toList(),
        'pricelists': pricelists.map((e) => {
          'guid': e.guid,
          'isNew': e.isNew,
          'isDeleted': e.isDeleted,
          'currentTimestamp': e.currentTimestamp.toIso8601String(),
          'timestamp': e.timestamp.toIso8601String(),
          'partnerId': e.partnerId,
          'pricelistId': e.pricelistId,
          'pricelistSetId': e.pricelistSetId,
          'discount': e.discount
        }).toList(),
      };

      final data = await api.savePrices(pricesData);
      final apiPartnersPrices = data.partnersPrices.map((e) => e.toDatabaseEnt()).toList();
      final apiPartnersPricelists = data.partnersPricelists.map((e) => e.toDatabaseEnt()).toList();
      await dataStore.transaction(() async {
        for (var price in prices) {
          await dataStore.pricesDao.updatePartnersPrice(
            price.guid,
            PartnersPricesCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }
        for (var pricelist in pricelists) {
          await dataStore.pricesDao.updatePartnersPricelist(
            pricelist.guid,
            PartnersPricelistsCompanion(lastSyncTime: Value(lastSyncTime))
          );
        }

        await dataStore.pricesDao.loadPartnersPrices(apiPartnersPrices, false);
        await dataStore.pricesDao.loadPartnersPricelists(apiPartnersPricelists, false);
      });
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

    await syncPrices(prices, pricelists);
  }

  Stream<List<GoodsPricelistsResult>> watchGoodsPricelists({
    required int goodsId,
    required DateTime date
  }) {
    return dataStore.pricesDao.watchGoodsPricelists(
      goodsId: goodsId,
      date: date
    );
  }

  Stream<List<PartnersPricelist>> watchPartnersPricelists({
    required int goodsId,
    required int partnerId
  }) {
    return dataStore.pricesDao.watchPartnersPricelists(
      goodsId: goodsId,
      partnerId: partnerId
    );
  }

  Stream<List<PartnersPrice>> watchPartnersPrices({
    required int goodsId,
    required int partnerId
  }) {
    return dataStore.pricesDao.watchPartnersPrices(
      goodsId: goodsId,
      partnerId: partnerId
    );
  }

  Future<void> updatePartnersPricelist(PartnersPricelist partnersPricelist, {
    Optional<int>? partnerId,
    Optional<int>? pricelistId,
    Optional<int>? pricelistSetId,
    Optional<double>? discount
  }) async {
    final updatedPartnersPricelist = PartnersPricelistsCompanion(
      partnerId: partnerId == null ? const Value.absent() : Value(partnerId.value),
      pricelistId: pricelistId == null ? const Value.absent() : Value(pricelistId.value),
      pricelistSetId: pricelistSetId == null ? const Value.absent() : Value(pricelistSetId.value),
      discount: discount == null ? const Value.absent() : Value(discount.value),
      isDeleted: const Value(false)
    );

    await dataStore.pricesDao.updatePartnersPricelist(partnersPricelist.guid, updatedPartnersPricelist);
  }

  Future<void> addPartnersPrice({
    required int goodsId,
    required int partnerId,
    required double price,
    required DateTime dateFrom,
    required DateTime dateTo
  }) async {
    final guid = dataStore.generateGuid();
    await dataStore.pricesDao.addPartnersPrice(
      PartnersPricesCompanion.insert(
        guid: guid,
        goodsId: goodsId,
        partnerId: partnerId,
        price: price,
        dateFrom: dateFrom,
        dateTo: dateTo
      )
    );
  }

  Future<void> updatePartnersPrice(PartnersPrice partnersPrice, {
    Optional<int>? goodsId,
    Optional<int>? partnerId,
    Optional<double>? price,
    Optional<DateTime>? dateFrom,
    Optional<DateTime>? dateTo
  }) async {
    final updatedPartnersPrice = PartnersPricesCompanion(
      goodsId: goodsId == null ? const Value.absent() : Value(goodsId.value),
      partnerId: partnerId == null ? const Value.absent() : Value(partnerId.value),
      price: price == null ? const Value.absent() : Value(price.value),
      dateFrom: dateFrom == null ? const Value.absent() : Value(dateFrom.value),
      dateTo: dateTo == null ? const Value.absent() : Value(dateTo.value),
      isDeleted: const Value(false)
    );

    await dataStore.pricesDao.updatePartnersPrice(partnersPrice.guid, updatedPartnersPrice);
  }

  Future<void> regenerateGuid() async {
    await dataStore.pricesDao.regeneratePartnersPricesGuid();
    await dataStore.pricesDao.regeneratePartnersPricelistsGuid();
  }
}
