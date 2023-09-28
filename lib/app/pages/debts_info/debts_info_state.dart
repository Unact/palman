part of 'debts_info_page.dart';

enum DebtsInfoStateStatus {
  initial,
  dataLoaded,
  encashmentAdded,
  encashmentDeleted
}

class DebtsInfoState {
  DebtsInfoState({
    this.status = DebtsInfoStateStatus.initial,
    this.debtExList = const [],
    this.encashmentExList = const [],
    this.deposits = const [],
    this.newEncashment
  });

  final DebtsInfoStateStatus status;

  final List<DebtEx> debtExList;
  final List<EncashmentEx> encashmentExList;
  final List<Deposit> deposits;
  final EncashmentEx? newEncashment;

  List<EncashmentEx> get encWithoutDeposit => encashmentExList.where((e) => e.deposit == null).toList();
  List<EncashmentEx> get encWithDeposit => encashmentExList.where((e) => e.deposit != null).toList();

  bool get canDeposit => encWithoutDeposit.isNotEmpty;

  DebtsInfoState copyWith({
    DebtsInfoStateStatus? status,
    List<DebtEx>? debtExList,
    List<EncashmentEx>? encashmentExList,
    List<Deposit>? deposits,
    EncashmentEx? newEncashment
  }) {
    return DebtsInfoState(
      status: status ?? this.status,
      debtExList: debtExList ?? this.debtExList,
      encashmentExList: encashmentExList ?? this.encashmentExList,
      deposits: deposits ?? this.deposits,
      newEncashment: newEncashment ?? this.newEncashment
    );
  }
}
