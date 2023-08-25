part of 'inc_requests_page.dart';

class IncRequestsViewModel extends PageViewModel<IncRequestsState, IncRequestsStateStatus> {
  final AppRepository appRepository;
  final ShipmentsRepository shipmentsRepository;
  final PartnersRepository partnersRepository;

  IncRequestsViewModel(this.appRepository, this.shipmentsRepository, this.partnersRepository) :
    super(IncRequestsState(), [appRepository, shipmentsRepository, partnersRepository]);

  @override
  IncRequestsStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final incRequestExList = await shipmentsRepository.getIncRequestExList();
    final buyers = await partnersRepository.getBuyers();

    emit(state.copyWith(
      status: IncRequestsStateStatus.dataLoaded,
      buyers: buyers,
      incRequestExList: incRequestExList
    ));
  }

  Future<void> addNewIncRequest() async {
    IncRequestEx newIncRequest = await shipmentsRepository.addIncRequest();

    emit(state.copyWith(
      status: IncRequestsStateStatus.incRequestAdded,
      newIncRequest: newIncRequest
    ));
  }

  Future<void> deleteIncRequest(IncRequestEx newIncRequestEx) async {
    await shipmentsRepository.deleteIncRequest(newIncRequestEx.incRequest);
  }
}
