part of 'orders_info_page.dart';

class OrdersInfoViewModel extends PageViewModel<OrdersInfoState, OrdersInfoStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final ShipmentsRepository shipmentsRepository;
  final PartnersRepository partnersRepository;

  OrdersInfoViewModel(this.appRepository, this.ordersRepository, this.partnersRepository, this.shipmentsRepository) :
    super(OrdersInfoState(), [appRepository, ordersRepository, shipmentsRepository, partnersRepository]);

  @override
  OrdersInfoStateStatus get status => state.status;

  @override
  Future<void> loadData() async {
    final preOrderExList = await ordersRepository.getPreOrderExList();
    final orderExList = await ordersRepository.getOrderExList();
    final shipmentExList = await shipmentsRepository.getShipmentExList();
    final buyers = await partnersRepository.getBuyers();
    final incRequestExList = await shipmentsRepository.getIncRequestExList();

    emit(state.copyWith(
      status: OrdersInfoStateStatus.dataLoaded,
      preOrderExList: preOrderExList,
      orderExList: orderExList,
      buyers: buyers,
      shipmentExList: shipmentExList,
      incRequestExList: incRequestExList
    ));
  }

  Future<void> tryGetData() async {
    if (state.orderExList.any((e) => e.order.needSync)) {
      emit(state.copyWith(status: OrdersInfoStateStatus.loadConfirmation));
      return;
    }

    await getData(false);
  }

  Future<void> getData(bool declined) async {
    if (declined) {
      emit(state.copyWith(status: OrdersInfoStateStatus.loadDeclined, message: 'Обновление отменено'));
      return;
    }

    final futures = [
      ordersRepository.loadRemains,
      ordersRepository.loadOrders
    ];

    emit(state.copyWith(status: OrdersInfoStateStatus.loadInProgress));

    try {
      await Future.wait(futures.map((e) => e.call()));

      emit(state.copyWith(status: OrdersInfoStateStatus.loadSuccess, message: 'Данные успешно обновлены',));
    } on AppError catch(e) {
      emit(state.copyWith(status: OrdersInfoStateStatus.loadFailure, message: e.message));
    }
  }

  Future<void> addNewOrder() async {
    final newOrder = await ordersRepository.addOrder();

    emit(state.copyWith(
      status: OrdersInfoStateStatus.orderAdded,
      newOrder: newOrder
    ));
  }

  Future<void> deleteOrder(OrderExResult orderEx) async {
    await ordersRepository.deleteOrder(orderEx.order);
    emit(state.copyWith(orderExList: state.orderExList.where((e) => e != orderEx).toList()));
  }

  Future<void> addNewIncRequest() async {
    IncRequestEx newIncRequest = await shipmentsRepository.addIncRequest();

    emit(state.copyWith(
      status: OrdersInfoStateStatus.incRequestAdded,
      newIncRequest: newIncRequest
    ));
  }

  Future<void> deleteIncRequest(IncRequestEx newIncRequestEx) async {
    await shipmentsRepository.deleteIncRequest(newIncRequestEx.incRequest);
    emit(state.copyWith(incRequestExList: state.incRequestExList.where((e) => e != newIncRequestEx).toList()));
  }

  void selectBuyer(Buyer? buyer) {
    emit(state.copyWith(
      status: OrdersInfoStateStatus.buyerChanged,
      selectedBuyer: Optional.fromNullable(buyer)
    ));
  }
}
