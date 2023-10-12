part of 'goods_page.dart';

class GoodsViewModel extends PageViewModel<GoodsState, GoodsStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final ReturnActsRepository returnActsRepository;
  StreamSubscription<List<ReturnActExResult>>? returnActExListSubscription;
  StreamSubscription<List<ReturnActLineExResult>>? returnActLineExListSubscription;
  StreamSubscription<List<Category>>? categoriesSubscription;
  StreamSubscription<List<ShopDepartment>>? shopDepartmentsSubscription;
  StreamSubscription<List<GoodsFilter>>? goodsFiltersSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  GoodsViewModel(
    this.appRepository,
    this.ordersRepository,
    this.returnActsRepository,
    {required ReturnActExResult returnActEx}
  ) :
    super(GoodsState(returnActEx: returnActEx));

  @override
  GoodsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    returnActExListSubscription = returnActsRepository.watchReturnActExList().listen((event) {
      emit(state.copyWith(
        status: GoodsStateStatus.dataLoaded,
        returnActEx: event.firstWhereOrNull((e) => e.returnAct.guid == state.returnActEx.returnAct.guid)
      ));
    });
    returnActLineExListSubscription = returnActsRepository.watchReturnActLineExList(state.returnActEx.returnAct.guid)
      .listen((event) {
        emit(state.copyWith(status: GoodsStateStatus.dataLoaded, linesExList: event));
      });
    categoriesSubscription = returnActsRepository
      .watchCategories(
        returnActTypeId: state.returnActEx.returnAct.returnActTypeId!,
        buyerId: state.returnActEx.returnAct.buyerId!,
        receptId: state.returnActEx.returnAct.receptId,
      )
      .listen((event) {
        emit(state.copyWith(
          status: GoodsStateStatus.dataLoaded,
          allCategories: event,
          visibleCategories: state.allCategories.isEmpty ? event : null
        ));
      });
    shopDepartmentsSubscription = ordersRepository.watchShopDepartments().listen((event) {
      emit(state.copyWith(status: GoodsStateStatus.dataLoaded, shopDepartments: event));
    });
    goodsFiltersSubscription = ordersRepository.watchGoodsFilters().listen((event) {
      emit(state.copyWith(status: GoodsStateStatus.dataLoaded, goodsFilters: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: GoodsStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await returnActExListSubscription?.cancel();
    await returnActLineExListSubscription?.cancel();
    await categoriesSubscription?.cancel();
    await shopDepartmentsSubscription?.cancel();
    await goodsFiltersSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> clearFilters() async {
    emit(state.copyWith(
      status: GoodsStateStatus.filterChanged,
      selectedCategory: const Optional.absent(),
      selectedGoodsFilter: const Optional.absent(),
      showOnlyReturnAct: false,
      showOnlyLatest: false,
      goodsNameSearch: const Optional.absent(),
      goodsReturnDetails: List.empty(),
      visibleCategories: state.allCategories
    ));
  }

  Future<void> selectCategory(Category? category) async {
    emit(state.copyWith(
      status: GoodsStateStatus.filterChanged,
      selectedCategory: Optional.fromNullable(category),
      goodsReturnDetails: []
    ));

    await searchGoods();
  }

  Future<void> setGoodsNameSearch(String? goodsNameSearch) async {
    emit(state.copyWith(
      status: GoodsStateStatus.filterChanged,
      goodsNameSearch: Optional.fromNullable(goodsNameSearch),
      selectedCategory: const Optional.absent(),
      goodsReturnDetails: []
    ));

    await searchGoods();
  }

  Future<void> selectGoodsFilter(GoodsFilter? goodsFilter) async {
    emit(state.copyWith(
      status: GoodsStateStatus.filterChanged,
      selectedGoodsFilter: Optional.fromNullable(goodsFilter),
      selectedCategory: const Optional.absent(),
      goodsReturnDetails: []
    ));

    await searchGoods();
  }

  Future<void> changeGroupByManufacturer(Set<bool> selection) async {
    emit(state.copyWith(groupByManufacturer: selection.first));
  }

  Future<void> toggleShowGoodsImage() async {
    emit(state.copyWith(showGoodsImage: !state.showGoodsImage));
  }

  Future<void> toggleShowGroupInfo() async {
    emit(state.copyWith(showGroupInfo: !state.showGroupInfo));
  }

  Future<void> toggleShowOnlyLatest() async {
    emit(state.copyWith(
      status: GoodsStateStatus.filterChanged,
      showOnlyLatest: !state.showOnlyLatest,
      selectedCategory: const Optional.absent(),
      goodsReturnDetails: []
    ));

    await searchGoods();
  }

  Future<void> toggleShowOnlyReturnAct() async {
    final newShowOnlyReturnAct = !state.showOnlyReturnAct;

    await clearFilters();
    emit(state.copyWith(status: GoodsStateStatus.filterChanged, showOnlyReturnAct: newShowOnlyReturnAct));

    if (newShowOnlyReturnAct) await searchGoods();
  }

  Future<void> changeBarcode(String barcode) async {
    final goods = await returnActsRepository.getBuyerGoods(
      buyerId: state.returnActEx.returnAct.buyerId!,
      name: state.goodsNameSearch,
      extraLabel: null,
      categoryId: null,
      goodsIds: null,
      onlyLatest: false,
      barcode: barcode
    );

    if (goods.isNotEmpty) {
      emit(state.copyWith(status: GoodsStateStatus.scanSuccess));
      setGoodsNameSearch(goods.first.name);
    } else {
      emit(state.copyWith(message: 'Товар не найден', status: GoodsStateStatus.scanFailure));
    }
  }

  Future<void> searchGoods() async {
    emit(state.copyWith(status: GoodsStateStatus.searchStarted));

    final goods = await returnActsRepository.getBuyerGoods(
      buyerId: state.returnActEx.returnAct.buyerId!,
      name: state.goodsNameSearch,
      extraLabel: state.selectedGoodsFilter?.value,
      categoryId: state.selectedCategory?.id,
      goodsIds: state.showOnlyReturnAct ? state.filteredReturnActLinesExList.map((e) => e.line.goodsId).toList() : null,
      onlyLatest: state.showOnlyLatest,
      barcode: null
    );
    final categoryIds = goods.map((e) => e.categoryId).toSet();
    final visibleCategories = state.selectedCategory == null ?
      state.allCategories.where((e) => categoryIds.contains(e.id)).toList() :
      state.visibleCategories;
    final List<GoodsReturnDetail> goodsReturnDetails = !state.showAllGoods ?
      [] :
      await returnActsRepository.getGoodsReturnDetails(
        returnActTypeId: state.returnActEx.returnAct.returnActTypeId!,
        buyerId: state.returnActEx.returnAct.buyerId!,
        receptId: state.returnActEx.returnAct.receptId,
        goodsIds: goods.map((e) => e.id).toList()
      );

    emit(state.copyWith(
      status: GoodsStateStatus.searchFinished,
      goodsReturnDetails: goodsReturnDetails,
      visibleCategories: visibleCategories
    ));
  }

  void tryShowScan() async {
    if (!await Permissions.hasCameraPermissions()) {
      emit(state.copyWith(message: 'Не разрешено использование камеры', status: GoodsStateStatus.showScanFailure));
      return;
    }

    emit(state.copyWith(status: GoodsStateStatus.showScan));
  }

  Future<void> updateReturnActLine(GoodsReturnDetail goodsReturnDetail, {
    Optional<double>? vol,
    Optional<DateTime?>? productionDate,
    Optional<bool?>? isBad
  }) async {
    final returnActLineEx = (await returnActsRepository.getReturnActLineExList(state.returnActEx.returnAct.guid))
      .firstWhereOrNull((e) => e.line.goodsId == goodsReturnDetail.goodsEx.goods.id);

    if (vol != null && vol.value <= 0 && returnActLineEx != null) {
      await returnActsRepository.deleteReturnActLine(returnActLineEx.line);

      return;
    }

    if (returnActLineEx != null) {
      await returnActsRepository.updateReturnActLine(
        returnActLineEx.line,
        vol: vol,
        productionDate: productionDate,
        isBad: isBad
      );

      return;
    }

    await returnActsRepository.addReturnActLine(
      state.returnActEx.returnAct,
      goodsId: goodsReturnDetail.goods.id,
      vol: vol?.value ?? 1,
      productionDate: productionDate?.orNull,
      isBad: isBad?.orNull
    );
  }
}
