part of 'goods_page.dart';

enum GoodsStateStatus {
  initial,
  dataLoaded,
  searchStarted,
  searchFinished
}

class GoodsState {
  GoodsState({
    this.status = GoodsStateStatus.initial,
    required this.orderEx,
    this.linesExList = const [],
    this.allCategories = const [],
    this.shopDepartments = const [],
    this.goodsFilters = const [],
    this.goodsDetails = const [],
    this.visibleGoodsDetails = const [],
    this.visibleCategories = const [],
    this.selectedBonusProgram,
    this.selectedCategory,
    this.selectedGoodsFilter,
    this.goodsNameSearch,
    this.groupByManufacturer = false,
    this.showGoodsImage = false,
    this.showGroupInfo = false,
    this.showOnlyActive = false,
    this.showOnlyOrder = false,
    this.showOnlyLatest = false,
    this.appInfo
  });

  final GoodsStateStatus status;

  final OrderExResult orderEx;
  final List<OrderLineExResult> linesExList;
  final List<CategoriesExResult> allCategories;
  final List<ShopDepartment> shopDepartments;
  final List<GoodsFilter> goodsFilters;
  final List<GoodsDetail> goodsDetails;

  List<String> get manufacturers => visibleGoodsDetails
    .where((e) => e.goods.manufacturer != null)
    .map((e) => e.goods.manufacturer!)
    .toSet().toList();

  double get total => filteredOrderLinesExList.fold(0, (acc, e) => acc + e.line.total);

  List<String> get goodsFirstWords => visibleGoodsDetails.map((e) => e.goods.name.split(' ')[0]).toSet().toList();
  List<OrderLineExResult> get filteredOrderLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get showAllGoods => selectedCategory != null ||
    selectedBonusProgram != null ||
    (goodsNameSearch ?? '').isNotEmpty ||
    showOnlyOrder;

  bool get goodsListInitiallyExpanded => showOnlyActive ||
    showOnlyOrder ||
    selectedGoodsFilter != null ||
    selectedBonusProgram != null ||
    (goodsNameSearch ?? '').isNotEmpty;

  bool get categoriesListInitiallyExpanded =>
    showOnlyActive ||
    showOnlyOrder ||
    selectedGoodsFilter != null ||
    selectedBonusProgram != null ||
    (goodsNameSearch ?? '').isNotEmpty;

  final List<GoodsDetail> visibleGoodsDetails;
  final List<CategoriesExResult> visibleCategories;
  final CategoriesExResult? selectedCategory;
  final GoodsFilter? selectedGoodsFilter;
  final FilteredBonusProgramsResult? selectedBonusProgram;
  final String? goodsNameSearch;
  final bool groupByManufacturer;
  final bool showGoodsImage;
  final bool showGroupInfo;
  final bool showOnlyActive;
  final bool showOnlyOrder;
  final bool showOnlyLatest;
  final AppInfoResult? appInfo;

  bool get showLocalImage => appInfo?.showLocalImage ?? true;
  bool get showWithPrice => appInfo?.showWithPrice ?? false;

  GoodsState copyWith({
    GoodsStateStatus? status,
    OrderExResult? orderEx,
    List<OrderLineExResult>? linesExList,
    List<CategoriesExResult>? allCategories,
    List<ShopDepartment>? shopDepartments,
    List<GoodsFilter>? goodsFilters,
    List<GoodsDetail>? goodsDetails,
    List<GoodsDetail>? visibleGoodsDetails,
    List<CategoriesExResult>? visibleCategories,
    Optional<FilteredBonusProgramsResult>? selectedBonusProgram,
    Optional<CategoriesExResult>? selectedCategory,
    Optional<GoodsFilter>? selectedGoodsFilter,
    Optional<String>? goodsNameSearch,
    bool? groupByManufacturer,
    bool? showGoodsImage,
    bool? showGroupInfo,
    bool? showOnlyActive,
    bool? showOnlyOrder,
    bool? showOnlyLatest,
    AppInfoResult? appInfo
  }) {
    return GoodsState(
      status: status ?? this.status,
      orderEx: orderEx ?? this.orderEx,
      linesExList: linesExList ?? this.linesExList,
      allCategories: allCategories ?? this.allCategories,
      shopDepartments: shopDepartments ?? this.shopDepartments,
      goodsFilters: goodsFilters ?? this.goodsFilters,
      goodsDetails: goodsDetails ?? this.goodsDetails,
      visibleGoodsDetails: visibleGoodsDetails ?? this.visibleGoodsDetails,
      visibleCategories: visibleCategories ?? this.visibleCategories,
      selectedBonusProgram: selectedBonusProgram != null ? selectedBonusProgram.orNull : this.selectedBonusProgram,
      selectedCategory: selectedCategory != null ? selectedCategory.orNull : this.selectedCategory,
      selectedGoodsFilter: selectedGoodsFilter != null ? selectedGoodsFilter.orNull : this.selectedGoodsFilter,
      goodsNameSearch: goodsNameSearch != null ? goodsNameSearch.orNull : this.goodsNameSearch,
      groupByManufacturer: groupByManufacturer ?? this.groupByManufacturer,
      showGoodsImage: showGoodsImage ?? this.showGoodsImage,
      showGroupInfo: showGroupInfo ?? this.showGroupInfo,
      showOnlyActive: showOnlyActive ?? this.showOnlyActive,
      showOnlyOrder: showOnlyOrder ?? this.showOnlyOrder,
      showOnlyLatest: showOnlyLatest ?? this.showOnlyLatest,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
