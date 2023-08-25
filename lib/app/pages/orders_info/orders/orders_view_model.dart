part of 'orders_page.dart';

class OrdersViewModel extends PageViewModel<OrdersState, OrdersStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;

  OrdersViewModel(this.appRepository, this.ordersRepository) : super(OrdersState(), [appRepository, ordersRepository]);

  @override
  OrdersStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final orderExList = await ordersRepository.getOrderExList();

    emit(state.copyWith(
      status: OrdersStateStatus.dataLoaded,
      orderExList: orderExList
    ));
  }

  Future<void> addNewOrder() async {
    final newOrder = await ordersRepository.addOrder();

    emit(state.copyWith(
      status: OrdersStateStatus.orderAdded,
      newOrder: newOrder
    ));
  }

  Future<void> deleteOrder(OrderExResult orderEx) async {
    await ordersRepository.deleteOrder(orderEx.order);
  }
}
