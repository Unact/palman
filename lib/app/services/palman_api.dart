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
    return ApiDebtsData.fromJson(await get('v2/palman/debts'));
  }

  Future<ApiShipmentsData> getShipments() async {
    return ApiShipmentsData.fromJson(await get('v1/palman/shipments'));
  }

  Future<ApiReturnActsData> getReturnActs() async {
    return ApiReturnActsData.fromJson(await get('v1/palman/return_acts'));
  }

  Future<ApiVisitsData> getVisits() async {
    return ApiVisitsData.fromJson(await get('v1/palman/visits'));
  }

  Future<ApiReturnRemainsData> getReturnRemains({required int buyerId, required int returnActTypeId}) async {
    final query = {
      'buyerId': buyerId,
      'returnActTypeId': returnActTypeId
    };

    return ApiReturnRemainsData.fromJson(
      await get('v1/palman/return_acts/return_remains', query: query)
    );
  }

  Future<ApiPricesData> savePrices(Map<String, dynamic> prices) async {
    return ApiPricesData.fromJson(await post('v1/palman/prices/save', data: prices));
  }

  Future<ApiOrdersData> saveOrders(List<Map<String, dynamic>> orders) async {
    return ApiOrdersData.fromJson(await post('v1/palman/orders/save', data: orders));
  }

  Future<ApiPointsData> savePoints(List<Map<String, dynamic>> points) async {
    return ApiPointsData.fromJson(await post('v1/palman/points/save', data: points));
  }

  Future<ApiVisitsData> visit(Map<String, dynamic> visitData) async {
    return ApiVisitsData.fromJson(await post('v1/palman/visits/visit', data: visitData));
  }

  Future<ApiVisitsData> finishVisitList(Map<String, dynamic> visitListData) async {
    return ApiVisitsData.fromJson(await post('v1/palman/visits/finish_visit_list', data: visitListData));
  }

  Future<ApiVisitsData> addVisitImage(Map<String, dynamic> visitImageData) async {
    return ApiVisitsData.fromJson(await post('v1/palman/visits/add_visit_image', data: visitImageData));
  }

  Future<ApiVisitsData> deleteVisitImage(Map<String, dynamic> visitImageData) async {
    return ApiVisitsData.fromJson(
      await post('v1/palman/visits/delete_visit_image', data: visitImageData)
    );
  }

  Future<ApiVisitsData> addVisitSoftware(Map<String, dynamic> visitSoftwareData) async {
    return ApiVisitsData.fromJson(
      await post('v1/palman/visits/add_visit_software', data: visitSoftwareData)
    );
  }

  Future<ApiVisitsData> deleteVisitSoftware(Map<String, dynamic> visitSoftwareData) async {
    return ApiVisitsData.fromJson(
      await post('v1/palman/visits/delete_visit_software', data: visitSoftwareData)
    );
  }

  Future<ApiVisitsData> completeVisitPurpose(Map<String, dynamic> visitPurposeData) async {
    return ApiVisitsData.fromJson(
      await post('v1/palman/visits/complete_visit_purpose', data: visitPurposeData)
    );
  }

  Future<ApiDebtsData> saveDebts(List<Map<String, dynamic>> preEncashments) async {
    return ApiDebtsData.fromJson(
      await post('v2/palman/debts/save', data: preEncashments)
    );
  }

  Future<ApiDebtsData> deposit() async {
    return ApiDebtsData.fromJson(await post('v2/palman/debts/deposit'));
  }

  Future<ApiShipmentsData> saveShipments(List<Map<String, dynamic>> shipments) async {
    return ApiShipmentsData.fromJson(await post('v1/palman/shipments/save', data: shipments));
  }

  Future<ApiReturnActsData> saveReturnActs(List<Map<String, dynamic>> returnActs) async {
    return ApiReturnActsData.fromJson(await post('v1/palman/return_acts/save', data: returnActs));
  }

  Future<void> locations(List<Map<String, dynamic>> locations) async {
    await post('v1/palman/locations', data: locations);
  }

  Future<void> closeDay({required bool closed}) async {
    await post('v1/palman/close_day', data: { 'closed': closed });
  }
}
