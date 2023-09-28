part of 'bonus_programs_page.dart';

class BonusProgramsViewModel extends PageViewModel<BonusProgramsState, BonusProgramsStateStatus> {
  final OrdersRepository ordersRepository;
  StreamSubscription<List<BonusProgramGroup>>? bonusProgramGroupsSubscription;

  BonusProgramsViewModel(this.ordersRepository, {
    required DateTime date,
    required Buyer buyer,
    required CategoriesExResult? category,
    required GoodsExResult? goodsEx
  }) : super(BonusProgramsState(date: date, buyer: buyer, category: category, goodsEx: goodsEx));

  @override
  BonusProgramsStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    await _searchBonusPrograms();

    bonusProgramGroupsSubscription = ordersRepository.watchBonusProgramGroups(buyerId: state.buyer.id).listen((event) {
      emit(state.copyWith(status: BonusProgramsStateStatus.dataLoaded, bonusProgramGroups: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await bonusProgramGroupsSubscription?.cancel();
  }


  Future<void> changeFilterByCategory(bool? filterByCategory) async {
    emit(state.copyWith(
      status: BonusProgramsStateStatus.dataLoaded,
      filterByCategory: filterByCategory!
    ));

    await _searchBonusPrograms();
  }

  Future<void> changeSelectedBonusProgramGroup(BonusProgramGroup? bonusProgramGroup) async {
    emit(state.copyWith(
      status: BonusProgramsStateStatus.dataLoaded,
      selectedBonusProgramGroup: Optional.fromNullable(bonusProgramGroup)
    ));

    await _searchBonusPrograms();
  }

  Future<void> _searchBonusPrograms() async {
    emit(state.copyWith(status: BonusProgramsStateStatus.searchStarted));

    final bonusPrograms = await ordersRepository.getBonusPrograms(
      buyerId: state.buyer.id,
      date: state.date,
      bonusProgramGroupId: state.selectedBonusProgramGroup?.id,
      categoryId: state.filterByCategory ? state.category?.id : null,
      goodsId: state.goodsEx?.goods.id
    );

    emit(state.copyWith(status: BonusProgramsStateStatus.searchFinished, bonusPrograms: bonusPrograms));
  }
}
