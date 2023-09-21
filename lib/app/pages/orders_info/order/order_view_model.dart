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
    await ordersRepository.blockOrders(true, ids: [state.orderEx.order.id]);

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

    await ordersRepository.blockOrders(false, ids: [state.orderEx.order.id]);
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
    emit(state.copyWith(linesExList: state.linesExList.where((e) => e != orderLineEx).toList()));
  }

  Future<void> copy() async {
    final orderEx = await ordersRepository.addOrder(
      needProcessing: false,
      preOrderId: null,
      buyerId: state.orderEx.order.buyerId,
      date: state.orderEx.order.date,
      needDocs: state.orderEx.order.needDocs,
      isBonus: state.orderEx.order.isBonus,
      isPhysical: state.orderEx.order.isPhysical,
      needInc: state.orderEx.order.needInc
    );

    for (var orderLine in state.linesExList) {
      await ordersRepository.addOrderLine(
        orderEx.order,
        goodsId: orderLine.goods.id,
        vol: orderLine.line.vol,
        price: orderLine.line.price,
        priceOriginal: orderLine.line.priceOriginal,
        package: orderLine.line.package,
        rel: orderLine.line.rel
      );
    }

    emit(state.copyWith(
      status: OrderStateStatus.orderCopied,
      newOrder: orderEx,
      message: 'Создан дубликат'
    ));
  }

  Future<void> save() async {
    emit(state.copyWith(status: OrderStateStatus.saveInProgress));

    try {
      final orders = await ordersRepository.syncOrders(
        [state.orderEx.order],
        state.linesExList.map((e) => e.line).toList()
      );

      await ordersRepository.blockOrders(true, ids: [orders.first.order.id]);

      emit(state.copyWith(
        orderEx: orders.first,
        status: OrderStateStatus.saveSuccess,
        message: Strings.changesSaved
      ));
    } on AppError catch(e) {
      emit(state.copyWith(status: OrderStateStatus.saveFailure, message: e.message));
    }
  }

  void _notifyOrderUpdated() {
    emit(state.copyWith(status: OrderStateStatus.orderUpdated));
  }
}
