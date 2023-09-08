part of 'goods_page.dart';

class GoodsViewModel extends PageViewModel<GoodsState, GoodsStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final PricesRepository pricesRepository;

  GoodsViewModel(this.appRepository, this.ordersRepository, this.pricesRepository, {required OrderExResult orderEx}) :
    super(GoodsState(orderEx: orderEx), [appRepository, ordersRepository, pricesRepository]);

  @override
  GoodsStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final orderEx = await ordersRepository.getOrderEx(state.orderEx.order.id);
    final linesExList = await ordersRepository.getOrderLineExList(state.orderEx.order.id);
    final categories = await ordersRepository.getCategories();
    final shopDepartments = await ordersRepository.getShopDepartments();
    final goodsFilters = await ordersRepository.getGoodsFilters();
    final pref = await appRepository.getPref();

    emit(state.copyWith(
      status: GoodsStateStatus.dataLoaded,
      orderEx: orderEx,
      allCategories: categories,
      shopDepartments: shopDepartments,
      linesExList: linesExList,
      goodsFilters: goodsFilters,
      pref: pref
    ));
  }

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    emit(state.copyWith(visibleCategories: state.allCategories));
  }

  Future<void> clearFilters() async {
    emit(state.copyWith(
      selectedCategory: const Optional.absent(),
      selectedGoodsFilter: const Optional.absent(),
      selectedBonusProgram: const Optional.absent(),
      groupByManufacturer: false,
      showGroupInfo: false,
      showGoodsImage: false,
      showOnlyActive: false,
      showOnlyOrder: false,
      goodsNameSearch: const Optional.absent(),
      goodsDetails: List.empty(),
      visibleCategories: state.allCategories
    ));
  }

  Future<void> selectBonusProgram(FilteredBonusProgramsResult? bonusProgram) async {
    emit(state.copyWith(
      selectedBonusProgram: Optional.fromNullable(bonusProgram),
      selectedCategory: const Optional.absent()
    ));

    await searchGoods();
  }

  Future<void> selectCategory(Category? category) async {
    emit(state.copyWith(selectedCategory: Optional.fromNullable(category)));

    await searchGoods();
  }

  Future<void> setGoodsNameSearch(String? goodsNameSearch) async {
    emit(state.copyWith(
      goodsNameSearch: Optional.fromNullable(goodsNameSearch),
      selectedCategory: const Optional.absent()
    ));

    await searchGoods();
  }

  Future<void> selectGoodsFilter(GoodsFilter? goodsFilter) async {
    emit(state.copyWith(
      selectedGoodsFilter: Optional.fromNullable(goodsFilter),
      selectedCategory: const Optional.absent()
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
    emit(state.copyWith(showOnlyActive: !state.showOnlyActive));

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

    if (state.showOnlyOrder) {
      final goodsDetails = await ordersRepository.getGoodsDetails(
        buyerId: state.orderEx.buyer!.id,
        date: state.orderEx.order.date!,
        goodsIds: state.filteredOrderLinesExList.map((e) => e.goods.id).toList()
      );

      emit(state.copyWith(status: GoodsStateStatus.searchFinished, goodsDetails: goodsDetails));
      return;
    }

    final goods = await ordersRepository.getGoods(
      name: state.goodsNameSearch,
      extraLabel: state.selectedGoodsFilter?.value,
      categoryId: state.selectedCategory?.id,
      bonusProgramId: state.selectedBonusProgram?.id,
      buyerId: state.showOnlyActive ? state.orderEx.buyer!.id : null,
      goodsIds: null
    );
    final categoryIds = goods.map((e) => e.categoryId).toSet();
    final visibleCategories = state.selectedCategory == null ?
      state.allCategories.where((e) => categoryIds.contains(e.id)).toList() :
      state.visibleCategories;
    final List<GoodsDetail> goodsDetails = state.selectedCategory == null ?
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
    await updateOrderLinePrices();
    await searchGoods();
  }

  Future<void> updateOrderLinePrices() async {
    final goodsDetails = await ordersRepository.getGoodsDetails(
      buyerId: state.orderEx.buyer!.id,
      date: state.orderEx.order.date!,
      goodsIds: state.filteredOrderLinesExList.map((e) => e.goods.id).toList()
    );
    final orderLinesEx = (await ordersRepository.getOrderLineExList(state.orderEx.order.id));

    for (var orderLine in orderLinesEx) {
      final goodsDetail = goodsDetails.firstWhereOrNull((e) => e.goods == orderLine.goods);

      if (goodsDetail == null) continue;
      if (orderLine.line.price != orderLine.line.priceOriginal) continue;

      await ordersRepository.updateOrderLine(
        orderLine.line,
        price: Optional.of(goodsDetail.price),
        priceOriginal: Optional.of(goodsDetail.price),
        needSync: Optional.of(true)
      );
    }
  }

  Future<void> updateOrderLineVol(GoodsDetail goodsDetail, double? vol) async {
    final orderLineEx = (await ordersRepository.getOrderLineExList(state.orderEx.order.id))
      .firstWhereOrNull((e) => e.line.goodsId == goodsDetail.goodsEx.goods.id);

    if (vol == null || vol <= 0) {
      if (orderLineEx != null) await ordersRepository.deleteOrderLine(orderLineEx.line);

      return;
    }

    if (orderLineEx != null) {
      await ordersRepository.updateOrderLine(
        orderLineEx.line,
        vol: Optional.of(vol),
        rel: Optional.of(goodsDetail.rel),
        price: Optional.of(goodsDetail.price),
        priceOriginal: Optional.of(goodsDetail.pricelistPrice),
        package: Optional.of(goodsDetail.package),
        needSync: Optional.of(true)
      );

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
}
