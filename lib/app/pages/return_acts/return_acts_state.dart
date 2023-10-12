part of 'return_acts_page.dart';

enum ReturnActsStateStatus {
  initial,
  dataLoaded,
  returnActAdded,
  returnActDeleted,
  buyerChanged
}

class ReturnActsState {
  ReturnActsState({
    this.status = ReturnActsStateStatus.initial,
    this.returnActExList = const [],
    this.newReturnAct,
    this.appInfo,
    this.isLoading = false,
    this.buyerExList = const [],
    this.selectedBuyer,
  });

  final ReturnActsStateStatus status;
  final bool isLoading;
  final List<ReturnActExResult> returnActExList;
  final ReturnActExResult? newReturnAct;
  final AppInfoResult? appInfo;
  final List<BuyerEx> buyerExList;
  final Buyer? selectedBuyer;

  int get pendingChanges => appInfo == null ? 0 : appInfo!.returnActsToSync;

  List<ReturnActExResult> get filteredReturnActExList => returnActExList
    .where((e) => selectedBuyer == null || e.buyer == selectedBuyer)
    .where((e) => !e.returnAct.isDeleted).toList();

  ReturnActsState copyWith({
    ReturnActsStateStatus? status,
    List<ReturnActExResult>? returnActExList,
    ReturnActExResult? newReturnAct,
    bool? isLoading,
    AppInfoResult? appInfo,
    List<BuyerEx>? buyerExList,
    Optional<Buyer>? selectedBuyer,
  }) {
    return ReturnActsState(
      status: status ?? this.status,
      returnActExList: returnActExList ?? this.returnActExList,
      newReturnAct: newReturnAct ?? this.newReturnAct,
      isLoading: isLoading ?? this.isLoading,
      appInfo: appInfo ?? this.appInfo,
      buyerExList: buyerExList ?? this.buyerExList,
      selectedBuyer: selectedBuyer != null ? selectedBuyer.orNull : this.selectedBuyer,
    );
  }
}
