part of 'order_page.dart';

class OrderViewModel extends PageViewModel<OrderState, OrderStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final OrdersRepository ordersRepository;
  final UsersRepository usersRepository;

  OrderViewModel(
    this.appRepository,
    this.ordersRepository,
    this.partnersRepository,
    this.usersRepository,
    {
      required OrderExResult orderEx
    }
  ) : super(OrderState(orderEx: orderEx), [appRepository, ordersRepository, partnersRepository, usersRepository]);

  @override
  OrderStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await ordersRepository.blockOrders(true);

    await super.initViewModel();
  }

  @override
  Future<void> loadData() async {
    final user = await usersRepository.getUser();
    final orderEx = await ordersRepository.getOrderEx(state.orderEx.order.id);
    final linesExList = await ordersRepository.getOrderLineExList(state.orderEx.order.id);
    final workdates = await appRepository.getWorkdates();
    final buyers = await partnersRepository.getBuyers();

    emit(state.copyWith(
      status: OrderStateStatus.dataLoaded,
      user: user,
      orderEx: orderEx,
      linesExList: linesExList,
      buyers: buyers,
      workdates: workdates
    ));
  }

  @override
  Future<void> close() async {
    await super.close();

    await ordersRepository.blockOrders(false);
  }

  Future<void> updateNeedProcessing() async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      needProcessing: Optional.of(!state.orderEx.order.needProcessing),
      needSync: Optional.of(true),
    );
    _notifyOrderUpdated();
  }

  Future<void> updateBuyer(Buyer? buyer) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      buyerId: Optional.fromNullable(buyer?.id),
      needSync: Optional.of(true),
    );
    _notifyOrderUpdated();
  }

  Future<void> updateDate(DateTime? date) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      date: Optional.fromNullable(date),
      needSync: Optional.of(true)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateIsBonus(bool isBonus) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      isBonus: Optional.of(isBonus),
      needSync: Optional.of(true)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateNeedInc(bool needInc) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      needInc: Optional.of(needInc),
      needSync: Optional.of(true),
    );
    _notifyOrderUpdated();
  }

  Future<void> updateNeedDocs(bool needDocs) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      needDocs: Optional.of(needDocs),
      needSync: Optional.of(true),
    );
    _notifyOrderUpdated();
  }

  Future<void> updateIsPhysical(bool isPhysical) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      isPhysical: Optional.of(isPhysical),
      needSync: Optional.of(true),
    );
    _notifyOrderUpdated();
  }

  Future<void> updateInfo(String info) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      info: Optional.of(info),
      needSync: Optional.of(true),
    );
    _notifyOrderUpdated();
  }

  Future<void> deleteOrderLine(OrderLineEx orderLineEx) async {
    await ordersRepository.deleteOrderLine(orderLineEx.line);
  }

  void _notifyOrderUpdated() {
    emit(state.copyWith(status: OrderStateStatus.orderUpdated));
  }
}
