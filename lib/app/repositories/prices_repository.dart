import 'dart:async';

import 'package:drift/drift.dart';
import 'package:quiver/core.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/repositories/base_repository.dart';
import '/app/services/api.dart';
import '/app/utils/misc.dart';

class PricesRepository extends BaseRepository {
  PricesRepository(AppDataStore dataStore, Api api) : super(dataStore, api);

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

  Future<void> blockPrices(bool block) async {
    await dataStore.pricesDao.blockPartnersPrices(block);
    await dataStore.pricesDao.blockPartnersPricelists(block);
    notifyListeners();
  }

  Future<void> syncChanges() async {
    final prices = await dataStore.pricesDao.getPartnersPricesForSync();
    final pricelists = await dataStore.pricesDao.getPartnersPricelistsForSync();

    if (prices.isEmpty && pricelists.isEmpty) return;

    await blockPrices(true);

    try {
      Map<String, dynamic> data = {
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

      await api.savePrices(data);

      await Future.forEach(
        prices,
        (e) => dataStore.pricesDao.updatePartnersPrice(e.id, const PartnersPricesCompanion(needSync: Value(false)))
      );
      await Future.forEach(
        pricelists,
        (e) => dataStore.pricesDao.updatePartnersPricelist(
          e.id,
          const PartnersPricelistsCompanion(needSync: Value(false))
        )
      );
    } on ApiException catch(e) {
      throw AppError(e.errorMsg);
    } catch(e, trace) {
      Misc.reportError(e, trace);
      throw AppError(Strings.genericErrorMsg);
    } finally {
      await blockPrices(false);
    }

    await loadPrices();
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
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
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
      needSync: needSync == null ? const Value.absent() : Value(needSync.value),
    );

    await dataStore.pricesDao.updatePartnersPrice(partnersPrice.id, updatedPartnersPrice);
    notifyListeners();
  }
}
