part of 'debts_info_page.dart';

class DebtsInfoViewModel extends PageViewModel<DebtsInfoState, DebtsInfoStateStatus> {
  final AppRepository appRepository;
  final DebtsRepository debtsRepository;
  final UsersRepository usersRepository;
  StreamSubscription<List<EncashmentEx>>? encashmentExListSubscription;
  StreamSubscription<List<DebtEx>>? debtExListSubscription;
  StreamSubscription<List<Deposit>>? depositsSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  DebtsInfoViewModel(this.appRepository, this.debtsRepository, this.usersRepository): super(DebtsInfoState());

  @override
  DebtsInfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    encashmentExListSubscription = debtsRepository.watchEncashmentExList().listen((event) {
      emit(state.copyWith(
        status: DebtsInfoStateStatus.dataLoaded,
        encashmentExList: event
      ));
    });
    debtExListSubscription = debtsRepository.watchDebtExList().listen((event) {
      emit(state.copyWith(
        status: DebtsInfoStateStatus.dataLoaded,
        debtExList: event
      ));
    });
    depositsSubscription = debtsRepository.watchDeposits().listen((event) {
      emit(state.copyWith(
        status: DebtsInfoStateStatus.dataLoaded,
        deposits: event
      ));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: DebtsInfoStateStatus.dataLoaded, appInfo: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await encashmentExListSubscription?.cancel();
    await debtExListSubscription?.cancel();
    await depositsSubscription?.cancel();
    await appInfoSubscription?.cancel();
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
    await debtsRepository.deleteEncashment(encashmentEx.encashment);
    emit(state.copyWith(
      status: DebtsInfoStateStatus.encashmentDeleted,
      encashmentExList: state.encashmentExList.where((e) => e != encashmentEx).toList()
    ));

    await debtsRepository.updateDebt(
      encashmentEx.debt!,
      debtSum: Optional.of(encashmentEx.debt!.debtSum + (encashmentEx.encashment.encSum ?? 0)),
    );
  }

  Future<void> syncChanges() async {
    final futures = [
      debtsRepository.syncChanges
    ];

    await usersRepository.refresh();
    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> getData() async {
    if (state.isLoading) return;

    final futures = [
      debtsRepository.loadDebts
    ];

    try {
      emit(state.copyWith(isLoading: true));
      await usersRepository.refresh();
      await Future.wait(futures.map((e) => e.call()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
