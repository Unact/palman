part of 'entities.dart';

class ApiDictionariesData extends Equatable {
  final List<ApiBuyer> buyers;
  final List<ApiPartner> partners;
  final List<ApiPointFormat> pointFormats;
  final List<ApiWorkdate> workdates;
  final List<ApiCategory> categories;
  final List<ApiShopDepartment> shopDepartments;
  final List<ApiGoodsFilter> goodsFilters;
  final List<ApiPricelist> pricelists;
  final List<ApiPricelistSetCategory> pricelistSetCategories;
  final List<ApiPartnersReturnActType> partnersReturnActTypes;
  final List<ApiReturnActType> returnActTypes;
  final List<ApiVisitSkipReason> visitSkipReasons;
  final List<ApiSite> sites;
  final List<ApiNtDeptType> ntDeptTypes;
  final List<ApiGoodsList> goodsLists;
  final List<ApiGoodsListGoods> goodsListGoods;

  const ApiDictionariesData({
    required this.buyers,
    required this.partners,
    required this.pointFormats,
    required this.workdates,
    required this.shopDepartments,
    required this.categories,
    required this.goodsFilters,
    required this.pricelists,
    required this.pricelistSetCategories,
    required this.partnersReturnActTypes,
    required this.returnActTypes,
    required this.visitSkipReasons,
    required this.sites,
    required this.ntDeptTypes,
    required this.goodsLists,
    required this.goodsListGoods
  });

  factory ApiDictionariesData.fromJson(Map<String, dynamic> json) {
    List<ApiPartner> partners = json['partners'].map<ApiPartner>((e) => ApiPartner.fromJson(e)).toList();
    List<ApiBuyer> buyers = json['buyers'].map<ApiBuyer>((e) => ApiBuyer.fromJson(e)).toList();
    List<ApiPointFormat> pointFormats = json['pointFormats']
      .map<ApiPointFormat>((e) => ApiPointFormat.fromJson(e)).toList();
    List<ApiWorkdate> workdates = json['workdates'].map<ApiWorkdate>((e) => ApiWorkdate.fromJson(e)).toList();
    List<ApiCategory> categories = json['categories'].map<ApiCategory>((e) => ApiCategory.fromJson(e)).toList();
    List<ApiShopDepartment> shopDepartments = json['shopDepartments']
      .map<ApiShopDepartment>((e) => ApiShopDepartment.fromJson(e)).toList();
    List<ApiGoodsFilter> goodsFilters = json['goodsFilters']
      .map<ApiGoodsFilter>((e) => ApiGoodsFilter.fromJson(e)).toList();
    List<ApiPricelist> pricelists = json['pricelists'].map<ApiPricelist>((e) => ApiPricelist.fromJson(e)).toList();
    List<ApiPricelistSetCategory> pricelistSetCategories = json['pricelistSetCategories']
      .map<ApiPricelistSetCategory>((e) => ApiPricelistSetCategory.fromJson(e)).toList();
    List<ApiPartnersReturnActType> partnersReturnActTypes = json['partnersReturnActTypes']
      .map<ApiPartnersReturnActType>((e) => ApiPartnersReturnActType.fromJson(e)).toList();
    List<ApiReturnActType> returnActTypes = json['returnActTypes']
      .map<ApiReturnActType>((e) => ApiReturnActType.fromJson(e)).toList();
    List<ApiVisitSkipReason> visitSkipReasons = json['visitSkipReasons']
      .map<ApiVisitSkipReason>((e) => ApiVisitSkipReason.fromJson(e)).toList();
    List<ApiSite> sites = json['sites'].map<ApiSite>((e) => ApiSite.fromJson(e)).toList();
    List<ApiNtDeptType> ntDeptTypes = json['ntDeptTypes'].map<ApiNtDeptType>((e) => ApiNtDeptType.fromJson(e)).toList();
    List<ApiGoodsList> goodsLists = json['goodsLists'].map<ApiGoodsList>((e) => ApiGoodsList.fromJson(e)).toList();
    List<ApiGoodsListGoods> goodsListGoods = json['goodsListGoods']
      .map<ApiGoodsListGoods>((e) => ApiGoodsListGoods.fromJson(e)).toList();

    return ApiDictionariesData(
      buyers: buyers,
      partners: partners,
      pointFormats: pointFormats,
      workdates: workdates,
      categories: categories,
      shopDepartments: shopDepartments,
      goodsFilters: goodsFilters,
      pricelists: pricelists,
      pricelistSetCategories: pricelistSetCategories,
      partnersReturnActTypes: partnersReturnActTypes,
      returnActTypes: returnActTypes,
      visitSkipReasons: visitSkipReasons,
      sites: sites,
      ntDeptTypes: ntDeptTypes,
      goodsLists: goodsLists,
      goodsListGoods: goodsListGoods
    );
  }

  @override
  List<Object> get props => [
    buyers,
    partners,
    pointFormats,
    workdates,
    categories,
    shopDepartments,
    goodsFilters,
    pricelists,
    pricelistSetCategories,
    partnersReturnActTypes,
    returnActTypes,
    visitSkipReasons,
    sites,
    ntDeptTypes,
    goodsLists,
    goodsListGoods
  ];
}
