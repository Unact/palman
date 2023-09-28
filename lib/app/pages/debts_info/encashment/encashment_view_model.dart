part of 'encashment_page.dart';

class EncashmentViewModel extends PageViewModel<EncashmentState, EncashmentStateStatus> {
  final DebtsRepository debtsRepository;
  StreamSubscription<List<EncashmentEx>>? encashmentExListSubscription;

  EncashmentViewModel(this.debtsRepository, { required EncashmentEx encashmentEx }) :
    super(EncashmentState(encashmentEx: encashmentEx));

  @override
  EncashmentStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    encashmentExListSubscription = debtsRepository.watchEncashmentExList().listen((event) {
      emit(state.copyWith(
        status: EncashmentStateStatus.dataLoaded,
        encashmentEx: event.firstWhereOrNull((e) => e.encashment.id == state.encashmentEx.encashment.id)
      ));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await encashmentExListSubscription?.cancel();
  }

  Future<void> updateEncSum(double? encSum) async {
    final encashmentEx = state.encashmentEx;

    await debtsRepository.updateDebt(
      encashmentEx.debt!,
      debtSum: Optional.of(encashmentEx.debt!.debtSum + (encashmentEx.encashment.encSum ?? 0) - (encSum ?? 0)),
    );
    await debtsRepository.updateEncashment(
      encashmentEx.encashment,
      encSum: Optional.fromNullable(encSum)
    );

    emit(state.copyWith(status: EncashmentStateStatus.encashmentUpdated));
  }
}
