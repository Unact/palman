part of 'orders_info_page.dart';

class OrdersInfoViewModel extends PageViewModel<OrdersInfoState, OrdersInfoStateStatus> {
  final OrdersRepository ordersRepository;

  OrdersInfoViewModel(this.ordersRepository) : super(OrdersInfoState(), [ordersRepository]);

  @override
  OrdersInfoStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final preOrderExList = await ordersRepository.getPreOrderExList();

    emit(state.copyWith(
      status: OrdersInfoStateStatus.dataLoaded,
      preOrderExList: preOrderExList
    ));
  }
}
