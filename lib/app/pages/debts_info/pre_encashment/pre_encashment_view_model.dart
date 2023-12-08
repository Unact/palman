part of 'pre_encashment_page.dart';

class PreEncashmentViewModel extends PageViewModel<PreEncashmentState, PreEncashmentStateStatus> {
  final DebtsRepository debtsRepository;
  StreamSubscription<List<PreEncashmentEx>>? preEncashmentExListSubscription;

  PreEncashmentViewModel(this.debtsRepository, { required PreEncashmentEx preEncashmentEx }) :
    super(PreEncashmentState(preEncashmentEx: preEncashmentEx));

  @override
  PreEncashmentStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    preEncashmentExListSubscription = debtsRepository.watchPreEncashmentExList().listen((event) {
      emit(state.copyWith(
        status: PreEncashmentStateStatus.dataLoaded,
        preEncashmentEx: event.firstWhereOrNull((e) => e.preEncashment.guid == state.preEncashmentEx.preEncashment.guid)
      ));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await preEncashmentExListSubscription?.cancel();
  }

  Future<void> updateEncSum(double? encSum) async {
    final preEncashmentEx = state.preEncashmentEx;

    await debtsRepository.updateDebt(
      preEncashmentEx.debt,
      debtSum: Optional.of(preEncashmentEx.debt.debtSum + (preEncashmentEx.preEncashment.encSum ?? 0) - (encSum ?? 0)),
    );
    await debtsRepository.updatePreEncashment(
      preEncashmentEx.preEncashment,
      encSum: Optional.fromNullable(encSum)
    );

    emit(state.copyWith(status: PreEncashmentStateStatus.encashmentUpdated));
  }
}
