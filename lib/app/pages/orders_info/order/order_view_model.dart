part of 'order_page.dart';

class OrderViewModel extends PageViewModel<OrderState, OrderStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final OrdersRepository ordersRepository;
  final UsersRepository usersRepository;

  StreamSubscription<User>? userSubscription;
  StreamSubscription<List<OrderExResult>>? orderExListSubscription;
  StreamSubscription<List<OrderLineExResult>>? orderLineExListSubscription;
  StreamSubscription<List<Buyer>>? buyersSubscription;
  StreamSubscription<List<Workdate>>? workdatesSubscription;

  OrderViewModel(
    this.appRepository,
    this.ordersRepository,
    this.partnersRepository,
    this.usersRepository,
    {
      required OrderExResult orderEx
    }
  ) : super(OrderState(orderEx: orderEx));

  @override
  OrderStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await ordersRepository.blockOrders(true, ids: [state.orderEx.order.id]);

    await super.initViewModel();

    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, user: event));
    });
    orderExListSubscription = ordersRepository.watchOrderExList().listen((event) {
      emit(state.copyWith(
        status: OrderStateStatus.dataLoaded,
        orderEx: event.firstWhereOrNull((e) => e.order.id == state.orderEx.order.id)
      ));
    });
    orderLineExListSubscription = ordersRepository.watchOrderLineExList(state.orderEx.order.id).listen((event) {
      emit(state.copyWith(
        status: OrderStateStatus.dataLoaded,
        linesExList: event
      ));
    });
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, buyers: event));
    });
    workdatesSubscription = appRepository.watchWorkdates().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, workdates: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await ordersRepository.blockOrders(false, ids: [state.orderEx.order.id]);
    await userSubscription?.cancel();
    await orderExListSubscription?.cancel();
    await orderLineExListSubscription?.cancel();
    await buyersSubscription?.cancel();
    await workdatesSubscription?.cancel();
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

  Future<void> deleteOrderLine(OrderLineExResult orderLineEx) async {
    await ordersRepository.deleteOrderLine(orderLineEx.line);
    emit(state.copyWith(linesExList: state.linesExList.where((e) => e != orderLineEx).toList()));
  }

  Future<void> copy() async {
    final orderEx = await ordersRepository.copyOrder(
      state.orderEx.order,
      state.linesExList.map((e) => e.line).toList()
    );

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
      await orderLineExListSubscription?.cancel();
      orderLineExListSubscription = ordersRepository.watchOrderLineExList(orders.first.order.id).listen((event) {
        emit(state.copyWith(
          status: OrderStateStatus.dataLoaded,
          linesExList: event
        ));
      });

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
