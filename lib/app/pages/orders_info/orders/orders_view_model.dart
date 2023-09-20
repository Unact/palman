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
    emit(state.copyWith(orderExList: state.orderExList.where((e) => e != orderEx).toList()));
  }

  Future<void> tryGetData() async {
    if (state.orderExList.any((e) => e.order.needSync)) {
      emit(state.copyWith(status: OrdersStateStatus.loadConfirmation));
      return;
    }

    await getData(false);
  }

  Future<void> getData(bool declined) async {
    if (declined) {
      emit(state.copyWith(status: OrdersStateStatus.loadDeclined, message: 'Обновление отменено'));
      return;
    }

    final futures = [
      ordersRepository.loadRemains,
      ordersRepository.loadOrders
    ];

    emit(state.copyWith(status: OrdersStateStatus.loadInProgress));

    try {
      await Future.wait(futures.map((e) => e.call()));

      emit(state.copyWith(status: OrdersStateStatus.loadSuccess, message: 'Данные успешно обновлены',));
    } on AppError catch(e) {
      emit(state.copyWith(status: OrdersStateStatus.loadFailure, message: e.message));
    }
  }
}
