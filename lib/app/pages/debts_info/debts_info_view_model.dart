part of 'debts_info_page.dart';

class DebtsInfoViewModel extends PageViewModel<DebtsInfoState, DebtsInfoStateStatus> {
  final AppRepository appRepository;
  final DebtsRepository debtsRepository;

  DebtsInfoViewModel(this.appRepository, this.debtsRepository) :
    super(DebtsInfoState(), [appRepository, debtsRepository]);

  @override
  DebtsInfoStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final debtExList = await debtsRepository.getDebtExList();
    final encashmentExList = await debtsRepository.getEncashmentExList();
    final deposits = await debtsRepository.getDeposits();

    emit(state.copyWith(
      status: DebtsInfoStateStatus.dataLoaded,
      debtExList: debtExList,
      encashmentExList: encashmentExList,
      deposits: deposits
    ));
  }

  Future<void> createDeposit() async {
    await debtsRepository.depositEncashments(DateTime.now().date(), state.encWithoutDeposit);
  }

  Future<void> createEncashment(DebtEx debtEx) async {
    final newEncashment = await debtsRepository.addEncashment(debtEx.debt, debtEx.buyer);

    emit(state.copyWith(
      status: DebtsInfoStateStatus.encashmentAdded,
      newEncashment: newEncashment
    ));
  }

  Future<void> deleteEncashment(EncashmentEx encashmentEx) async {
    await debtsRepository.updateDebt(
      encashmentEx.debt!,
      debtSum: Optional.of(encashmentEx.debt!.debtSum + (encashmentEx.encashment.encSum ?? 0)),
    );
    await debtsRepository.deleteEncashment(encashmentEx.encashment);
    emit(state.copyWith(encashmentExList: state.encashmentExList.where((e) => e != encashmentEx).toList()));
  }
}
