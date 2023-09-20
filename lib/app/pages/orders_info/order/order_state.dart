part of 'order_page.dart';

enum OrderStateStatus {
  initial,
  dataLoaded,
  orderUpdated,
  orderCopied,
  saveInProgress,
  saveFailure,
  saveSuccess
}

class OrderState {
  OrderState({
    this.status = OrderStateStatus.initial,
    required this.orderEx,
    this.user,
    this.message = '',
    this.linesExList = const [],
    this.workdates = const [],
    this.buyers = const [],
    this.newOrder
  });

  final OrderStateStatus status;

  final User? user;
  final OrderExResult orderEx;
  final String message;
  final List<OrderLineEx> linesExList;
  final List<Workdate> workdates;
  final List<Buyer> buyers;
  final OrderExResult? newOrder;

  bool get isEditable => orderEx.order.isEditable && !orderEx.order.needProcessing;
  bool get canBeProcessed => !orderEx.order.isEditable || filteredOrderLinesExList.isEmpty;

  List<OrderLineEx> get filteredOrderLinesExList => linesExList.where((e) => !e.line.isDeleted).toList();

  bool get preOrderMode => user?.preOrderMode ?? false;

  bool get needSync => orderEx.order.needSync || linesExList.any((e) => e.line.needSync);

  OrderState copyWith({
    OrderStateStatus? status,
    User? user,
    String? message,
    OrderExResult? orderEx,
    List<OrderLineEx>? linesExList,
    List<Workdate>? workdates,
    List<Buyer>? buyers,
    OrderExResult? newOrder
  }) {
    return OrderState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
      orderEx: orderEx ?? this.orderEx,
      linesExList: linesExList ?? this.linesExList,
      workdates: workdates ?? this.workdates,
      buyers: buyers ?? this.buyers,
      newOrder: newOrder ?? this.newOrder
    );
  }
}
