part of 'inc_request_page.dart';

class IncRequestViewModel extends PageViewModel<IncRequestState, IncRequestStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final ShipmentsRepository shipmentsRepository;

  IncRequestViewModel(
    this.appRepository,
    this.partnersRepository,
    this.shipmentsRepository,
    { required IncRequestEx incRequestEx }
  ) : super(IncRequestState(incRequestEx: incRequestEx), [appRepository, shipmentsRepository]);

  @override
  IncRequestStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await shipmentsRepository.blockIncRequests(true, ids: [state.incRequestEx.incRequest.id]);

    await super.initViewModel();
  }

  @override
  Future<void> loadData() async {
    final incRequestEx = await shipmentsRepository.getIncRequestEx(state.incRequestEx.incRequest.id);
    final workdates = await appRepository.getWorkdates();
    final buyers = await partnersRepository.getBuyers();

    emit(state.copyWith(
      status: IncRequestStateStatus.dataLoaded,
      incRequestEx: incRequestEx,
      workdates: workdates,
      buyers: buyers
    ));
  }

  @override
  Future<void> close() async {
    await super.close();

    await shipmentsRepository.blockIncRequests(false, ids: [state.incRequestEx.incRequest.id]);
  }

  Future<void> updateIncSum(double? incSum) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      incSum: Optional.fromNullable(incSum),
      needSync: Optional.of(true)
    );

    _notifyIncRequestUpdated();
  }

  Future<void> updateBuyer(Buyer? buyer) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      buyerId: Optional.fromNullable(buyer?.id),
      needSync: Optional.of(true)
    );

    _notifyIncRequestUpdated();
  }

  Future<void> updateInfo(String? info) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      info: Optional.fromNullable(info),
      needSync: Optional.of(true)
    );

    _notifyIncRequestUpdated();
  }

  Future<void> updateDate(DateTime? date) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      date: Optional.fromNullable(date),
      needSync: Optional.of(true)
    );

    _notifyIncRequestUpdated();
  }

  void _notifyIncRequestUpdated() {
    emit(state.copyWith(status: IncRequestStateStatus.incRequestUpdated));
  }
}
