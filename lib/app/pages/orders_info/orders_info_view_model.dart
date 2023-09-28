part of 'orders_info_page.dart';

class OrdersInfoViewModel extends PageViewModel<OrdersInfoState, OrdersInfoStateStatus> {
  final AppRepository appRepository;
  final OrdersRepository ordersRepository;
  final ShipmentsRepository shipmentsRepository;
  final PartnersRepository partnersRepository;
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

  Future<void> saveChanges() async {
    if (state.isBusy) return;

    emit(state.copyWith(status: OrdersInfoStateStatus.saveInProgress, isBusy: true));

    try {
      await _syncChanges();

      emit(state.copyWith(status: OrdersInfoStateStatus.saveSuccess, message: Strings.changesSaved, isBusy: false));
    } on AppError catch(e) {
      emit(state.copyWith(status: OrdersInfoStateStatus.saveFailure, message: e.message, isBusy: false));
    }
  }

  Future<void> _syncChanges() async {
    await usersRepository.refresh();

    final futures = [
      ordersRepository.syncChanges,
      shipmentsRepository.syncChanges
    ];

    await Future.wait(futures.map((e) => e.call()));
  }

  Future<void> tryGetData() async {
    if (state.hasPendingChanges) {
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

    if (state.isBusy) return;

    await usersRepository.refresh();

    final futures = [
      ordersRepository.loadRemains,
      ordersRepository.loadOrders,
      shipmentsRepository.loadShipments,
    ];

    emit(state.copyWith(status: OrdersInfoStateStatus.loadInProgress, isBusy: true));

    try {
      await Future.wait(futures.map((e) => e.call()));

      emit(state.copyWith(
        status: OrdersInfoStateStatus.loadSuccess,
        message: 'Данные успешно обновлены',
        isBusy: false
      ));
    } on AppError catch(e) {
      emit(state.copyWith(
        status: OrdersInfoStateStatus.loadFailure,
        message: e.message,
        isBusy: false
      ));
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
