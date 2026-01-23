part of 'debts_info_page.dart';

class DebtsInfoViewModel extends PageViewModel<DebtsInfoState, DebtsInfoStateStatus> {
  final AppRepository appRepository;
  final DebtsRepository debtsRepository;
  final UsersRepository usersRepository;
  StreamSubscription<List<PreEncashmentEx>>? preEncashmentExListSubscription;
  StreamSubscription<List<DebtEx>>? debtExListSubscription;
  StreamSubscription<List<Deposit>>? depositsSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;

  DebtsInfoViewModel(this.appRepository, this.debtsRepository, this.usersRepository): super(DebtsInfoState());

  @override
  DebtsInfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    preEncashmentExListSubscription = debtsRepository.watchPreEncashmentExList().listen((event) {
      emit(state.copyWith(
        status: DebtsInfoStateStatus.dataLoaded,
        preEncashmentExList: event
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

    await preEncashmentExListSubscription?.cancel();
    await debtExListSubscription?.cancel();
    await depositsSubscription?.cancel();
    await appInfoSubscription?.cancel();
  }

  Future<void> deposit() async {
    emit(state.copyWith(status: DebtsInfoStateStatus.depositInProgress));

    try {
      await debtsRepository.deposit();

      emit(state.copyWith(status: DebtsInfoStateStatus.depositSuccess, message: 'Инкассации успешно сданы'));
    } on AppError catch(e) {
      emit(state.copyWith(status: DebtsInfoStateStatus.depositFailure, message: e.message));
    }
  }

  Future<void> tryCreatePreEncashment(DebtEx debtEx) async {
    if (state.filteredPreEncashmentExList.any((e) => e.debt == debtEx.debt)) {
      emit(state.copyWith(
        status: DebtsInfoStateStatus.encashmentCreateConfirmation,
        newPreEncashmentDebtEx: debtEx
      ));
      return;
    }

    await createPreEncashment(debtEx);
  }

  Future<void> createPreEncashment(DebtEx debtEx) async {
    final newPreEncashment = await debtsRepository.addPreEncashment(debtEx.debt);

    emit(state.copyWith(
      status: DebtsInfoStateStatus.encashmentAdded,
      newPreEncashment: newPreEncashment
    ));
  }

  Future<void> deletePreEncashment(PreEncashmentEx preEncashmentEx) async {
    await debtsRepository.deletePreEncashment(preEncashmentEx.preEncashment);
    emit(state.copyWith(
      status: DebtsInfoStateStatus.encashmentDeleted,
      preEncashmentExList: state.preEncashmentExList.where((e) => e != preEncashmentEx).toList()
    ));

    if (preEncashmentEx.debt == null) return;

    await debtsRepository.updateDebt(
      preEncashmentEx.debt!,
      debtSum: Optional.of(preEncashmentEx.debt!.debtSum + (preEncashmentEx.preEncashment.encSum ?? 0)),
    );
  }

  Future<void> syncChanges() async {
    final futures = [
      debtsRepository.syncChanges
    ];

    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> getData() async {
    if (state.isLoading) return;

    final futures = [
      debtsRepository.loadDebts
    ];

    try {
      emit(state.copyWith(isLoading: true));
      await Future.wait(futures.map((e) => e.call()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
