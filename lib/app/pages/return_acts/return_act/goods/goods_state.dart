part of 'goods_page.dart';

enum GoodsStateStatus {
  initial,
  dataLoaded,
  filterChanged,
  showScanFailure,
  showScan,
  scanSuccess,
  scanFailure
}

class GoodsState {
  GoodsState({
    this.status = GoodsStateStatus.initial,
    required this.returnActEx,
    this.linesExList = const [],
    this.allCategories = const [],
    this.shopDepartments = const [],
    this.goodsFilters = const [],
    this.goodsDetails = const [],
    this.visibleGoodsDetails = const [],
    this.visibleCategories = const [],
    this.selectedCategory,
    this.selectedGoodsFilter,
    this.goodsNameSearch,
    this.groupByManufacturer = false,
    this.showGoodsImage = false,
    this.showGroupInfo = false,
    this.showOnlyReturnAct = false,
    this.showOnlyLatest = false,
    this.appInfo,
    this.message = ''
  });

  final GoodsStateStatus status;

  final ReturnActExResult returnActEx;
  final List<ReturnActLineExResult> linesExList;
  final List<CategoriesExResult> allCategories;
  final List<ShopDepartment> shopDepartments;
  final List<GoodsFilter> goodsFilters;
  final List<GoodsReturnDetail> goodsDetails;
  final String message;

  List<String> get manufacturers => visibleGoodsDetails
    .where((e) => e.goods.manufacturer != null)
    .map((e) => e.goods.manufacturer!)
    .toSet().toList();

  List<String> get goodsFirstWords => visibleGoodsDetails.map((e) => e.goods.name.split(' ')[0]).toSet().toList();
  List<ReturnActLineExResult> get filteredReturnActLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get showAllGoods =>
    selectedCategory != null ||
    (goodsNameSearch ?? '').isNotEmpty ||
    showOnlyReturnAct;

  bool get goodsListInitiallyExpanded =>
    showOnlyReturnAct ||
    selectedGoodsFilter != null ||
    (goodsNameSearch ?? '').isNotEmpty;

  bool get categoriesListInitiallyExpanded =>
    showOnlyReturnAct ||
    selectedGoodsFilter != null ||
    (goodsNameSearch ?? '').isNotEmpty;

  final List<GoodsReturnDetail> visibleGoodsDetails;
  final List<CategoriesExResult> visibleCategories;
  final CategoriesExResult? selectedCategory;
  final GoodsFilter? selectedGoodsFilter;
  final String? goodsNameSearch;
  final bool groupByManufacturer;
  final bool showGoodsImage;
  final bool showGroupInfo;
  final bool showOnlyReturnAct;
  final bool showOnlyLatest;
  final AppInfoResult? appInfo;

  bool get showLocalImage => appInfo?.showLocalImage ?? true;
  bool get showWithPrice => appInfo?.showWithPrice ?? false;

  GoodsState copyWith({
    GoodsStateStatus? status,
    ReturnActExResult? returnActEx,
    List<ReturnActLineExResult>? linesExList,
    List<CategoriesExResult>? allCategories,
    List<ShopDepartment>? shopDepartments,
    List<GoodsFilter>? goodsFilters,
    List<GoodsReturnDetail>? goodsDetails,
    List<GoodsReturnDetail>? visibleGoodsDetails,
    List<CategoriesExResult>? visibleCategories,
    Optional<CategoriesExResult>? selectedCategory,
    Optional<GoodsFilter>? selectedGoodsFilter,
    Optional<String>? goodsNameSearch,
    bool? groupByManufacturer,
    bool? showGoodsImage,
    bool? showGroupInfo,
    bool? showOnlyReturnAct,
    bool? showOnlyLatest,
    AppInfoResult? appInfo,
    String? message
  }) {
    return GoodsState(
      status: status ?? this.status,
      returnActEx: returnActEx ?? this.returnActEx,
      linesExList: linesExList ?? this.linesExList,
      allCategories: allCategories ?? this.allCategories,
      shopDepartments: shopDepartments ?? this.shopDepartments,
      goodsFilters: goodsFilters ?? this.goodsFilters,
      goodsDetails: goodsDetails ?? this.goodsDetails,
      visibleGoodsDetails: visibleGoodsDetails ?? this.visibleGoodsDetails,
      visibleCategories: visibleCategories ?? this.visibleCategories,
      selectedCategory: selectedCategory != null ? selectedCategory.orNull : this.selectedCategory,
      selectedGoodsFilter: selectedGoodsFilter != null ? selectedGoodsFilter.orNull : this.selectedGoodsFilter,
      goodsNameSearch: goodsNameSearch != null ? goodsNameSearch.orNull : this.goodsNameSearch,
      groupByManufacturer: groupByManufacturer ?? this.groupByManufacturer,
      showGoodsImage: showGoodsImage ?? this.showGoodsImage,
      showGroupInfo: showGroupInfo ?? this.showGroupInfo,
      showOnlyReturnAct: showOnlyReturnAct ?? this.showOnlyReturnAct,
      showOnlyLatest: showOnlyLatest ?? this.showOnlyLatest,
      appInfo: appInfo ?? this.appInfo,
      message: message ?? this.message
    );
  }
}
