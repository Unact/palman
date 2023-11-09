part of 'bonus_programs_page.dart';

enum BonusProgramsStateStatus {
  initial,
  dataLoaded,
  searchStarted,
  searchFinished
}

class BonusProgramsState {
  BonusProgramsState({
    this.status = BonusProgramsStateStatus.initial,
    required this.date,
    required this.buyer,
    required this.categoryEx,
    required this.goodsEx,
    this.bonusProgramGroups = const [],
    this.bonusPrograms = const [],
    this.selectedBonusProgramGroup,
    this.filterByCategory = false
  });

  final BonusProgramsStateStatus status;

  final DateTime date;
  final Buyer buyer;
  final CategoriesExResult? categoryEx;
  final GoodsExResult? goodsEx;
  final List<BonusProgramGroup> bonusProgramGroups;
  final List<FilteredBonusProgramsResult> bonusPrograms;

  final bool filterByCategory;
  final BonusProgramGroup? selectedBonusProgramGroup;

  BonusProgramsState copyWith({
    BonusProgramsStateStatus? status,
    DateTime? date,
    Buyer? buyer,
    CategoriesExResult? categoryEx,
    GoodsExResult? goodsEx,
    List<BonusProgramGroup>? bonusProgramGroups,
    List<FilteredBonusProgramsResult>? bonusPrograms,
    Optional<BonusProgramGroup>? selectedBonusProgramGroup,
    bool? filterByCategory
  }) {
    return BonusProgramsState(
      status: status ?? this.status,
      date: date ?? this.date,
      buyer: buyer ?? this.buyer,
      categoryEx: categoryEx ?? this.categoryEx,
      goodsEx: goodsEx ?? this.goodsEx,
      bonusProgramGroups: bonusProgramGroups ?? this.bonusProgramGroups,
      bonusPrograms: bonusPrograms ?? this.bonusPrograms,
      selectedBonusProgramGroup: selectedBonusProgramGroup != null ?
        selectedBonusProgramGroup.orNull :
        this.selectedBonusProgramGroup,
      filterByCategory: filterByCategory ?? this.filterByCategory
    );
  }
}
