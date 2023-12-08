part of 'debts_info_page.dart';

enum DebtsInfoStateStatus {
  initial,
  dataLoaded,
  encashmentAdded,
  encashmentDeleted,
  encashmentCreateConfirmation,
  depositInProgress,
  depositSuccess,
  depositFailure
}

class DebtsInfoState {
  DebtsInfoState({
    this.status = DebtsInfoStateStatus.initial,
    this.debtExList = const [],
    this.preEncashmentExList = const [],
    this.deposits = const [],
    this.newPreEncashment,
    this.newPreEncashmentDebtEx,
    this.appInfo,
    this.isLoading = false,
    this.message = ''
  });

  final DebtsInfoStateStatus status;
  final bool isLoading;
  final String message;
  final List<DebtEx> debtExList;
  final List<PreEncashmentEx> preEncashmentExList;
  final List<Deposit> deposits;
  final PreEncashmentEx? newPreEncashment;
  final DebtEx? newPreEncashmentDebtEx;
  final AppInfoResult? appInfo;

  int get pendingChanges => appInfo == null ? 0 : appInfo!.preEncashmentsToSync;

  bool get canDeposit => filteredPreEncashmentExList.isNotEmpty &&
    filteredPreEncashmentExList.every((e) => !e.preEncashment.needSync);

  List<PreEncashmentEx> get filteredPreEncashmentExList => preEncashmentExList
    .where((e) => !e.preEncashment.isDeleted).toList();

  DebtsInfoState copyWith({
    DebtsInfoStateStatus? status,
    List<DebtEx>? debtExList,
    List<PreEncashmentEx>? preEncashmentExList,
    List<Deposit>? deposits,
    PreEncashmentEx? newPreEncashment,
    DebtEx? newPreEncashmentDebtEx,
    bool? isLoading,
    String? message,
    AppInfoResult? appInfo,
  }) {
    return DebtsInfoState(
      status: status ?? this.status,
      debtExList: debtExList ?? this.debtExList,
      preEncashmentExList: preEncashmentExList ?? this.preEncashmentExList,
      deposits: deposits ?? this.deposits,
      newPreEncashment: newPreEncashment ?? this.newPreEncashment,
      newPreEncashmentDebtEx: newPreEncashmentDebtEx ?? this.newPreEncashmentDebtEx,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
