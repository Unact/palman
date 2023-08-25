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

    return ApiDictionariesData(
      buyers: buyers,
      partners: partners,
      pointFormats: pointFormats,
      workdates: workdates,
      categories: categories,
      shopDepartments: shopDepartments,
      goodsFilters: goodsFilters,
      pricelists: pricelists,
      pricelistSetCategories: pricelistSetCategories
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
    pricelistSetCategories
  ];
}
