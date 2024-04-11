part of 'inc_request_page.dart';

class IncRequestViewModel extends PageViewModel<IncRequestState, IncRequestStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final ShipmentsRepository shipmentsRepository;
  StreamSubscription<List<BuyerEx>>? buyersSubscription;
  StreamSubscription<List<IncRequestEx>>? incRequestExListSubscription;
  StreamSubscription<List<Workdate>>? workdatesSubscription;

  IncRequestViewModel(
    this.appRepository,
    this.partnersRepository,
    this.shipmentsRepository,
    { required IncRequestEx incRequestEx }
  ) : super(IncRequestState(incRequestEx: incRequestEx));

  @override
  IncRequestStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    incRequestExListSubscription = shipmentsRepository.watchIncRequestExList().listen((event) {
      emit(state.copyWith(
        status: IncRequestStateStatus.dataLoaded,
        incRequestEx: event.firstWhereOrNull((e) => e.incRequest.guid == state.incRequestEx.incRequest.guid)
      ));
    });
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: IncRequestStateStatus.dataLoaded, buyerExList: event));
    });
    workdatesSubscription = appRepository.watchWorkdates().listen((event) {
      emit(state.copyWith(status: IncRequestStateStatus.dataLoaded, workdates: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await incRequestExListSubscription?.cancel();
    await buyersSubscription?.cancel();
    await workdatesSubscription?.cancel();
  }

  Future<void> updateIncSum(double? incSum) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      incSum: Optional.fromNullable(incSum)
    );

    _notifyIncRequestUpdated();
  }

  Future<void> updateBuyer(Buyer? buyer) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      buyerId: Optional.fromNullable(buyer?.id),
      date: const Optional.absent()
    );

    _notifyIncRequestUpdated();
  }

  Future<void> updateInfo(String? info) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      info: Optional.fromNullable(info)
    );

    _notifyIncRequestUpdated();
  }

  Future<void> updateDate(DateTime? date) async {
    await shipmentsRepository.updateIncRequest(
      state.incRequestEx.incRequest,
      date: Optional.fromNullable(date)
    );

    _notifyIncRequestUpdated();
  }

  void _notifyIncRequestUpdated() {
    emit(state.copyWith(status: IncRequestStateStatus.incRequestUpdated));
  }
}
