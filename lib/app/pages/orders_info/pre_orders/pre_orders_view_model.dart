part of 'pre_orders_page.dart';

class PreOrdersViewModel extends PageViewModel<PreOrdersState, PreOrdersStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;

  PreOrdersViewModel(this.appRepository, this.ordersRepository) :
    super(PreOrdersState(), [appRepository, ordersRepository]);

  @override
  PreOrdersStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final preOrderExList = await ordersRepository.getPreOrderExList();

    emit(state.copyWith(
      status: PreOrdersStateStatus.dataLoaded,
      preOrderExList: preOrderExList
    ));
  }
}
