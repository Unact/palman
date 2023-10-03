part of 'orders_info_page.dart';

class OrdersInfoViewModel extends PageViewModel<OrdersInfoState, OrdersInfoStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final ShipmentsRepository shipmentsRepository;
  final PartnersRepository partnersRepository;
  final PricesRepository pricesRepository;
  final UsersRepository usersRepository;
  StreamSubscription<List<PreOrderExResult>>? preOrderExListSubscription;
  StreamSubscription<List<ShipmentExResult>>? shipmentExListSubscription;
  StreamSubscription<List<Buyer>>? buyersSubscription;
  StreamSubscription<List<OrderExResult>>? orderExListSubscription;
  StreamSubscription<AppInfoResult>? appInfoSubscription;
  StreamSubscription<List<IncRequestEx>>? incRequestExListSubscription;

  OrdersInfoViewModel(
    this.appRepository,
    this.ordersRepository,
    this.partnersRepository,
    this.pricesRepository,
    this.shipmentsRepository,
    this.usersRepository
  ) : super(OrdersInfoState());

  @override
  OrdersInfoStateStatus get status => state.status;

  @override
  Future<void> initViewModel() async {
    await super.initViewModel();

    preOrderExListSubscription = ordersRepository.watchPreOrderExList().listen((event) {
      emit(state.copyWith(status: OrdersInfoStateStatus.dataLoaded, preOrderExList: event));
    });
    shipmentExListSubscription = shipmentsRepository.watchShipmentExList().listen((event) {
      emit(state.copyWith(status: OrdersInfoStateStatus.dataLoaded, shipmentExList: event));
    });
    buyersSubscription = partnersRepository.watchBuyers().listen((event) {
      emit(state.copyWith(status: OrdersInfoStateStatus.dataLoaded, buyers: event));
    });
    orderExListSubscription = ordersRepository.watchOrderExList().listen((event) {
      emit(state.copyWith(status: OrdersInfoStateStatus.dataLoaded, orderExList: event));
    });
    appInfoSubscription = appRepository.watchAppInfo().listen((event) {
      emit(state.copyWith(status: OrdersInfoStateStatus.dataLoaded, appInfo: event));
    });
    incRequestExListSubscription = shipmentsRepository.watchIncRequestExList().listen((event) {
      emit(state.copyWith(status: OrdersInfoStateStatus.dataLoaded, incRequestExList: event));
    });
  }

  @override
  Future<void> close() async {
    await super.close();

    await preOrderExListSubscription?.cancel();
    await shipmentExListSubscription?.cancel();
    await buyersSubscription?.cancel();
    await orderExListSubscription?.cancel();
    await appInfoSubscription?.cancel();
    await incRequestExListSubscription?.cancel();
  }

  Future<void> syncChanges() async {
    final futures = [
      ordersRepository.syncChanges,
      pricesRepository.syncChanges,
      shipmentsRepository.syncChanges
    ];

    await usersRepository.refresh();
    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> getData() async {
    if (state.isLoading) return;

    final futures = [
      ordersRepository.loadRemains,
      ordersRepository.loadOrders,
      shipmentsRepository.loadShipments,
    ];

    try {
      emit(state.copyWith(isLoading: true));
      await usersRepository.refresh();
      await Future.wait(futures.map((e) => e.call()));
    } finally {
      emit(state.copyWith(isLoading: false));
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
    emit(state.copyWith(
      status: OrdersInfoStateStatus.orderDeleted,
      orderExList: state.orderExList.where((e) => e != orderEx).toList()
    ));
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
    emit(state.copyWith(
      status: OrdersInfoStateStatus.incRequestDeleted,
      incRequestExList: state.incRequestExList.where((e) => e != newIncRequestEx).toList()
    ));
  }

  void selectBuyer(Buyer? buyer) {
    emit(state.copyWith(
      status: OrdersInfoStateStatus.buyerChanged,
      selectedBuyer: Optional.fromNullable(buyer)
    ));
  }
}
