part of 'order_page.dart';

enum OrderStateStatus {
  initial,
  dataLoaded,
  orderUpdated,
  orderCopied,
  orderLineDeleted,
  orderRemoved
}

class OrderState {
  OrderState({
    this.status = OrderStateStatus.initial,
    required this.orderEx,
    this.user,
    this.message = '',
    this.linesExList = const [],
    this.workdates = const [],
    this.buyerExList = const [],
    this.newOrder,
    this.appInfo
  });

  final OrderStateStatus status;

  final User? user;
  final OrderExResult orderEx;
  final String message;
  final List<OrderLineExResult> linesExList;
  final List<Workdate> workdates;
  final List<BuyerEx> buyerExList;
  final OrderExResult? newOrder;
  final AppInfoResult? appInfo;

  bool get isEditable => orderEx.order.isEditable;
  bool get canBeProcessed => !orderEx.order.isEditable || filteredOrderLinesExList.isEmpty;

  List<OrderLineExResult> get filteredOrderLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get preOrderMode => user?.preOrderMode ?? false;

  bool get orderNeedSync => orderEx.order.needSync || linesExList.any((e) => e.line.needSync);

  int get pendingChanges => appInfo == null ?
    0 :
    (orderNeedSync ? 1 : 0) +
    appInfo!.partnerPricesToSync +
    appInfo!.partnersPricelistsToSync;

  OrderState copyWith({
    OrderStateStatus? status,
    User? user,
    String? message,
    OrderExResult? orderEx,
    List<OrderLineExResult>? linesExList,
    List<Workdate>? workdates,
    List<BuyerEx>? buyerExList,
    OrderExResult? newOrder,
    AppInfoResult? appInfo
  }) {
    return OrderState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
      orderEx: orderEx ?? this.orderEx,
      linesExList: linesExList ?? this.linesExList,
      workdates: workdates ?? this.workdates,
      buyerExList: buyerExList ?? this.buyerExList,
      newOrder: newOrder ?? this.newOrder,
      appInfo: appInfo ?? this.appInfo
    );
  }
}
