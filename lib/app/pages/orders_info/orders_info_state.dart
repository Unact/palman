part of 'orders_info_page.dart';

enum OrdersInfoStateStatus {
  initial,
  dataLoaded,
  orderAdded,
  orderDeleted,
  loadInProgress,
  loadConfirmation,
  loadDeclined,
  loadFailure,
  loadSuccess,
  saveInProgress,
  saveSuccess,
  saveFailure,
  buyerChanged,
  incRequestAdded,
  incRequestDeleted
}

class OrdersInfoState {
  OrdersInfoState({
    this.status = OrdersInfoStateStatus.initial,
    this.appInfo,
    this.isBusy = false,
    this.orderExList = const [],
    this.newOrder,
    this.message = '',
    this.incRequestExList = const [],
    this.newIncRequest,
    this.buyers = const [],
    this.shipmentExList = const [],
    this.selectedBuyer,
    this.preOrderExList = const []
  });

  final OrdersInfoStateStatus status;
  final bool isBusy;
  final List<OrderExResult> orderExList;
  final OrderExResult? newOrder;
  final List<IncRequestEx> incRequestExList;
  final IncRequestEx? newIncRequest;
  final List<Buyer> buyers;
  final List<ShipmentExResult> shipmentExList;
  final Buyer? selectedBuyer;
  final List<PreOrderExResult> preOrderExList;

  final String message;
  final AppInfoResult? appInfo;

  int get notSeenCnt => preOrderExList.where((e) => !e.wasSeen).length;

  int get pendingChanges => appInfo == null ?
    0 :
    appInfo!.ordersToSync +
    appInfo!.incRequestsToSync;
  bool get hasPendingChanges => pendingChanges != 0;

  List<OrderExResult> get filteredOrderExList => orderExList
    .where((e) => !e.order.isDeleted && e.order.detailedStatus != OrderStatus.deleted)
    .toList();

  List<IncRequestEx> get filteredIncRequestExList => incRequestExList
    .where((e) => !e.incRequest.isDeleted)
    .toList();

  List<ShipmentExResult> get filteredShipmentExList => shipmentExList
    .where((e) => selectedBuyer == null || e.buyer == selectedBuyer).toList();

  OrdersInfoState copyWith({
    OrdersInfoStateStatus? status,
    bool? isBusy,
    AppInfoResult? appInfo,
    List<OrderExResult>? orderExList,
    OrderExResult? newOrder,
    String? message,
    List<IncRequestEx>? incRequestExList,
    IncRequestEx? newIncRequest,
    List<Buyer>? buyers,
    List<ShipmentExResult>? shipmentExList,
    Optional<Buyer>? selectedBuyer,
    List<PreOrderExResult>? preOrderExList
  }) {
    return OrdersInfoState(
      status: status ?? this.status,
      isBusy: isBusy ?? this.isBusy,
      appInfo: appInfo ?? this.appInfo,
      orderExList: orderExList ?? this.orderExList,
      newOrder: newOrder ?? this.newOrder,
      message: message ?? this.message,
      incRequestExList: incRequestExList ?? this.incRequestExList,
      newIncRequest: newIncRequest ?? this.newIncRequest,
      buyers: buyers ?? this.buyers,
      shipmentExList: shipmentExList ?? this.shipmentExList,
      selectedBuyer: selectedBuyer != null ? selectedBuyer.orNull : this.selectedBuyer,
      preOrderExList: preOrderExList ?? this.preOrderExList
    );
  }
}
