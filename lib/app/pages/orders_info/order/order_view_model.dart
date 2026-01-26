part of 'order_page.dart';

class OrderViewModel extends PageViewModel<OrderState, OrderStateStatus> {
  final AppRepository appRepository;
  final PartnersRepository partnersRepository;
  final OrdersRepository ordersRepository;
  final PricesRepository pricesRepository;
  final UsersRepository usersRepository;
  final VisitsRepository visitsRepository;

  StreamSubscription<User>? userSubscription;
  StreamSubscription<List<OrderExResult>>? orderExListSubscription;
  StreamSubscription<List<OrderLineExResult>>? orderLineExListSubscription;
  StreamSubscription<List<BuyerEx>>? buyersSubscription;
  StreamSubscription<List<Workdate>>? workdatesSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;
  StreamSubscription<List<RoutePointEx>>? routePointListSubscription;

  OrderViewModel(
    this.appRepository,
    this.ordersRepository,
    this.partnersRepository,
    this.pricesRepository,
    this.usersRepository,
    this.visitsRepository,
    {
      required OrderExResult orderEx
    }
  ) : super(OrderState(orderEx: orderEx));

  @override
  OrderStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    userSubscription = usersRepository.watchUser().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, user: event));
    });
    orderExListSubscription = ordersRepository.watchOrderExList().listen((event) {
      final orderEx = event.firstWhereOrNull((e) => e.order.guid == state.orderEx.order.guid);

      if (orderEx == null) {
        emit(state.copyWith(status: OrderStateStatus.orderRemoved));
        return;
      }

      emit(state.copyWith(status: OrderStateStatus.dataLoaded, orderEx: orderEx));
    });
    orderLineExListSubscription = ordersRepository.watchOrderLineExList(state.orderEx.order.guid).listen((event) {
      emit(state.copyWith(
        status: OrderStateStatus.dataLoaded,
        linesExList: event
      ));
    });
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, buyerExList: event));
    });
    workdatesSubscription = appRepository.watchWorkdates().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, workdates: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, appInfo: event));
    });
    routePointListSubscription = visitsRepository.watchRoutePointExList().listen((event) {
      emit(state.copyWith(status: OrderStateStatus.dataLoaded, routePointExList: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await userSubscription?.cancel();
    await orderExListSubscription?.cancel();
    await orderLineExListSubscription?.cancel();
    await buyersSubscription?.cancel();
    await workdatesSubscription?.cancel();
    await appInfoSubscription?.cancel();
    await routePointListSubscription?.cancel();
  }

  Future<void> updateNeedProcessing() async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      status: Optional.of(state.orderEx.order.needProcessing ? OrderStatus.draft.value : OrderStatus.upload.value),
      needProcessing: Optional.of(!state.orderEx.order.needProcessing)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateBuyer(Buyer? buyer) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      buyerId: Optional.fromNullable(buyer?.id),
      date: const Optional.absent()
    );
    _notifyOrderUpdated();

    final hasUnvisited = state.routePointExList.any((e) =>
      e.routePoint.visited == null &&
      e.buyerEx.buyer.id == buyer?.id && e.
      routePoint.date == DateTime.now().date()
    );

    if (hasUnvisited) emit(state.copyWith(status: OrderStateStatus.unVisitedBuyerSelected));

  }

  Future<void> updateDate(DateTime? date) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      date: Optional.fromNullable(date)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateNeedInc(bool needInc) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      needInc: Optional.of(needInc)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateNeedDocs(bool needDocs) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      needDocs: Optional.of(needDocs)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateIsPhysical(bool isPhysical) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      isPhysical: Optional.of(isPhysical)
    );
    _notifyOrderUpdated();
  }

  Future<void> updateInfo(String info) async {
    await ordersRepository.updateOrder(
      state.orderEx.order,
      info: Optional.of(info)
    );
    _notifyOrderUpdated();
  }

  Future<void> deleteOrderLine(OrderLineExResult orderLineEx) async {
    await ordersRepository.deleteOrderLine(orderLineEx.line);
    emit(state.copyWith(
      status: OrderStateStatus.orderLineDeleted,
      linesExList: state.linesExList.where((e) => e != orderLineEx).toList()
    ));
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

  Future<void> syncChanges() async {
    final futures = [
      pricesRepository.syncChanges,
      () async {
        if (!state.orderNeedSync) return;

        await ordersRepository.syncOrders([state.orderEx.order], state.linesExList.map((e) => e.line).toList());
      }
    ];

    await Future.wait(futures.map((e) => e.call()));
  }

  void _notifyOrderUpdated() {
    emit(state.copyWith(status: OrderStateStatus.orderUpdated));
  }
}
