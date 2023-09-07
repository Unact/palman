import 'dart:async';

import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';

extension PalmanApi on RenewApi {
  Future<ApiUserData> getUserData() async {
    return ApiUserData.fromJson(await get('v1/palman/user_info'));
  }

  Future<ApiDictionariesData> getDictionaries() async {
    return ApiDictionariesData.fromJson(await get('v1/palman/dictionaries'));
  }

  Future<ApiBonusProgramsData> getBonusPrograms() async {
    return ApiBonusProgramsData.fromJson(await get('v1/palman/bonus_programs'));
  }

  Future<ApiRemainsData> getRemains() async {
    return ApiRemainsData.fromJson(await get('v1/palman/remains'));
  }

  Future<ApiPricesData> getPrices() async {
    return ApiPricesData.fromJson(await get('v1/palman/prices'));
  }

  Future<ApiPointsData> getPoints() async {
    return ApiPointsData.fromJson(await get('v1/palman/points'));
  }

  Future<ApiOrdersData> getOrders() async {
    return ApiOrdersData.fromJson(await get('v1/palman/orders'));
  }

  Future<ApiDebtsData> getDebts() async {
    return ApiDebtsData.fromJson(await get('v1/palman/debts'));
  }

  Future<ApiShipmentsData> getShipments() async {
    return ApiShipmentsData.fromJson(await get('v1/palman/shipments'));
  }

  Future<ApiPricesData> savePrices(Map<String, dynamic> prices) async {
    return ApiPricesData.fromJson(await post('v1/palman/prices/save', dataGenerator: () => prices));
  }

  Future<ApiOrdersData> saveOrders(List<Map<String, dynamic>> orders) async {
    return ApiOrdersData.fromJson(await post('v1/palman/orders/save', dataGenerator: () => orders));
  }

  Future<ApiPointsData> savePoints(List<Map<String, dynamic>> points) async {
    return ApiPointsData.fromJson(await post('v1/palman/points/save', dataGenerator: () => points));
  }

  Future<ApiDebtsData> saveDebts(List<Map<String, dynamic>> debts) async {
    return ApiDebtsData.fromJson(await post('v1/palman/debts/save', dataGenerator: () => debts));
  }

  Future<ApiShipmentsData> saveShipments(List<Map<String, dynamic>> shipments) async {
    return ApiShipmentsData.fromJson(await post('v1/palman/shipments/save', dataGenerator: () => shipments));
  }

  Future<void> locations(List<Map<String, dynamic>> locations) async {
    return await post('v1/palman/locations', dataGenerator: () => locations);
  }
}
