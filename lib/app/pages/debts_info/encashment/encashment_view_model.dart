part of 'encashment_page.dart';

class EncashmentViewModel extends PageViewModel<EncashmentState, EncashmentStateStatus> {
  final AppRepository appRepository;
  final DebtsRepository debtsRepository;

  EncashmentViewModel(this.appRepository, this.debtsRepository, { required EncashmentEx encashmentEx }) :
    super(EncashmentState(encashmentEx: encashmentEx), [appRepository, debtsRepository]);

  @override
  EncashmentStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await debtsRepository.blockEncashments(true);

    await super.initViewModel();
  }

  @override
  Future<void> loadData() async {
    final encashmentEx = await debtsRepository.getEncashmentEx(state.encashmentEx.encashment.id);

    emit(state.copyWith(
      status: EncashmentStateStatus.dataLoaded,
      encashmentEx: encashmentEx
    ));
  }

  @override
  Future<void> close() async {
    await super.close();

    await debtsRepository.blockEncashments(false);
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
