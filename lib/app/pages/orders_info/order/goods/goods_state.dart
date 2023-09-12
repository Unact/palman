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
    this.pref
  });

  final GoodsStateStatus status;

  final OrderExResult orderEx;
  final List<OrderLineEx> linesExList;
  final List<Category> allCategories;
  final List<ShopDepartment> shopDepartments;
  final List<GoodsFilter> goodsFilters;
  final List<GoodsDetail> goodsDetails;

  List<String> get manufacturers => goodsDetails
    .where((e) => e.goods.manufacturer != null)
    .map((e) => e.goods.manufacturer!)
    .toSet().toList();

  double get total => linesExList.fold(0, (acc, e) => acc + e.line.total);

  List<String> get goodsFirstWords => goodsDetails.map((e) => e.goods.name.split(' ')[0]).toSet().toList();
  List<OrderLineEx> get filteredOrderLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get showAllGoods => selectedCategory != null ||
    selectedBonusProgram != null ||
    (goodsNameSearch ?? '').isNotEmpty;

  bool get goodsListInitiallyExpanded => showOnlyActive || showOnlyOrder || selectedBonusProgram != null;
  bool get categoriesListInitiallyExpanded =>
    showOnlyActive ||
    selectedGoodsFilter != null ||
    selectedBonusProgram != null ||
    (goodsNameSearch ?? '').isNotEmpty;

  final List<Category> visibleCategories;
  final Category? selectedCategory;
  final GoodsFilter? selectedGoodsFilter;
  final FilteredBonusProgramsResult? selectedBonusProgram;
  final String? goodsNameSearch;
  final bool groupByManufacturer;
  final bool showGoodsImage;
  final bool showGroupInfo;
  final bool showOnlyActive;
  final bool showOnlyOrder;
  final Pref? pref;

  bool get showLocalImage => pref?.showLocalImage ?? true;

  GoodsState copyWith({
    GoodsStateStatus? status,
    OrderExResult? orderEx,
    List<OrderLineEx>? linesExList,
    List<Category>? allCategories,
    List<ShopDepartment>? shopDepartments,
    List<GoodsFilter>? goodsFilters,
    List<GoodsDetail>? goodsDetails,
    List<Category>? visibleCategories,
    Optional<FilteredBonusProgramsResult>? selectedBonusProgram,
    Optional<Category>? selectedCategory,
    Optional<GoodsFilter>? selectedGoodsFilter,
    Optional<String>? goodsNameSearch,
    bool? groupByManufacturer,
    bool? showGoodsImage,
    bool? showGroupInfo,
    bool? showOnlyActive,
    bool? showOnlyOrder,
    Pref? pref
  }) {
    return GoodsState(
      status: status ?? this.status,
      orderEx: orderEx ?? this.orderEx,
      linesExList: linesExList ?? this.linesExList,
      allCategories: allCategories ?? this.allCategories,
      shopDepartments: shopDepartments ?? this.shopDepartments,
      goodsFilters: goodsFilters ?? this.goodsFilters,
      goodsDetails: goodsDetails ?? this.goodsDetails,
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
      pref: pref ?? this.pref
    );
  }
}
