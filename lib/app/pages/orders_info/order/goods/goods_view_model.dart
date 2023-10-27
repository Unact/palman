part of 'goods_page.dart';

class GoodsViewModel extends PageViewModel<GoodsState, GoodsStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  StreamSubscription<List<OrderExResult>>? orderExListSubscription;
  StreamSubscription<List<OrderLineExResult>>? orderLineExListSubscription;
  StreamSubscription<List<CategoriesExResult>>? categoriesSubscription;
  StreamSubscription<List<ShopDepartment>>? shopDepartmentsSubscription;
  StreamSubscription<List<GoodsFilter>>? goodsFiltersSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  GoodsViewModel(this.appRepository, this.ordersRepository, {required OrderExResult orderEx}) :
    super(GoodsState(orderEx: orderEx));

  @override
  GoodsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    orderExListSubscription = ordersRepository.watchOrderExList().listen((event) {
      emit(state.copyWith(
        status: GoodsStateStatus.dataLoaded,
        orderEx: event.firstWhereOrNull((e) => e.order.guid == state.orderEx.order.guid)
      ));
    });
    orderLineExListSubscription = ordersRepository.watchOrderLineExList(state.orderEx.order.guid).listen((event) {
      emit(state.copyWith(status: GoodsStateStatus.dataLoaded, linesExList: event));
    });
    categoriesSubscription = ordersRepository.watchCategories(buyerId: state.orderEx.order.buyerId!).listen((event) {
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

    await orderExListSubscription?.cancel();
    await orderLineExListSubscription?.cancel();
    await categoriesSubscription?.cancel();
    await shopDepartmentsSubscription?.cancel();
    await goodsFiltersSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> clearFilters() async {
    emit(state.copyWith(
      selectedCategory: const Optional.absent(),
      selectedGoodsFilter: const Optional.absent(),
      selectedBonusProgram: const Optional.absent(),
      showOnlyActive: false,
      showOnlyOrder: false,
      showOnlyLatest: false,
      goodsNameSearch: const Optional.absent(),
      goodsDetails: List.empty(),
      visibleCategories: state.allCategories
    ));
  }

  Future<void> selectBonusProgram(FilteredBonusProgramsResult? bonusProgram) async {
    emit(state.copyWith(
      selectedBonusProgram: Optional.fromNullable(bonusProgram),
      selectedCategory: const Optional.absent(),
      goodsDetails: []
    ));

    await searchGoods();
  }

  Future<void> selectCategory(CategoriesExResult? category) async {
    emit(state.copyWith(selectedCategory: Optional.fromNullable(category), goodsDetails: []));

    await searchGoods();
  }

  Future<void> setGoodsNameSearch(String? goodsNameSearch) async {
    emit(state.copyWith(
      goodsNameSearch: Optional.fromNullable(goodsNameSearch),
      selectedCategory: const Optional.absent(),
      goodsDetails: []
    ));

    await searchGoods();
  }

  Future<void> selectGoodsFilter(GoodsFilter? goodsFilter) async {
    emit(state.copyWith(
      selectedGoodsFilter: Optional.fromNullable(goodsFilter),
      selectedCategory: const Optional.absent(),
      goodsDetails: []
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

  Future<void> toggleShowOnlyActive() async {
    emit(state.copyWith(
      showOnlyActive: !state.showOnlyActive,
      selectedCategory: const Optional.absent(),
      goodsDetails: []
    ));

    await searchGoods();
  }

  Future<void> toggleShowOnlyLatest() async {
    emit(state.copyWith(
      showOnlyLatest: !state.showOnlyLatest,
      selectedCategory: const Optional.absent(),
      goodsDetails: []
    ));

    await searchGoods();
  }

  Future<void> toggleShowOnlyOrder() async {
    final newShowOnlyOrder = !state.showOnlyOrder;

    await clearFilters();
    emit(state.copyWith(showOnlyOrder: newShowOnlyOrder));

    if (newShowOnlyOrder) await searchGoods();
  }

  Future<void> searchGoods() async {
    emit(state.copyWith(status: GoodsStateStatus.searchStarted));

    final goods = await ordersRepository.getGoods(
      name: state.goodsNameSearch,
      extraLabel: state.selectedGoodsFilter?.value,
      categoryId: state.selectedCategory?.id,
      bonusProgramId: state.selectedBonusProgram?.id,
      goodsIds: state.showOnlyOrder ? state.filteredOrderLinesExList.map((e) => e.line.goodsId).toList() : null,
      onlyLatest: state.showOnlyLatest
    );
    final categoryIds = goods.map((e) => e.categoryId).toSet();
    final visibleCategories = state.selectedCategory == null ?
      state.allCategories.where((e) => categoryIds.contains(e.id)).toList() :
      state.visibleCategories;
    final List<GoodsDetail> goodsDetails = !state.showAllGoods ?
      [] :
      await ordersRepository.getGoodsDetails(
        buyerId: state.orderEx.buyer!.id,
        date: state.orderEx.order.date!,
        goodsIds: goods.map((e) => e.id).toList()
      );

    emit(state.copyWith(
      status: GoodsStateStatus.searchFinished,
      goodsDetails: goodsDetails,
      visibleCategories: visibleCategories
    ));
  }

  Future<void> updateGoodsPrices() async {
    await ordersRepository.updateOrderLinePrices(state.orderEx.order);
    await searchGoods();
  }

  Future<void> updateOrderLineVol(GoodsDetail goodsDetail, double? vol) async {
    final orderLineEx = (await ordersRepository.getOrderLineExList(state.orderEx.order.guid))
      .firstWhereOrNull((e) => e.line.goodsId == goodsDetail.goodsEx.goods.id);

    if (vol == null || vol <= 0) {
      if (orderLineEx != null) {
        await ordersRepository.deleteOrderLine(orderLineEx.line);
        await ordersRepository.updateOrderLine(orderLineEx.line, vol: Optional.of(0), restoreDeleted: false);
      }

      return;
    }

    if (orderLineEx != null) {
      await ordersRepository.updateOrderLine(orderLineEx.line, vol: Optional.of(vol));

      return;
    }

    await ordersRepository.addOrderLine(
      state.orderEx.order,
      goodsId: goodsDetail.goods.id,
      vol: vol,
      price: goodsDetail.price,
      priceOriginal: goodsDetail.pricelistPrice,
      rel: goodsDetail.rel,
      package: goodsDetail.package
    );
  }

  Future<void> updateOrderLinePrice(OrderLineExResult orderLineEx, double price) async {
    await ordersRepository.updateOrderLine(orderLineEx.line, price: Optional.of(price), handPrice: Optional.of(price));
  }
}
